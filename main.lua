require("lib/term")

local state = 0

local function update(input)
    if input ~= nil then
        for i = 1, #input do
            local char = input:sub(i, i)
            if char == "q" then
                return false
            elseif char == "+" then
                state = state + 1
            elseif char == "-" then
                state = state - 1
            end
        end
    end

    return true
end

local function render()
    --Term.clear()
    --Term.setCursorPos(1, 1)
    Term.write("State: " .. tostring(state) .. "\n\r")
    Term.flush()
end

Term.runApp(update, render)
