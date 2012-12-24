local ffi = require("ffi")
local tinsert = table.insert

module("game_ffi", package.seeall)

ffi.cdef[[
	typedef struct _tagComplex {int type; int id; } Complex;
	typedef struct _tagGPCount {int g; int p; } GPCount;
	typedef struct _tagHuResult {int type; int gen;} HuResult;

	HuResult check_hu(int[40], int complex_length, Complex[10]);

	int printf(const char *fmt, ...);

	void test_ffi();
	]]

global_abs_path = "/home/liuyang/workspace/server/game/priv/lua/"

local hu_lib = ffi.load(global_abs_path .. "c/hu.so")

hu_lib.test_ffi()

function check_hu(hand_seq, complex_seq)

	local pai_arr 	  = ffi.new("int[40]", {})
	
	for k, v in pairs(hand_seq) do

		for i1, v1 in ipairs(v) do

			pai_arr[v1] = pai_arr[v1] + 1
		end

	end

	local gang_seq = {}

	for i=0, 39 do

		if pai_arr[i] == 4 then

			tinsert(gang_seq, i)
		end

	end

	local complex_arr = ffi.new("Complex[10]", {})

	for i, v in ipairs(complex_seq) do
		complex_arr[i-1].type = v.type
		complex_arr[i-1].id   = v.id
	end
	
	local result = hu_lib.check_hu(pai_arr, 
		#complex_seq, complex_arr)

	return {type = result.type, gen = result.gen}, gang_seq
end

