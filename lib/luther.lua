require("lib/term")

Luther = {}
function Luther.run(eventHandler, drawHandler)
    Term.enterRawMode()
    Term.enableMouseEvents()

    local function main()
        local running = true
        while running do
            local key = Term.readImmediate(1)
            if key then
                running = eventHandler(key)
            end
            Term.clear()
            Term.setCursorPosition(1, 1)
            drawHandler()
            Term.flush()
        end
    end
    local status = xpcall(main, function(err)
        Term.flush()
        Term.disableMouseEvents()
        Term.leaveRawMode()
        local traceback = debug.traceback()
        io.stderr:write(err .. "\n" .. traceback .. "\n")
        if os.getenv("DEBUG") == "1" then
            debug.debug()
        end
    end)

    if status then
        Term.flush()
        Term.disableMouseEvents()
        Term.leaveRawMode()
    end
end
