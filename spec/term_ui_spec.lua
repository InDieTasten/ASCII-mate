local TermUI = require("lib.term-ui")

describe("TermUI", function()
    describe("drawCanvas", function()
        it("should draw the canvas on the terminal context", function()
            local termContext = {
                setCursorPos = function() end,
                write = function() end
            }
            local canvas = {
                width = 3,
                height = 2,
                pixels = {
                    { "A", "B", "C" },
                    { "D", "E", "F" }
                }
            }
            stub(termContext, "setCursorPos")
            stub(termContext, "write")
            TermUI.drawCanvas(termContext, canvas, 1, 1)
            assert.stub(termContext.setCursorPos).was.called_with(1, 1)
            assert.stub(termContext.write).was.called_with("ABC")
            assert.stub(termContext.setCursorPos).was.called_with(1, 2)
            assert.stub(termContext.write).was.called_with("DEF")
        end)
    end)

    describe("clear", function()
        it("should clear the terminal context with the specified character", function()
            local termContext = {
                setCursorPos = function() end,
                write = function() end,
                width = 3,
                height = 2
            }
            stub(termContext, "setCursorPos")
            stub(termContext, "write")
            TermUI.clear(termContext, "X")
            assert.stub(termContext.setCursorPos).was.called_with(1, 1)
            assert.stub(termContext.write).was.called_with("XXX")
            assert.stub(termContext.setCursorPos).was.called_with(1, 2)
            assert.stub(termContext.write).was.called_with("XXX")
        end)
    end)

    describe("fillRect", function()
        it("should fill the specified rectangle with the given character", function()
            local termContext = {
                setCursorPos = function() end,
                write = function() end
            }
            stub(termContext, "setCursorPos")
            stub(termContext, "write")
            TermUI.fillRect(termContext, 1, 1, 3, 2, "X")
            assert.stub(termContext.setCursorPos).was.called_with(1, 1)
            assert.stub(termContext.write).was.called_with("XXX")
            assert.stub(termContext.setCursorPos).was.called_with(1, 2)
            assert.stub(termContext.write).was.called_with("XXX")
        end)
    end)
end)
