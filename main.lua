require("lib/term")

Term.enterRawMode()
local function main()
    while true do
        local key = Term.readWithTimeout(1, 0.05)
        if key then
            io.write("Key: " .. string.byte(key) .. "\r\n")
            if key == "q" then
                break
            elseif key == "s" then
                local x, y = Term.getCursorPosition()
                io.write("Cursor position: " .. x .. ", " .. y .. "\r\n")
            end
        else
            io.write("Rerender me\r\n")
        end
        io.flush()
    end
end

local status = xpcall(main, function(err)
    Term.leaveRawMode()
    local traceback = debug.traceback()
    io.stderr:write(err .. "\n" .. traceback .. "\n")
    if os.getenv("DEBUG") == "1" then
        debug.debug()
    end
end)

if status then
    Term.leaveRawMode()
end
