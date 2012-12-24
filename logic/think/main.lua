local print = print
local pairs = pairs
local ipairs = ipairs
local random = math.random
local tinsert = table.insert
local tremove = table.remove
local tsort = table.sort
local setmetatable = setmetatable
local ceil = math.ceil
local rawget = rawget
local assert = assert

require "think.common"
require "think.rules"

local rules = think.rules

-- validate rules
for name, rule in pairs(rules) do
    assert( rule.rating, 'rule must impl rating function' )

    print( '[Init rule]: ' .. name )
    if rule.init then rule.init() end
end

module "think.main"

--> Config
local default_config = 
{
    think_deepth = 1,
    stupid = 0, -- [0, 100]
    enable_all_inhand_tiles = false,
    enable_close_tiles = false,
    enable_ontable_tiles = true,
    verbose = true,
}

default_config.__index = function(t,k)
    local v = rawget(default_config,k)
    if not v then assert( false, 'cannot find config node' ) end
    return v
end

ChangeDefaultConfig = function( config )
    for k, v in pairs(config) do
        default_config[ k ] = v
    end
end

local sort_fun = function(l,r)
    return l < r
end

function preRoomData( room, seat_index )
    local my_seat = room.seats[ seat_index ]
    my_seat.old_hand_seq = {
        wan = my_seat.hand_seq.wan,
        tong = my_seat.hand_seq.tong,
        tiao = my_seat.hand_seq.tiao,
        lack = my_seat.hand_seq.lack,
        mo = my_seat.hand_seq.mo,
    }

    local wan = util_shallowcopy( my_seat.hand_seq.wan )
    local tong = util_shallowcopy( my_seat.hand_seq.tong )
    local tiao = util_shallowcopy( my_seat.hand_seq.tiao )
    local lack = util_shallowcopy( my_seat.hand_seq.lack )
    local mo = util_shallowcopy( my_seat.hand_seq.mo )

    local mocard
    if mo and #mo ~= 0 then mocard = mo[1] end

    if (mocard) then
        local mo_typeid = ceil( mocard % 10 )
        if (mo_typeid == 1) then
            tinsert( wan, mocard)
        elseif (mo_typeid == 2) then
            tinsert( tong, mocard)
        elseif (mo_typeid == 3) then
            tinsert( tiao, mocard)
        end
    end

    wan = tsort( wan, sort_fun )
    tong = tsort( wan, sort_fun )
    tiao = tsort( wan, sort_fun )
    lack = tsort( wan, sort_fun )

    my_seat.hand_seq =
    {
        wan = wan,
        tong = tong,
        tiao = tiao,
        lack = lack,
    }
end

function postRoomData( room, seat_index )
    local my_seat = room.seats[ seat_index ]
    my_seat.hand_seq = my_seat.old_hand_seq
    my_seat.old_hand_seq = nil
end

-- return rating value
function rating( config, room, seat_index )
    local total_score = 0
    for name, rule in pairs(rules) do
        local score = rule.rating( config, room, seat_index )
        total_score = total_score + score
    end

    return total_score
end

--> Think chu
function DoThinkChu( config, room, seat_index)
    preRoomData( room, seat_index )
    if not config then 
        config = default_config 
    else
        setmetatable( config, default_config )
    end

    local my_seat = room.seats[seat_index]
    local my_hand_seq = my_seat.hand_seq

    local wan = my_hand_seq.wan
    local tong = my_hand_seq.tong
    local tiao = my_hand_seq.tiao
    local lack = my_hand_seq.lack
    local mo = my_hand_seq.mo
    local resultStack = {}

    local isChecked = function(card)
        for _, v in ipairs(resultStack) do
            if (v.card == card) then return true end
        end

        return false
    end

    local pickBestChu = function()
        tsort( resultStack, function(rhv,lhv) return rhv.point > lhv.point end )

        local top = resultStack[1]
        return top.card
    end


    if #lack ~= 0 then
        -- MUST lack
        if lack then
            for i = 1, #lack do
                local card = lack[i]
                if not isChecked(card) then
                    local newlack = util_shallowcopy( lack )
                    tremove( newlack, i )
                    my_hand_seq.lack = newlack

                    local ratingValue   = {}
                    ratingValue.card    = card
                    ratingValue.point   = rating( config, room, seat_index)

                    tinsert( resultStack, ratingValue )
                end
            end
        end
    else
        -- No lack
        if wan and #wan ~= 0 then
            for i = 1, #wan do
                local card = wan[i]
                if not isChecked(card) then
                    local new_wan = util_shallowcopy( wan )
                    tremove( new_wan, i )
                    my_hand_seq.wan = new_wan

                    local ratingValue   = {}
                    ratingValue.card    = card
                    ratingValue.point   = rating( config, room, seat_index)

                    tinsert( resultStack, ratingValue )
                end
            end
        end

        if tong and #tong ~= 0 then
            for i = 1, #tong do
                local card = tong[i]
                if not isChecked(card) then
                    local new_tong = util_shallowcopy( tong )
                    tremove( new_tong, i )
                    my_hand_seq.tong = new_tong

                    local ratingValue   = {}
                    ratingValue.card    = card
                    ratingValue.point   = rating( config, room, seat_index)

                    tinsert( resultStack, ratingValue )
                end
            end
        end

        if tiao and #tiao ~= 0 then
            for i = 1, #tiao do
                local card = tiao[i]
                if not isChecked(card) then
                    local new_tiao = util_shallowcopy( tiao )
                    tremove( new_tiao, i )
                    my_hand_seq.tiao = new_tiao

                    local ratingValue   = {}
                    ratingValue.card    = card
                    ratingValue.point   = rating( config, room, seat_index)

                    tinsert( resultStack, ratingValue )
                end
            end
        end
    end

    postRoomData( room, seat_index )
    return pickBestChu( config, resultStack )
end

--> Think action
function DoThinkAction( config, room, seat_index, actions )
    preRoomData( room, seat_index )
    -- get current rating
    local currentRating = rating( config, room, seat_index )

    -- do action, get high rating decide, plus the action score
    -- do or not do

    postRoomData( room, seat_index )
end

function learn()
end

