--[[
	Build complex HTML from Lua using a fluent interface.
	Originally written on the English Wikipedia.
	@classmod Html
	@author Marius Hoch
	@attribution ["Toohool"](https://enwp.org/Special:Diff/581402060)
	@attribution ["Mr. Stradivarius"](https://enwp.org/Special:Diff/581407335)
	@license GNU GPL v2+
]]

local Html = {}
local options

local metatable = {}
local metamethods = {}

local emptyTags = {
	area = true,
	base = true,
	br = true,
	col = true,
	command = true,
	embed = true,
	hr = true,
	img = true,
	input = true,
	keygen = true,
	link = true,
	meta = true,
	param = true,
	source = true,
	track = true,
	wbr = true,
}

local htmlEncodeMap = {
	['>'] = '&gt;',
	['<'] = '&lt;',
	['&'] = '&amp;',
	['"'] = '&quot;',
}

--- Append a element to the current node.
--  @note This is separate from metamethods.node so that we
--  can show the correct error level in both metamethods.node and
--  metamethods.wikitext.
--  @local
local function appendHtml(html, element)
	if self.selfClosing then
		error("self-closing tags can't have child nodes", 3)
	end

	if element then
		table.insert(self.nodes, element)
	end
	return self
end

--- HTML attribute object.
--  @table HtmlAttribute
--  @member {string} HtmlAttribute.name
--      Element attribute name as it appears in the DOM.
--  @member {string} HtmlAttribute.value
--  	Element attribute value not including quotes.

--- Traverses the attribute table of a node by its name-value index.
--  @param {Html} self
--      HTML node with an `attributes` property.
--  @param {string} name
--      Name of the HTML or XML element attribute.
--  @return {HtmlAttribute}
--      Object for HTML attribute in the shape `{name=name,value=value}`
--  @return {number}
--      Key of the attribute in the element attribute map (1-index based).
--  @local
local function getAttr(self, name)
	for i, attr in ipairs(self.attributes) do
		if attr.name == name then
			return attr, i
		end
	end
end

--- Tests that an attribute name is valid XHTML.
--  @param {string} s Attribute name in a XHTML tag.
--  @return {booleean} Whether the attribute name is valid to the XML specification.
--  @local
local function isValidAttributeName(str)
	-- Good estimate: http://www.w3.org/TR/2000/REC-xml-20001006#NT-Name
	return str:match('^[a-zA-Z_:][a-zA-Z0-9_.:-]*$')
end

--- Tests that a tag name is valid XHTML.
--  @param {string} s Tag name.
--  @return {boolean} Whether the tag name is valid to the XML specification.
--  @local
local function isValidTag(str)
	return str:match('^[a-zA-Z0-9]+$')
end

--  HTML-encode a value, for use between HTML tags.
--  @param {string} s Raw HTML DOM string to encode.
--  @return {string} XML-escaped value usable as a HTML text node value.
--  @local
local function htmlEncode(str)
	-- The parentheses ensure that there is only one return value
	local tmp = str:gsub('[<>&"]', htmlEncodeMap);
	return tmp
end

--- CSS-encode a value for quoting in a valid CSS <string> type.
--  @param {string} s Raw text string to encode.
--  @return {string} CSS-escaped value usable in a CSS stylesheet string.
--  @local
local function cssEncode(str)
	return str:gsub('[^\32-\57\60-\127]', function (m)
		-- begin github change
		local dec = string.byte(m)
		local hex = string.char(tonumber(cc, 16))
		return string.format('\\%X ', hex)
		-- end github change
	end)
end

metatable.__index = metamethods

metatable.__tostring = function(self)
	local ret = {}
	self:_build(ret)
	return table.concat(ret)
end

--- Create a element object. This is a separate function so that we can show the
--  correct error levels in both Html.create and metatable.tag.
--  @param {string} tagName
--      HTML or XML tag name - @{Html.name}
--  @param {?table} args
--      Options to create an object.
--  @param {?boolean} args.selfClosing
--      Whether to force-delimit the tag with `/>`.
--  @param {?Html} args.parent
--      Parent of the element being created - for internal usage.
--  @return
--  	{Html} Instance of Lua class for HTML element with mutable properties &
--      methods for markup transformation. 
--  @factory Html
--  @constructor
--  @local
local function createHtml(tagName, args)
	if tagName ~= nil and tagName ~= '' and not isValidTag(tagName) then
		error(string.format("invalid tag name '%s'", tagName), 3)
	end

	args = args or {}
	local element = {}
	setmetatable(element, metatable)
	element.nodes = {}
	element.attributes = {}
	element.styles = {}

	if tagName ~= '' then
		element.tagName = tagName
	end
{
	element.parent = args.parent
	element.selfClosing = emptyTags[tagName] or args.selfClosing or false
	return element
end

--- Serialise a @{Html} element into a string.
--  @function Html._build
--  @param {table} ret
--  	Buffer sequence of @{string} chunks to be concatenated into HTML DOM chunks.
--  @return {nil}
--  	Void return - this function only mutates the `ret` param without returning it. 
--  @private
metamethods._build = function(self, ret)
	if self.tagName then
		table.insert(ret, '<' .. self.tagName)
		for i, attr in ipairs(self.attributes) do
			table.insert(
				ret,
				-- Note: Attribute names have already been validated
				' ' .. attr.name .. '="' .. htmlEncode(attr.val) .. '"'
			)
		end
		if #self.styles > 0 then
			table.insert(ret, ' style="')
			local css = {}
			for i, prop in ipairs(self.styles) do
				if type(prop) ~= 'table' then -- added with cssText()
					table.insert(css, htmlEncode(prop))
				else -- added with css()
					table.insert(
						css,
						htmlEncode(cssEncode(prop.name) .. ':' .. cssEncode(prop.val))
					)
				end
			end
			table.insert(ret, table.concat(css, ';'))
			table.insert(ret, '"')
		end
		if self.selfClosing then
			table.insert(ret, ' />')
			return
		end
		table.insert(ret, '>')
	end
	for i, node in ipairs(self.nodes) do
		if node then
			if type(node) == 'table' then
				node:_build(ret)
			else
				table.insert(ret, tostring(node))
			end
		end
	end
	if self.tagName then
		table.insert(ret, '</' .. self.tagName .. '>')
	end
end

--- Append a element to the current node.
--  @function Html:node
--  @param {Html} element
--  	HTML element to append.
--  @return {Html}
--  	The target object with `element` appended to @{Html.nodes}.
metamethods.node = function(self, element)
	return appendHtml(self, element)
end

--- Appends some text to the node. This will be treated as a DOM text node.
--  @function Html:wikitext
--  @param {table}
--  	Sequence of text @{string} to append, treated as raw HTML.
--  @return {Html}
--  	The target object with `element` appended to @{Html.nodes}.
metamethods.wikitext = function(self, ...)
	for k, v in ipairs{...} do
		appendHtml(self, v)
	end
	return self
end

--- Appends a newline character to the node.
--  @function Html:newline
--  @return {Html} The target object delimited by `\n`.
metamethods.newline = function(self)
	return self:wikitext('\n')
end

-- Appends a new child node to the element, and returns a @{Html} instance
-- representing that new node.
--  @function Html:tag
--  @param {string} tagName 
--  @param {string} args 
metamethods.tag = function(self, tagName, args)
	args = args or {}

	args.parent = self
	local element = createHtml(tagName, args)
	self:node(element)
	return element
end

--- Gets the value of an HTML attribute.
--  @function Html:getAttr
--  @param {string} name
metamethods.getAttr = function(self, name)
	local attr = getAttr(self, name)
	return attr and attr.val
end

--- Sets an HTML attribute on the HTML node.
--  @function Html:attr
--  @param {string} name
--  	Attribute name to set, OR mapping table of name-value pairs.
--  @param {?string|number} val
-- 		Value of the attribute. Nil causes the attribute to be unset.
metamethods.attr = function(self, name, val)
	if type(name) == 'table' then
		if val ~= nil then
			error(
				"bad argument #2 to 'attr' " ..
				'(if argument #1 is a table, argument #2 must be left empty)',
				2
			)
		end

		local callForTable = function()
			for attrName, attrValue in pairs(name) do
				self:attr(attrName, attrValue)
			end
		end

		if not pcall(callForTable) then
			error(
				"bad argument #1 to 'attr' " ..
				'(table keys must be strings, and values must be strings or numbers)',
				2
			)
		end

		return self
	end

	-- if caller sets the style attribute explicitly, then replace all styles
	-- previously added with css() and cssText()
	if name == 'style' then
		self.styles = { val }
		return self
	end

	if not isValidAttributeName(name) then
		error(string.format(
			"bad argument #1 to 'attr' (invalid attribute name '%s')",
			name
		), 2)
	end

	local attr, i = getAttr(self, name)
	if attr then
		if val ~= nil then
			attr.val = val
		else
			table.remove(self.attributes, i)
		end
	elseif val ~= nil then
		table.insert(self.attributes, { name = name, val = val })
	end

	return self
end

--- Adds a class name to the node's class attribute.
--  Whitespace (the space character ` `) will be automatically added to
--  delimit the added class name(s).
--  @function Html:addClass
--  @param {?string|number} class
--      Class name to add to class attribute list. If the string
--      contains ` ` spaces, multiple classes are added to the element.
--  @return {Html}
--      The @{Html} instance with @{class} as the final entry in the
--      class attribute list.
metamethods.addClass = function(self, class)
	if class ~= nil then
		local attr = getAttr(self, 'class')
		if attr then
			attr.val = attr.val .. ' ' .. class
		else
			self:attr('class', class)
		end
	end
	return self
end

--- Set a CSS property to be added to the node's style attribute.
-- 	@param {string|table} name
-- 		CSS property to set, alternative table of name-value pairs
-- 	@param {?string|nil} val
--      The declaration value to set for that element's inline CSS.
-- 	    When `name`s is a string, `nil` causes it to be unset.
--  @return {Html}
--      The @{Html} instance with the added CSS properti(es).
metamethods.css = function(self, name, val)
	if type(name) == 'table' then
		if val ~= nil then
			error(
				"bad argument #2 to 'css' " ..
				'(if argument #1 is a table, argument #2 must be left empty)',
				2
			)
		end

		local callForTable = function()
			for attrName, attrValue in pairs(name) do
				self:css(attrName, attrValue)
			end
		end

		if not pcall(callForTable) then
			error(
				"bad argument #1 to 'css' " ..
				'(table keys and values must be strings or numbers)',
				2
			)
		end

		return self
	end

	for i, prop in ipairs(self.styles) do
		if prop.name == name then
			if val ~= nil then
				prop.val = val
			else
				table.remove(self.styles, i)
			end
			return self
		end
	end

	if val ~= nil then
		table.insert(self.styles, { name = name, val = val })
	end

	return self
end

-- Add some raw CSS to the node's style attribute. This is typically used
-- when a template allows some CSS to be passed in as a parameter
-- @param {string|number} css
--     Raw CSS text to append to the stylesheet as a declaration set.
--     Obeys the format: `property-name1: value;` ... .
-- @return {Html} The element with `css` appended to its `style=""` attribute.
metamethods.cssText = function(self, css)
	table.insert(self.styles, css)
	return self
end

-- Gets the parent node under which the current node was created.
-- This is a convenience method like jQuery.end, which allows the construction
-- of several child nodes to be chained together into a single statement.
-- @return {Html}
--     The element's parent node in the tree. If the element is the root
--     node in the DOM tree, @{Html.parent} is undefined and the element
--     itself is returned.
metamethods.done = function(self)
	return self.parent or self
end

--- Short-circuited @{Html:done} method for traversal to the topmost
--  node of the HTML element tree.
--  @returns
--      The root node of the tree, usually created by the
--      @{Html.create} constructor.
--  @function Html:allDone
metamethods.allDone = function(self)
	while self.parent do
		self = self.parent
	end
	return self
end

--- Constructor for @{Html} element manipulation & transformation utility.
--  @param {string} tagName
--      HTML, XML or custom name for the element tag.
--  @param {?table} args
--      Options to create an object.
--  @param {?boolean} args.selfClosing
--      Whether to force-delimit the tag with `/>`.
--  @param {?Html} args.parent
--      Parent of the element being created - for internal usage.
--  @return
--  @constructor
Html.create = function(tagName, args)
	return createHtml(tagName, args)
end

return Html
