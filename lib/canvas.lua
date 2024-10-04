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

Canvas.tests = {
    moduleLoads = function()
        assert(true, "This cannot fail.")
    end,
}

return Canvas
