--------------------------------------------------------------------------------
-- Loxygen generic types test case
--
-- @script generics
-- @alias p
-- @author [[User:ExE Boss|ExE Boss]]
--------------------------------------------------------------------------------
local libraryUtil = require("libraryUtil");
local checkType = libraryUtil.checkType;

local p = {};

--------------------------------------------------------------------------------
-- @param      {string} str
-- @param[opt] {string} splitter (Default: `","`)
-- @param[opt] {boolean} isPattern
--             Whether the string in `splitter` is a [[Lua reference manual/Scribunto libraries#Ustring patterns|Ustring pattern]]
-- @return {sequence<string>} Should parse as: 
--         <code>[[#pdf-sequence|sequence]]&lt;[[#pdf-string|string]]&gt;</code>
-- @see [[Lua reference manual/Scribunto libraries#mw.text.split|`mw.text.split`]]
--------------------------------------------------------------------------------
function p.split(str, splitter, isPattern)
	checkType("split", 1, str, "string");
	checkType("split", 2, splitter, "string", true);
	checkType("split", 3, isPattern, "boolean", true);

	splitter = splitter or ",";
	local isPlain = not isPattern;

	local result = {};
	local prevIndex = 1;
	local startIndex, endIndex = mw.ustring.find(str, splitter, nil, isPlain);

	while startIndex ~= nil do
		table.insert(result, mw.ustring.sub(str, prevIndex, startIndex - 1));
		prevIndex = endIndex + 1;
		startIndex, endIndex = mw.ustring.find(str, splitter, prevIndex, isPlain);
	end

	table.insert(result, mw.ustring.sub(str, prevIndex));
	return result;
end

return p;