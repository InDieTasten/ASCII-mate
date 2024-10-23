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

local canvasX
local canvasY
local resizing = false
local toolbarWidth = 12
local tools = {
    {
        name = "Pencil",
        char = "O"
    },
    {
        name = "Eraser"
    },
    {
        name = "Fill"
    },
    {
        name = "Line"
    },
    {
        name = "Rectangle",
        char = "+"
    },
    {
        name = "Ellipse"
    }
}
local pencil = 1
local eraser = 2
local rectangle = 5
local selectedTool = pencil

local function update(inputs)
    for _, input in ipairs(inputs) do
        if input.type == "char" and input.char == "q" then -- Q
            Term.showCursor()
            return false
        elseif input.type == "char" and input.char == "p" then -- P
            selectedTool = pencil
        elseif input.type == "char" and input.char == "e" then -- E
            selectedTool = eraser
        elseif input.type == "char" and input.char == "r" then -- R
            selectedTool = rectangle
        elseif input.type == "raw" and input.hex == "13" then  -- Ctrl + S
            local file = io.open(fileName, "w")
            if file then
                file:write(Canvas.toText(canvas))
                file:close()
            else
                error("Could not open file for writing.")
            end
        elseif input.type == "mouse_move" then
            if resizing and input.button == 0 then
                local newWidth = input.x - canvasX - 1
                local newHeight = input.y - canvasY - 1
                if newWidth >= 1 and newHeight >= 1 then
                    canvas = Canvas.resize(canvas, newWidth, newHeight)
                end
            elseif selectedTool == pencil and input.button == 0 then -- pencil
                local x = input.x - canvasX
                local y = input.y - canvasY
                if x >= 1 and x <= canvas.width and y >= 1 and y <= canvas.height then
                    Canvas.setPixel(canvas, x, y, tools[pencil].char)
                end
            elseif selectedTool == eraser and input.button == 0 then -- eraser
                local x = input.x - canvasX
                local y = input.y - canvasY
                if x >= 1 and x <= canvas.width and y >= 1 and y <= canvas.height then
                    Canvas.setPixel(canvas, x, y, " ")
                end
            elseif selectedTool == rectangle and input.button == 0 then -- rectangle
                local x = input.x - canvasX
                local y = input.y - canvasY
                if tools[rectangle].start then
                    tools[rectangle].fin = { x, y }
                end
            end
        elseif input.type == "mouse_press" then
            if input.x == canvasX + canvas.width + 1 and input.y == canvasY + canvas.height + 1 then
                resizing = true
            elseif input.x >= Term.width - toolbarWidth + 1 and input.y >= 2 and input.y <= #tools + 1 then
                selectedTool = input.y - 1
            elseif selectedTool == pencil and input.button == 0 then
                local x = input.x - canvasX
                local y = input.y - canvasY
                if x >= 1 and x <= canvas.width and y >= 1 and y <= canvas.height then
                    Canvas.setPixel(canvas, x, y, tools[pencil].char)
                end
            elseif selectedTool == eraser and input.button == 0 then
                local x = input.x - canvasX
                local y = input.y - canvasY
                if x >= 1 and x <= canvas.width and y >= 1 and y <= canvas.height then
                    Canvas.setPixel(canvas, x, y, " ")
                end
            elseif selectedTool == rectangle and input.button == 0 then
                tools[rectangle].start = { input.x - canvasX, input.y - canvasY }
            end
        elseif input.type == "mouse_release" then
            resizing = false
            if selectedTool == pencil and input.button == 0 then -- pencil
                local x = input.x - canvasX
                local y = input.y - canvasY
                if x >= 1 and x <= canvas.width and y >= 1 and y <= canvas.height then
                    Canvas.setPixel(canvas, x, y, tools[pencil].char)
                end
            elseif selectedTool == rectangle and input.button == 0 then -- rectangle
                local x = input.x - canvasX
                local y = input.y - canvasY
                if tools[rectangle].start and tools[rectangle].fin then
                    local x1, y1 = tools[rectangle].start[1], tools[rectangle].start[2]
                    local x2, y2 = tools[rectangle].fin[1], tools[rectangle].fin[2]
                    local xMin, xMax = math.min(x1, x2), math.max(x1, x2)
                    local yMin, yMax = math.min(y1, y2), math.max(y1, y2)
                    for x = xMin, xMax do
                        Canvas.trySetPixel(canvas, x, yMin, tools[rectangle].char)
                        Canvas.trySetPixel(canvas, x, yMax, tools[rectangle].char)
                    end
                    for y = yMin, yMax do
                        Canvas.trySetPixel(canvas, xMin, y, tools[rectangle].char)
                        Canvas.trySetPixel(canvas, xMax, y, tools[rectangle].char)
                    end
                    tools[rectangle].start = nil
                    tools[rectangle].fin = nil
                end
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

local function drawOverlayPixel(x, y, char)
    local posX = x + canvasX
    local posY = y + canvasY
    if posX >= 1 and posX <= Term.width - toolbarWidth - 2 and posY >= 1 and posY <= Term.height then
        Term.setCursorPos(posX, posY)
        Term.write(char)
    end
end

local function render()
    TermUI.clear(Term, "+")

    --canvas area
    TermUI.drawCanvas(Term, canvas, canvasX + 1, canvasY + 1)
    --current tool overlay
    if selectedTool == rectangle and tools[rectangle].start and tools[rectangle].fin then
        local x1, y1 = tools[rectangle].start[1], tools[rectangle].start[2]
        local x2, y2 = tools[rectangle].fin[1], tools[rectangle].fin[2]
        local xMin, xMax = math.min(x1, x2), math.max(x1, x2)
        local yMin, yMax = math.min(y1, y2), math.max(y1, y2)
        for x = xMin, xMax do
            drawOverlayPixel(x, yMin, tools[rectangle].char)
            drawOverlayPixel(x, yMax, tools[rectangle].char)
        end
        for y = yMin, yMax do
            drawOverlayPixel(xMin, y, tools[rectangle].char)
            drawOverlayPixel(xMax, y, tools[rectangle].char)
        end
    end
    Term.setCursorPos(canvasX + canvas.width + 1, canvasY + canvas.height + 1)
    Term.write("%")

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
        Term.write(tool.name)
    end

    Term.flush()
end

Term.hideCursor()
Term.runApp(update, render)
