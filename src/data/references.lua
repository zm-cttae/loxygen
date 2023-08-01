--- Reference table for Loxygen reference links.
--  List of global functions and tables available in Scribunto.
--  @file               loxygen_references

--- Reference data map for types.
--  @property           {table} loxygen_references.types

--- Reference link map for global items.
--  @property           {table} loxygen_references.items

return {
    types = {
        -- Lua types available to Scribunto.
        ["nil"]         = { link = "#2.2", name = "nil" },
        ["bool"]        = { link = "#2.2", name = "boolean" },
        ["boolean"]     = { link = "#2.2", name = "boolean" },
        ["string"]      = { link = "#2.2", name = "string" },
        ["int"]         = { link = "#2.2", name = "number" },
        ["number"]      = { link = "#2.2", name = "number" },
        ["tab"]         = { link = "#2.5.7", name = "table" },
        ["table"]       = { link = "#2.5.7", name = "table" },
        ["sequence"]    = { link = "#2.5.7", name = "sequence" },
        ["func"]        = { link = "#2.5.8", name = "function" },
        ["function"]    = { link = "#2.5.8", name = "function" },
    },

    items = {
        -- Types and primitives.
        ["..."] = "#2.5.9",
        ["nil"] = "#2.2",
        ["boolean"] = "#2.2",
        ["number"] = "#2.2",
        ["sequence"] = "#2.5.7",
        ["function"] = "#2.5.8",
        -- Global variables and functions.
        ["_G"] = "#pdf-_G",
        ["_VERSION"] = "#pdf-_VERSION",
        ["assert"] = "#pdf-assert",
        ["error"] = "#pdf-error",
        ["getmetatable"] = "#pdf-getmetatable",
        ["setmetatable"] = "#pdf-setmetatable",
        ["ipairs"] = "#pdf-ipairs",
        ["next"] = "#pdf-next",
        ["pairs"] = "#pdf-pairs",
        ["pcall"] = "#pdf-pcall",
        ["xpcall"] = "#pdf-xpcall",
        ["rawequal"] = "#pdf-rawequal",
        ["rawget"] = "#pdf-rawget",
        ["rawset"] = "#pdf-rawset",
        ["require"] = "#pdf-require",
        ["select"] = "#pdf-select",
        ["tonumber"] = "#pdf-tonumber",
        ["tostring"] = "#pdf-tostring",
        ["type"] = "#pdf-type",
        ["unpack"] = "#pdf-unpack",
        -- Lua debug library.
        ["debug"] = "#pdf-debug",
        ["debug.traceback"] = "#pdf-debug.traceback",
        -- Lua math library.
        ["math"] = "#pdf-math",
        ["math.abs"] = "#pdf-math.abs",
        ["math.acos"] = "#pdf-math.acos",
        ["math.asin"] = "#pdf-math.asin",
        ["math.atan"] = "#pdf-math.atan",
        ["math.atan2"] = "#pdf-math.atan2",
        ["math.ceil"] = "#pdf-math.ceil",
        ["math.cos"] = "#pdf-math.cos",
        ["math.cosh"] = "#pdf-math.cosh",
        ["math.deg"] = "#pdf-math.deg",
        ["math.exp"] = "#pdf-math.exp",
        ["math.floor"] = "#pdf-math.floor",
        ["math.fmod"] = "#pdf-math.fmod",
        ["math.frexp"] = "#pdf-math.frexp",
        ["math.huge"] = "#pdf-math.huge",
        ["math.ldexp"] = "#pdf-math.ldexp",
        ["math.log"] = "#pdf-math.log",
        ["math.log10"] = "#pdf-math.log10",
        ["math.max"] = "#pdf-math.max",
        ["math.min"] = "#pdf-math.min",
        ["math.modf"] = "#pdf-math.modf",
        ["math.pi"] = "#pdf-math.pi",
        ["math.pow"] = "#pdf-math.pow",
        ["math.rad"] = "#pdf-math.rad",
        ["math.random"] = "#pdf-math.random",
        ["math.randomseed"] = "#pdf-math.randomseed",
        ["math.sin"] = "#pdf-math.sin",
        ["math.sinh"] = "#pdf-math.sinh",
        ["math.sqrt"] = "#pdf-math.sqrt",
        ["math.tan"] = "#pdf-math.tan",
        ["math.tanh"] = "#pdf-math.tanh",
        -- Operating system library.
        ["os"] = "#pdf-os",
        ["os.clock"] = "#pdf-os.clock",
        ["os.date"] = "#pdf-os.date",
        ["os.difftime"] = "#pdf-os.difftime",
        ["os.time"] = "#pdf-os.time",
        -- Package library.
        ["package"] = "#pdf-package",
        ["package.loaded"] = "#pdf-package.loaded",
        ["package.loaders"] = "#pdf-package.loaders",
        ["package.preload"] = "#pdf-package.preload",
        ["package.seeall"] = "#pdf-package.seeall",
        -- Lua string library.
        ["string"] = "#pdf-string",
        ["string.byte"] = "#pdf-string.byte",
        ["string.char"] = "#pdf-string.char",
        ["string.find"] = "#pdf-string.find",
        ["string.format"] = "#pdf-string.format",
        ["string.gmatch"] = "#pdf-string.gmatch",
        ["string.gsub"] = "#pdf-string.gsub",
        ["string.len"] = "#pdf-string.len",
        ["string.lower"] = "#pdf-string.lower",
        ["string.match"] = "#pdf-string.match",
        ["string.rep"] = "#pdf-string.rep",
        ["string.reverse"] = "#pdf-string.reverse",
        ["string.sub"] = "#pdf-string.sub",
        ["string.upper"] = "#pdf-string.upper",
        -- Lua table library.
        ["table"] = "#pdf-table",
        ["table.concat"] = "#pdf-table.concat",
        ["table.insert"] = "#pdf-table.insert",
        ["table.maxn"] = "#pdf-table.maxn",
        ["table.remove"] = "#pdf-table.remove",
        ["table.sort"] = "#pdf-table.sort",
    }
}