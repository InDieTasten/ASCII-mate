require("lib/term")

term.enterRawMode()
function main()
    while true do
        local key = io.read(1)
        if key == "q" then
            break
        end
        print("Pressed key code: " .. string.byte(key).."\r")
    end
end

local status = xpcall(main, function (err)
    term.leaveRawMode()
    traceback = debug.traceback()
    io.stderr:write(err.."\n"..traceback.."\n")
    if os.getenv("DEBUG") == "1" then
        debug.debug()
    end
end)

if status then
    term.leaveRawMode()
end
