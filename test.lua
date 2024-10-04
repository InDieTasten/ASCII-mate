local termTests = require("lib.term").tests
local canvasTests = require("lib.canvas").tests
local termUITests = require("lib.term-ui").tests

local allTests = {}

local function addTests(prefix, tests)
    for name, testFunc in pairs(tests) do
        table.insert(allTests, { prefix .. "." .. name, testFunc })
    end
end

addTests("term", termTests)
addTests("canvas", canvasTests)
addTests("term-ui", termUITests)

print("Running " .. #allTests .. " tests...")
print("")
local passed = 0
local failed = 0
for _, test in pairs(allTests) do
    local testName = test[1]
    local testFunc = test[2]
    io.write("Running test " .. testName .. "... ")
    local success, err = pcall(testFunc)
    if success then
        print("Passed!")
        passed = passed + 1
    else
        print("Failed: " .. err)
        failed = failed + 1
    end
end
print("")
if failed == 0 then
    print("Tests passed: " .. passed .. ", failed: " .. failed)
else
    error("Tests passed: " .. passed .. ", failed: " .. failed)
end
