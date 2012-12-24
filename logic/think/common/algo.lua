--
-- Created by IntelliJ IDEA.
-- User: Simon
-- Date: 12-12-24
-- Time: 下午2:11
-- To change this template use File | Settings | File Templates.
--

local game_ffi = require "game_ffi"

algo_Hu = function( hand_seq )
    local result = game_ffi.check_hu( hand_seq, {} )

    if (result.type == 0) then
        return false
    else
        return true
    end
end
