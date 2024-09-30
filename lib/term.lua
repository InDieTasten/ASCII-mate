Term = {}
Term.internalInputBuffer = ""
Term.internalOutputBuffer = ""

function Term.runApp(updateFunction, renderFunction)
    Term.enterRawMode()
    Term.enableMouseEvents()
    local function main()
        while true do
            local input = Term.readWithTimeout(1, 0.05)
            if #Term.internalInputBuffer > 0 then
                input = input .. Term.read(#Term.internalInputBuffer)
            end

            if not updateFunction(input) then
                break
            end

            renderFunction()
        end
    end

    local status = xpcall(main, function(err)
        Term.flush()
        Term.leaveRawMode()
        Term.disableMouseEvents()
        local traceback = debug.traceback()
        io.stderr:write(err .. "\n" .. traceback .. "\n")
        if os.getenv("DEBUG") == "1" then
            debug.debug()
        end
    end)

    if status then
        Term.flush()
        Term.leaveRawMode()
        Term.disableMouseEvents()
    end
end

function Term.clear()
    io.write("\27[2J")
end

--- Enters raw mode for the terminal
--- This will disable echo and line buffering
--- It will also switch to the alternate screen buffer
function Term.enterRawMode()
    os.execute("/bin/stty raw")
    os.execute("/bin/stty -echo")
    io.write("\27[?1049h")
    io.flush()
end

--- Leaves raw mode for the terminal
--- This will re-enable echo and line buffering
--- It will also switch back to the main screen buffer
function Term.leaveRawMode()
    io.write("\27[?1049l")
    io.flush()
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
            Term.internalInputBuffer = Term.internalInputBuffer .. current
        end
        if current == "R" then
            break
        end
        assert(#readBack < 1000, "Readback too long")
        assert(#Term.internalInputBuffer < 1000, "Backlog too long")
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
    if #Term.internalInputBuffer > 0 then
        input = input .. string.sub(Term.internalInputBuffer, 1, n)
        Term.internalInputBuffer = string.sub(Term.internalInputBuffer, n + 1)
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
    if #Term.internalInputBuffer >= n then
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
            Term.internalInputBuffer = Term.internalInputBuffer .. current
        end
        if current == "R" then
            break
        end
        if current == "M" or current == "m" then
            local mode = tonumber(string.match(readBack, "^\27%[<(%d+);%d+;%d+[Mm]$")) or "undetected"
            local x = tonumber(string.match(readBack, "^\27%[<%d+;(%d+);%d+[Mm]$")) or "undetected"
            local y = tonumber(string.match(readBack, "^\27%[<%d+;%d+;(%d+)[Mm]$")) or "undetected"
            Term.write("Mouse Event: \"" ..
                string.sub(readBack, 2) .. "\" Decoded mode: " .. mode .. " x: " .. x .. " y: " .. y .. "\n\r")
            readBack = ""
        end
        assert(#readBack < 1000, "Readback too long")
        assert(#Term.internalInputBuffer < 1000, "Backlog too long")
    end

    if #Term.internalInputBuffer < n then
        return nil
    else
        return Term.read(n)
    end
end

function Term.enableMouseEvents()
    Term.write("\27[?1000h")
    Term.write("\27[?1002h")
    Term.write("\27[?1003h")
    Term.write("\27[?1015h")
    Term.write("\27[?1006h")
    Term.flush()
end

function Term.disableMouseEvents()
    Term.write("\27[?1000l")
    Term.write("\27[?1002l")
    Term.write("\27[?1003l")
    Term.write("\27[?1015l")
    Term.write("\27[?1006l")
    Term.flush()
end

--- Allows to write to the output buffer without flushing it.
--- Useful to ensure that an entire rerenderd frame is queued in the buffer before flushing to the terminal.
--- Also, intermediate terminal requests can be made while building the frame without interfering with the output.
--- Be sure to call Term.flush() after you are done writing to the buffer.
--- @param str string: string to write to the output buffer
function Term.write(str)
    Term.internalOutputBuffer = Term.internalOutputBuffer .. str
end

--- Flushes the output buffer to the terminal.
--- This will write the entire buffer to the terminal and flush it.
function Term.flush()
    io.write(Term.internalOutputBuffer)
    io.flush()
    Term.internalOutputBuffer = ""
end

return Term
