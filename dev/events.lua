require("../lib/term")

local lastInputs = {}

local function formatTable(tbl)
    local str = "{ "
    local kvps = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            v = formatTable(v)
        elseif type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        local kvp = k .. " = " .. tostring(v)
        table.insert(kvps, kvp)
    end
    str = str .. table.concat(kvps, ", ") .. " }"
    return str
end
local function formatEvent(event)
    return formatTable(event)
end

local function update(inputs)
    if #inputs > 0 then
        lastInputs = inputs
    end

    for _, input in ipairs(inputs) do
        if input.type == "char" and input.char == "q" then
            return false
        end
    end

    return true
end

local function render()
    Term.clear()
    Term.setCursorPos(1, 1)
    Term.write("Last inputs: \n\r")
    for _, event in ipairs(lastInputs) do
        Term.write(formatEvent(event) .. "\r\n")
    end
    Term.flush()
end

Term.runApp(update, render)
