local p = {}

p.bold = function(props)
    return "<b>" .. props.text .. "</b>"
end

p.italic = function(props)
    return "<i>" .. props.text .. "</i>"
end

p.link = function(props)
    return '<a href="' .. props.href .. ">/" .. props.text .. "</a>"
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
