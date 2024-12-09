local Term = require("lib.term")

describe("Term", function()
    describe("decodeMouseEvent", function()
        it("should decode mouse press event", function()
            local event = Term.decodeMouseEvent(0, 10, 5, "M")
            assert.are.equal("mouse_press", event.type)
            assert.are.equal(10, event.x)
            assert.are.equal(5, event.y)
            assert.are.equal(0, event.button)
        end)

        it("should decode mouse release event", function()
            local event = Term.decodeMouseEvent(0, 10, 5, "m")
            assert.are.equal("mouse_release", event.type)
            assert.are.equal(10, event.x)
            assert.are.equal(5, event.y)
            assert.are.equal(0, event.button)
        end)

        it("should decode mouse scroll event", function()
            local event = Term.decodeMouseEvent(64, 10, 5, "M")
            assert.are.equal("mouse_scroll", event.type)
            assert.are.equal(10, event.x)
            assert.are.equal(5, event.y)
            assert.are.equal("up", event.dir)
        end)

        it("should decode mouse move event", function()
            local event = Term.decodeMouseEvent(32, 10, 5, "M")
            assert.are.equal("mouse_move", event.type)
            assert.are.equal(10, event.x)
            assert.are.equal(5, event.y)
        end)
    end)

    describe("parseInput", function()
        it("should parse character input", function()
            local inputs = Term.parseInput("a")
            assert.are.equal(1, #inputs)
            assert.are.equal("char", inputs[1].type)
            assert.are.equal("a", inputs[1].char)
        end)

        it("should parse raw input", function()
            local inputs = Term.parseInput("\27")
            assert.are.equal(1, #inputs)
            assert.are.equal("raw", inputs[1].type)
            assert.are.equal("1B", inputs[1].hex)
        end)

        it("should parse mouse event input", function()
            local inputs = Term.parseInput("\27[<0;10;5M")
            assert.are.equal(1, #inputs)
            assert.are.equal("mouse_press", inputs[1].type)
            assert.are.equal(10, inputs[1].x)
            assert.are.equal(5, inputs[1].y)
            assert.are.equal(0, inputs[1].button)
        end)
    end)

    describe("runApp", function()
        it("should run the application and call update and render functions", function()
            local updateCalled = false
            local renderCalled = false
            local function update()
                updateCalled = true
                return false
            end
            local function render()
                renderCalled = true
            end
            Term.runApp(update, render)
            assert.is_true(updateCalled)
            assert.is_true(renderCalled)
        end)
    end)

    describe("clear", function()
        it("should clear the terminal screen", function()
            Term.clear()
            -- No assertion needed, just ensure no errors
        end)
    end)

    describe("setCursorPos", function()
        it("should set the cursor position", function()
            Term.setCursorPos(10, 5)
            -- No assertion needed, just ensure no errors
        end)
    end)

    describe("hideCursor", function()
        it("should hide the cursor", function()
            Term.hideCursor()
            -- No assertion needed, just ensure no errors
        end)
    end)

    describe("showCursor", function()
        it("should show the cursor", function()
            Term.showCursor()
            -- No assertion needed, just ensure no errors
        end)
    end)

    describe("enterRawMode", function()
        it("should enter raw mode", function()
            Term.enterRawMode()
            -- No assertion needed, just ensure no errors
        end)
    end)

    describe("leaveRawMode", function()
        it("should leave raw mode", function()
            Term.leaveRawMode()
            -- No assertion needed, just ensure no errors
        end)
    end)

    describe("getCursorPosition", function()
        it("should get the cursor position", function()
            local row, col = Term.getCursorPosition()
            assert.is_number(row)
            assert.is_number(col)
        end)
    end)

    describe("read", function()
        it("should read n characters from the terminal", function()
            local input = Term.read(1)
            assert.is_string(input)
        end)
    end)

    describe("tryRead", function()
        it("should try to read n characters from the terminal", function()
            local input = Term.tryRead(1)
            assert.is_string(input)
        end)
    end)

    describe("enableMouseEvents", function()
        it("should enable mouse events", function()
            Term.enableMouseEvents()
            -- No assertion needed, just ensure no errors
        end)
    end)

    describe("disableMouseEvents", function()
        it("should disable mouse events", function()
            Term.disableMouseEvents()
            -- No assertion needed, just ensure no errors
        end)
    end)

    describe("write", function()
        it("should write to the output buffer", function()
            Term.write("test")
            -- No assertion needed, just ensure no errors
        end)
    end)

    describe("flush", function()
        it("should flush the output buffer", function()
            Term.flush()
            -- No assertion needed, just ensure no errors
        end)
    end)
end)
