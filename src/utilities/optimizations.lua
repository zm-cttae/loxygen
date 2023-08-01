--  Loxygen private logic.
local optimizations = {}

--- @{string.find} optimisation for @{string} functions.
--  @function           exec
--  @param              {function} strfunc String library function.
--  @return             {function} Function wrapped in @{string.find} check.
--  @local
function optimizations.exec(func)
    return function(...)
        local arg = {...}
        if string.find(arg[1], arg[2]) then
            return func(...);
        end
    end
end

--- @{mw.text.trim} optimised with pure Lua.
--  @function           trim
--  @param              {string} str Input string.
--  @return             {string} Trimmed string.
--  @local
function optimizations.trim(str)
    local start, stop = 1, #str

    while (start < stop and str:byte(start) <= 32) do
        start = start + 1
    end

    while (stop >= start and str:byte(stop) <= 32) do
        stop = stop - 1
    end

    return str:sub(start, stop)
end

return optimizations