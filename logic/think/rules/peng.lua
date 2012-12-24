--
-- Created by IntelliJ IDEA.
-- User: Simon
-- Date: 12-12-24
-- Time: 下午12:44
-- To change this template use File | Settings | File Templates.
--

local print = print
local pairs = pairs
local ipairs = ipairs
local random = math.random
local tinsert = table.insert
local setmetatable = setmetatable

module "think.rules.peng"

point_base = 10

processPeng = function( config, room, my_seat, hand_seq_part )
    local count, card_to_peng = 0, 1
    local peng_data = {}

    for _, v in ipairs(hand_seq_part) do
        peng_data[ v ] = peng_data[ v ] and peng_data[v] + 1 or 1
    end

    for _, v in pairs(peng_data) do
        if (v == 2) then
            count = count and count + 1 or 1
        end
    end

    return count, card_to_peng
end

rating = function( config, room, seat_index )
    local my_seat = room.seats[ seat_index ]
    local score = 0
    for _, v in ipairs( { my_seat.wan, my_seat.tong, my_seat.tiao } ) do
        local count, card_to_peng = processPeng( config, room, my_seat, v )
        score = score + count * card_to_peng * point_base
    end

    return score
end
