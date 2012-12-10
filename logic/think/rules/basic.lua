local print = print
local pairs = pairs
local ipairs = ipairs
local random = math.random
local tinsert = table.insert
local setmetatable = setmetatable

module "think.rules.basic"

rating = function()
    return random(1,100)
end

