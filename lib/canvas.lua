Canvas = {}

function Canvas.new(width, height)
    local canvas = {}
    canvas.width = width
    canvas.height = height
    canvas.pixels = {}
    for y = 1, height do
        canvas.pixels[y] = {}
        for x = 1, width do
            canvas.pixels[y][x] = " "
        end
    end
    return canvas
end

function Canvas.setPixel(canvas, x, y, char)
    assert(type(canvas) == "table", "canvas must be a table")
    assert(type(x) == "number", "x must be a number")
    assert(type(y) == "number", "y must be a number")
    assert(type(char) == "string", "char must be a string")
    assert(x >= 1, "x must be greater than or equal to 1")
    assert(x <= canvas.width, "x must be less than or equal to the canvas width")
    assert(y >= 1, "y must be greater than or equal to 1")
    assert(y <= canvas.height, "y must be less than or equal to the canvas height")

    canvas.pixels[y][x] = char
end

function Canvas.toText(canvas)
    assert(type(canvas) == "table", "canvas must be a table")

    local text = ""
    for y = 1, canvas.height do
        for x = 1, canvas.width do
            text = text .. canvas.pixels[y][x]
        end
        text = text .. "\n"
    end
    return text
end

function Canvas.fromText(text)
    assert(type(text) == "string", "text must be a string")

    local lines = {}
    for line in string.gmatch(text, "([^\n]+)") do
        table.insert(lines, line)
    end
    local width = #lines[1]
    local height = #lines
    local canvas = Canvas.new(width, height)
    for y = 1, height do
        local line = lines[y]
        for x = 1, width do
            local char = line:sub(x, x)
            Canvas.setPixel(canvas, x, y, char)
        end
    end

    return canvas
end

function Canvas.resize(canvas, newWidth, newHeight)
    assert(type(canvas) == "table", "canvas must be a table")
    assert(type(newWidth) == "number", "newWidth must be a number")
    assert(type(newHeight) == "number", "newHeight must be a number")
    assert(newWidth >= 1, "newWidth must be greater than or equal to 1")
    assert(newHeight >= 1, "newHeight must be greater than or equal to 1")

    local newCanvas = Canvas.new(newWidth, newHeight)
    for y = 1, math.min(canvas.height, newHeight) do
        for x = 1, math.min(canvas.width, newWidth) do
            newCanvas.pixels[y][x] = canvas.pixels[y][x]
        end
    end
    return newCanvas
end

Canvas.tests = {
    moduleLoads = function()
        assert(true, "This cannot fail.")
    end,
}

return Canvas
