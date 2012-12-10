local print = print
local pairs = pairs
local ipairs = ipairs
local random = math.random
local tinsert = table.insert
local tremove = table.remove
local tsort = table.sort
local setmetatable = setmetatable

local function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

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

--> Think chu
function DoThinkChu( config, room, myseat )
    if not config then 
        config = default_config 
    else
        setmetatable( config, default_config )
    end

    local my_seat = room.seats[myseat]
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

    if #lack ~= 0 or #mo ~= 0 then
        -- MUST lack
        if lack then
            for i = 1, #lack do
                local card = lack[i]
                if not isChecked(card) then
                    local newlack = shallowcopy( lack )
                    tremove( newlack, i )
                    my_hand_seq.lack = newlack

                    local ratingValue   = {}
                    ratingValue.card    = card
                    ratingValue.point   = rating( config, room, myseat )

                    tinsert( resultStack, ratingValue )
                end
            end
        end

        if mo then
            local card = mo[1]
            if not isChecked(card) then
                my_hand_seq.mo = {}
                
                local ratingValue = {}
                ratingValue.card = card
                ratingValue.point = rating( config, room, myseat )

                tinsert( resultStack, ratingValue )
            end
        end
    else
        -- No lack
        if wan and #wan ~= 0 then
            for i = 1, #wan do
                local card = wan[i]
                if not isChecked(card) then
                    local new_wan = shallowcopy( wan )
                    tremove( new_wan, i )
                    my_hand_seq.wan = new_wan

                    local ratingValue   = {}
                    ratingValue.card    = card
                    ratingValue.point   = rating( config, room, myseat )

                    tinsert( resultStack, ratingValue )
                end
            end
        end

        if tong and #tong ~= 0 then
            for i = 1, #tong do
                local card = tong[i]
                if not isChecked(card) then
                    local new_tong = shallowcopy( tong )
                    tremove( new_tong, i )
                    my_hand_seq.tong = new_tong

                    local ratingValue   = {}
                    ratingValue.card    = card
                    ratingValue.point   = rating( config, room, myseat )

                    tinsert( resultStack, ratingValue )
                end
            end
        end

        if tiao and #tiao ~= 0 then
            for i = 1, #tiao do
                local card = tiao[i]
                if not isChecked(card) then
                    local new_tiao = shallowcopy( tiao )
                    tremove( new_tiao, i )
                    my_hand_seq.tiao = new_tiao

                    local ratingValue   = {}
                    ratingValue.card    = card
                    ratingValue.point   = rating( config, room, myseat )

                    tinsert( resultStack, ratingValue )
                end
            end
        end

        if mo and #mo ~= 0 then
            local card = mo[1]
            if not isChecked(card) then
                my_hand_seq.mo = {}

                local ratingValue = {}
                ratingValue.card = card
                ratingValue.point = rating( config, room, myseat )

                tinsert( resultStack, ratingValue )
            end
        end

    end

    return pickBestChu( config, resultStack )
end

--> Think action
function DoThinkAction( config, room, myseat, actions )
    -- get current rating
    local currentRating = rating( config, room, myseat )

    -- do action, get high rating decide, plus the action score
    -- do or not do
end

-- return rating value
function rating( config, room, myseat )
    local total_score = 0
    for name, rule in pairs(rules) do
        local score = rule.rating(config, room, myseat)
        total_score = total_score + score
    end

    return total_score
end

function learn()
end

