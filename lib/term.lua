Term = {}
Term.backlog = ""
--- Enters raw mode for the terminal
--- This will disable echo and line buffering
--- It will also switch to the alternate screen buffer
function Term.enterRawMode()
    os.execute("/bin/stty raw")
    os.execute("/bin/stty -echo")
    os.execute("/bin/tput smcup")
end

--- Leaves raw mode for the terminal
--- This will re-enable echo and line buffering
--- It will also switch back to the main screen buffer
function Term.leaveRawMode()
    os.execute("/bin/tput rmcup")
    os.execute("/bin/stty echo")
    os.execute("/bin/stty sane")
end

--- Requests the cursor position from the terminal.
--- Terminal will respond with a sequence like `\27[<row>;<col>R`.
--- We capture the response from stdin and parse it.
--- If other input is received, it is stored in backlog for later processing.
--- @return number row: X position of cursor (0 indexed)
--- @return number col: Y position of cursor (0 indexed)
function Term.getCursorPosition()
    io.write("\27[6n")
    io.flush()
    local readBack = ""
    while true do
        local current = io.read(1)
        if #readBack > 0 or current == "\27" then
            readBack = readBack .. current
        else
            Term.backlog = Term.backlog .. current
        end
        if current == "R" then
            break
        end
        assert(#readBack < 1000, "Readback too long")
        assert(#Term.backlog < 1000, "Backlog too long")
    end

    local row = tonumber(string.match(readBack, "%[(%d+);"))
    local col = tonumber(string.match(readBack, ";(%d+)"))

    assert(type(row) == "number", "Failed to parse row")
    assert(type(col) == "number", "Failed to parse col")

    return row, col
end

--- Reads n characters from the terminal
--- If there are characters in the backlog, they are used first
--- @param n number: number of characters to read
--- @return string input: input read from stdin
function Term.read(n)
    assert(n > 0, "n must be greater than 0")
    local input = ""
    if #Term.backlog > 0 then
        input = input .. string.sub(Term.backlog, 1, n)
        Term.backlog = string.sub(Term.backlog, n + 1)
    end
    if #input < n then
        input = input .. io.read(n - #input)
    end
    return input
end

--- Reads n characters from the stdin with a timeout.
--- This will delay the input by the timeout duration.
--- @param n number: number of characters to read
--- @param timeout number: in seconds
--- @return string? input: input read from string, or nil, if we ran into the specified timeout
function Term.readWithTimeout(n, timeout)
    assert(n > 0, "n must be greater than 0")

    -- If we have enough characters in the backlog, we can return them immediately.
    if #Term.backlog >= n then
        return Term.read(n)
    end

    -- Here we wait for the timeout to expire. This is the time frame in which users can queue up input.
    os.execute("/bin/sleep " .. timeout)
    -- Before we try to read form the input buffer, we need to make sure we can receive something immediately, if the user has not queued anything up.
    -- We use the cursor position request for this.
    io.write("\27[6n")
    io.flush()
    local readBack = ""
    while true do
        local current = io.read(1)
        if #readBack > 0 or current == "\27" then
            readBack = readBack .. current
        else
            Term.backlog = Term.backlog .. current
        end
        if current == "R" then
            break
        end
        assert(#readBack < 1000, "Readback too long")
        assert(#Term.backlog < 1000, "Backlog too long")
    end

    if #Term.backlog < n then
        return nil
    else
        return Term.read(n)
    end
end

return Term
