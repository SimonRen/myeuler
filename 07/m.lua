local needcount = ...
needcount = needcount or 10001
needcount = tonumber(needcount)

function checkPrimer( num )
    for i = 2, math.ceil( num/2 )do
        if num % i == 0 then
            return false
        end
    end

    return true
end

local count = 0
local i = 2
while (true) do
    if checkPrimer(i) then
        count = count + 1
        if count == needcount then 
            print( i )
            return 
        end
    end
    i = i + 1
end

