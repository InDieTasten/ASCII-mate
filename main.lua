require("lib/term")

Term.enterRawMode()
Term.enableMouseEvents()
local function main()
    while true do
        local key = Term.readWithTimeout(1, 0.05)
        if key then
            io.write("Key: " .. string.byte(key) .. "\r\n")
            if key == "q" then
                break
            elseif key == "s" then
                local x, y = Term.getCursorPosition()
                Term.write("Cursor position: " .. x .. ", " .. y .. "\r\n")
            end
        end
        Term.flush()
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
