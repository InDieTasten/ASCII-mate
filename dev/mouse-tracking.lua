require("../lib/term")

local cursorX
local cursorY

local function update(inputs)
    for _, input in ipairs(inputs) do
        if input.type == "char" and input.char == "q" then
            Term.showCursor()
            return false
        elseif input.type == "mouse_move" then
            cursorX = input.x
            cursorY = input.y
        end
    end

    return true
end

local function render()
    Term.clear()
    Term.setCursorPos(1, 1)
    Term.write("Press Q to quit.")

    Term.setCursorPos(1, 2)
    Term.write("Dimensions: " .. Term.width .. "x" .. Term.height)

    if cursorX and cursorY then
        Term.setCursorPos(cursorX, cursorY)
        Term.write("X")
    end
    Term.flush()
end

Term.hideCursor()
Term.runApp(update, render)
