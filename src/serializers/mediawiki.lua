local p = {}

p.bold = function(props)
    return "'''" .. props.text .. "'''"
end

p.italic = function(props)
    return "''" .. props.text .. "''"
end

p.link = function(props)
    return "[" .. props.href .. " " ..  props.text .. "]"
end

p.descriptions = function(props)
    return "<dl>\n" .. props.text .. "\n</dl>"
end

p.headword = function(props)
    return "<dt>" .. props.text .. "</dt>"
end

p.definition = function(props)
    return "<dd>" .. props.text .. "</dd>"
end
