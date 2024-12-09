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
end)