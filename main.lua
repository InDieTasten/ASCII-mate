require("lib/term")
require("lib/luther")

local function draw()
    Term.write("Hello, world!")
end

local function handle(event)
    event = event or "none"
    Term.write("Event: " .. event)
    Term.flush()
    os.execute("sleep 1")
    if event == "q" then
        return false
    end

    return true
end

Luther.run(draw, handle)
