local MAX = ...
MAX = tonumber(MAX)

local result = 2
local sum = function(v)
    result = result + v
end

local mydo = function()
    local v1 = 1
    local v2 = 2
    local v3 = 0
    while (true) do
        v3 = v1 + v2
        if v3 > MAX then return end

        if v3 % 2 == 0 then sum( v3 ) end 

        v1, v2 = v2, v3
    end
end

mydo()
print( '\n\n' .. result )

