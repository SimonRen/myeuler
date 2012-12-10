local print = print
local pairs = pairs
local ipairs = ipairs
local random = math.random
local tinsert = table.insert
local setmetatable = setmetatable

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

--> Think entrace
DoThink = function( config, room, myseat )
    if not config then 
        config = default_config 
    else
        setmetatable( config, default_config )
    end

    -- regroup all room data
    rating()
end

-- return rating value
function rating()
    local total_score = 0
    for name, rule in pairs(rules) do
        local score = rule.rating()
        total_score = total_score + score
    end

    return total_score
end

function learn()
end

