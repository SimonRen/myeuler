local N = ...
N = N or 600851475143

local halfN = math.ceil( N/2 )

function checkPrimer( num )
    for i = 2, math.ceil( num/2 )do
        if num % i == 0 then
            return false
        end
    end

    return true
end

function mydo()
    for i = 2, halfN do
        if N % i == 0 then
            if checkPrimer(N/i) then
                return N/i
            end
        end
    end

    return 1
end

print( mydo() )

