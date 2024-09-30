require("lib/term")

local lastInputs = {}

local function update(inputs)
    if #inputs > 0 then
        lastInputs = inputs
    end

    for _, input in ipairs(inputs) do
        if input[1] == "char" and input[2] == "q" then
            return false
        end
    end

    return true
end

local function render()
    Term.clear()
    Term.setCursorPos(1, 1)
    Term.write("Last inputs: \n\r")
    for _, input in ipairs(lastInputs) do
        if input[1] == "mouse" then
            Term.write(table.concat(input, ", ") .. "\r\n")
        end
    end
    Term.flush()
end

Term.runApp(update, render)
