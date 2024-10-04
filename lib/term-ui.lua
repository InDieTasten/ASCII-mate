TermUI = {}

function TermUI.drawCanvas(termContext, canvas, x, y)
    for i = 1, canvas.height do
        termContext.setCursorPos(x, y + i - 1)
        termContext.write(table.concat(canvas.pixels[i]))
    end
end

TermUI.tests = {
    moduleLoads = function()
        assert(true, "This cannot fail.")
    end,
}

return TermUI
