--------------------------------------------------------------------------------
-- Loxygen overloads testcase
--
-- @module overloads
-- @alias p
-- @require [[Global Lua Modules/Arguments|Module:Arguments]]
-- @author [[User:ExE Boss|ExE Boss]]
--------------------------------------------------------------------------------
local libraryUtil = require("libraryUtil");
local checkType = libraryUtil.checkType;

local getArgs = require("../../src/libraries/arguments").getArgs;

local p = {};

--[[
-- Signature when invoked from wikitext
--
-- @function p.main
-- @param {Frame} frame Scribunto frame object
-- @return {string} The result
--]]
--[[
-- Signature when called from Lua
--
-- @function p.main
-- @param {table} args Arguments table
-- @return {string} The result
--]]
function p.main(frame)
	local args = getArgs(frame);
	checkType("main", 1, args, "table");

	-- Implementation
	return "result";
end

return p;