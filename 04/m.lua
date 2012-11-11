--[[
A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91*99.

Find the largest palindrome made from the product of two 3-digit numbers.
--]]

curmax = 0
v1 = 0
v2 = 0

function isPalindromic( num )
    local strnum = tostring(num)
    if strnum == string.reverse(strnum) then
        return true
    else
        return false
    end
end

function mydo()
    for i = 999, 100, -1 do
        for j = i, 100, -1 do
            v = i * j
            if isPalindromic( v ) then
                if v > curmax then
                    v1 = i
                    v2 = j
                    curmax = v
                end
            end
        end
    end
end

mydo()

print( string.format( "%d * %d = %d", v1, v2, curmax ) )
