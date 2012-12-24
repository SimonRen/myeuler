--
-- Created by IntelliJ IDEA.
-- User: Simon
-- Date: 12-12-24
-- Time: 下午2:02
-- To change this template use File | Settings | File Templates.
--
local print = print
local pairs = pairs
local ipairs = ipairs
local random = math.random
local tinsert = table.insert
local tremove = table.remove
local tsort = table.sort
local setmetatable = setmetatable
local ceil = math.ceil

function util_shallowcopy(orig)
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

function util_deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[util_deepcopy(orig_key)] = util_deepcopy(orig_value)
        end
        setmetatable(copy, util_deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

util_mjSort = function( l, r )
    if not l or not r then return false end

    return l < r
end
