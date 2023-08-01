--- Yesno module for processing of boolean-like wikitext input.
--  
--  It works similarly to the [[wikipedia:Template:Yesno|Yesno Wikipedia
--  template]]. This module is a consistent Lua interface for wikitext
--  input from templates.
--  
--  Wikitext markup used by MediaWiki templates only permit
--  string parameters like `"0"`, `"yes"`, `"no"` etc. As Lua
--  has a boolean primitive type, Yesno converts this
--  wikitext into boolean output for Lua to process.
--  
--  @script             yesno
--  @release            stable
--  @author             https://dev.fandom.com/wiki/User:Dessamator
--  @attribution        [ATDT](https://enwp.org/User:ATDT)
--  @attribution        [Mr. Stradivarius](https://enwp.org/User:Mr._Stradivarius)
--  @attribution        [Wikipedia](https://enwp.org/Special:PageHistory/Module:Yesno)
--  @see                [Original module on Wikipedia](https://enwp.org/Module:Yesno)
--  @see                [Test cases for this module](https://enwp.org/Module:Yesno/testcases)
--  @param              {?boolean|string} value Wikitext boolean-style
--                      or Lua boolean input.
--                       - Truthy wikitext input (`'yes'`, `'y'`, `'1'`,
--                      `'t'` or `'on'`) produces `true` as output.
--                       - The string representations of Lua's true
--                      boolean value (`'true'`) also produces `true`.
--                       - Falsy wikitext input (`'no'`, `'n'`, `'0'`,
--                      `'f'` or `'off'`) produces `false` as output.
--                       - The string representation of Lua's false
--                      boolean value (`'false'`) also produces `false`.
--                       - Localised text meaning `'yes'` or `'no'` also
--                      evaluate to `true` or `false` respectively.
--  @param[opt]         {?boolean|string} default Output to return if
--                      the Yesno `value` input is unrecognised.
--  @return             {?boolean} Boolean output corresponding to
--                      `val`:
--                       - The strings documented above produce a
--                      boolean value.
--                       - A `nil` value produces an output of `nil`.
--                      As this is falsy, additional logic may be needed
--                      to treat missing template parameters as truthy.
--                       - Unrecognised values return the `default`
--                      parameter. Blank strings are a key example
--                      of Yesno's unrecognised values and can evaluate
--                      to `true` if there is a default value.
local lower = string.lower

return function(value, default)
    value = type(value) == 'string' and lower(value) or value

    if value == nil then
        return nil

    elseif value == true
        or value == 'y'
        or value == 'true'
        or value == 't'
        or value == 'on'
        or tonumber(value) == 1
    then
        return true

    elseif value == false
        or value == 'n'
        or value == 'false'
        or value == 'f'
        or value == 'off'
        or tonumber(value) == 0
    then
        return false

    else
        return default
    end
end
