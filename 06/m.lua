-- Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.

sumsquare = function( num )
    local r = 0
    for i = 1, num do
        r = r + i
    end

    return r * r
end

squresum = function( num )
    local r = 0
    for i = 1, num do
        r = r + i * i
    end

    return r
end

mydo = function( N )
    N = tonumber(N)
    return sumsquare(N) - squresum(N)
end

print( mydo( ... ) )

