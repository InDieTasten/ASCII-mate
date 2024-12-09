TermUI = {}

function TermUI.drawCanvas(termContext, canvas, x, y)
    for i = 1, canvas.height do
        termContext.setCursorPos(x, y + i - 1)
        termContext.write(table.concat(canvas.pixels[i]))
    end
end

function TermUI.clear(termContext, char)
    for y = 1, termContext.height do
        termContext.setCursorPos(1, y)
        termContext.write(string.rep(char or " ", termContext.width))
    end
end

function TermUI.fillRect(termContext, x, y, width, height, char)
    for i = 1, height do
        termContext.setCursorPos(x, y + i - 1)
        termContext.write(string.rep(char or " ", width))
    end
end

return TermUI
