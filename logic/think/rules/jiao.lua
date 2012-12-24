--
-- Created by IntelliJ IDEA.
-- User: Simon
-- Date: 12-12-24
-- Time: 下午1:02
-- To change this template use File | Settings | File Templates.
--

local print = print
local pairs = pairs
local ipairs = ipairs
local random = math.random
local tinsert = table.insert
local setmetatable = setmetatable
local tsort = table.sort
local util_shallowcopy = util_shallowcopy
local util_mjSort = util_mjSort
local algo_Hu = algo_Hu

module "think.rules.peng"

point_base = 10

processJiao = function( config, room, my_seat, hand_seq_part )
    local score, count_of_card_left = 0, 1

    if (hand_seq_part.lack and #hand_seq_part.lack ~= 0) then return 0, 1 end

    local types =
    {
        "wan",
        "tong",
        "tiao",
    }

    for _, card_type in ipairs( {1,2,3} ) do
        for _, card_sub in ipairs({1,2,3,4,5,6,7,8,9}) do
            local seq = hand_seq_part[ types[card_type] ]
            local new_seq = util_shallowcopy( seq )

            local card_value = card_type * 10 + card_sub
            local same_card_count = 0
            for _, v in ipairs(new_seq) do
                if v == card_value then same_card_count = same_card_count + 1 end
            end

            if same_card_count < 4 then
                tinsert( new_seq, card_value )
                tsort( new_seq, util_mjSort )
                hand_seq_partt[ types[card_type] ] = new_seq
                local isHued = algo_Hu( hand_seq_part )
                hand_seq_partt[ types[card_type] ] = seq

                if isHued then
                    score = score + point_base * count_of_card_left
                end
            end
        end
    end

    return score
end

rating = function( config, room, seat_index )
    local my_seat = room.seats[ seat_index ]
    local score = processPeng( config, room, my_seat, my_seat.hand_seq )
    return score
end