require("lib/term")
require("lib/canvas")
require("lib/term-ui")

local cursorX
local cursorY

local canvas

local function update(inputs)
    for _, input in ipairs(inputs) do
        if input.type == "char" and input.char == "q" then
            Term.showCursor()
            return false
        elseif input.type == "mouse_move" then
            cursorX = input.x
            cursorY = input.y
        elseif input.type == "mouse_press" then
            if canvas then
                Canvas.setPixel(canvas, input.x, input.y, "O")
            end
        elseif input.type == "resize" then
            canvas = Canvas.new(Term.width, Term.height)
        end
    end

    return true
end

local function render()
    Term.clear()

    if canvas then
        TermUI.drawCanvas(Term, canvas, 1, 1)
    end

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
