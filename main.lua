require("lib/term")
require("lib/canvas")
require("lib/term-ui")

local defaultCanvasWidth = 20
local defaultCanvasHeight = 10
local fileName = ({ ... })[1] or "ascii-art"

local fileHandle = io.open(fileName, "r")
local canvas
if fileHandle then
    local fileContents = fileHandle:read("*a")
    fileHandle:close()
    canvas = Canvas.fromText(fileContents)
else
    canvas = Canvas.new(defaultCanvasWidth, defaultCanvasHeight)
end

local cursorX
local cursorY
local canvasX
local canvasY
local toolbarWidth = 12
local tools = {
    "Pencil",
    "Eraser",
    "Fill",
    "Line",
    "Rectangle",
    "Ellipse",
}
local selectedTool = 1

local function update(inputs)
    for _, input in ipairs(inputs) do
        if input.type == "char" and input.char == "q" then
            Term.showCursor()
            return false
        elseif input.type == "raw" and input.hex == "13" then -- Ctrl + S
            local file = io.open(fileName, "w")
            if file then
                file:write(Canvas.toText(canvas))
                file:close()
            else
                error("Could not open file for writing.")
            end
        elseif input.type == "mouse_move" then
            cursorX = input.x
            cursorY = input.y
        elseif input.type == "mouse_press" then
            if input.x > canvasX and input.x <= canvasX + canvas.width and
                input.y > canvasY and input.y <= canvasY + canvas.height then
                Canvas.setPixel(canvas, input.x - canvasX, input.y - canvasY, "O")
            end
        elseif input.type == "resize" then
            canvasX = math.floor(Term.width / 2 - canvas.width / 2)
            canvasY = math.floor(Term.height / 2 - canvas.height / 2)
        elseif input.type == "mouse_scroll" then
            local amplify = input.mods.shift and 3 or 1
            if input.mods.ctrl then
                if input.dir == "up" then
                    canvasX = canvasX + 2 * amplify
                elseif input.dir == "down" then
                    canvasX = canvasX - 2 * amplify
                end
            else
                if input.dir == "up" then
                    canvasY = canvasY + 1 * amplify
                elseif input.dir == "down" then
                    canvasY = canvasY - 1 * amplify
                end
            end
        end
    end

    return true
end

local function render()
    TermUI.clear(Term, "+")

    --canvas area
    if canvas then
        TermUI.drawCanvas(Term, canvas, canvasX + 1, canvasY + 1)
    end

    -- debug info
    Term.setCursorPos(1, 1)
    Term.write("Press Q to quit.")
    Term.setCursorPos(1, 2)
    Term.write("Dimensions: " .. Term.width .. "x" .. Term.height)

    -- toolbar
    TermUI.fillRect(Term, Term.width - toolbarWidth + 1, 1, toolbarWidth, Term.height, " ")
    TermUI.fillRect(Term, Term.width - toolbarWidth, 1, 1, Term.height, "|")
    Term.setCursorPos(Term.width - toolbarWidth + 1, 1)
    Term.write("TOOLS")
    for i, tool in ipairs(tools) do
        Term.setCursorPos(Term.width - toolbarWidth + 1, i + 1)
        if i == selectedTool then
            Term.write("> ")
        else
            Term.write("  ")
        end
        Term.write(tool)
    end

    if cursorX and cursorY and cursorX < Term.width - toolbarWidth then
        Term.setCursorPos(cursorX, cursorY)
        Term.write("X")
    end
    Term.flush()
end

Term.hideCursor()
Term.runApp(update, render)
