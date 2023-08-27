# `loxygen-documentation-generator`

A powerful API documentation generator for Lua (minimum supported version 5.1.5).

The goal of this project is to provide a versatile block documentation comment format that can be used by IDEs such as VS Code to annotate and type-match code symbols in Lua scripts and Luarocks packages.

This project is a fork of the [Docbunto](https://dev.fandom.com/wiki/Global_Lua_Modules/Docbunto) script used on MediaWiki projects.

## Getting started

Documentation is contributed by Lua symbols in the form of static comment markup using the `@` symbol.

These are provided and maintained by the developer during the code implementation:

```lua
--- Item summary.
--  The item description follows. Information provided by the item comment
--  can be formatted with '''MediaWiki''' and **Markdown** syntax.
--  The comments can generally span multiple lines.
--  
--  By leaving empty comment lines, a new paragraph can be made in the
--  documentation. This can be used to give longer explanations whitespace.
--  
--  @script         docbunto
--  @param          {table} options Configuration options.
--  @param[opt]     {boolean} options.all Include local items in documentation.
--  @param[opt]     {string} options.simple Limit documentation to descriptions.
--  @param[opt]     {string} options.colon Format tags with a `:` suffix.
--  @return         {string} Compiled documentation.
```

The block description in Loxygen comments is prefixed by the character sequence `---` or `--[[-`.

Similar to other competing comment standards, documentation can be triggered by a comment containing a tag.

In essence, just put a `-- @param` tag and it'll work.


| Format  | Active?     | Documented?   | Mixed mode* | Conflict prevention |
|---------|-------------|---------------|-------------|---------------------|
| LuaDoc  | No          | Yes           | Yes         | No                  |
| LDoc    | Active      | Yes           | Yes         | No                  |
| EmmyLua | Active      | No            | Yes         | Yes                 |
| Loxygen | Active      | Yes           | Yes         | Yes                 |

- **LuaDoc**: uses `---` for block descriptions
- **LDoc**: uses `--[[` and `---` for block descriptions
- **EmmyLua**: uses `----` for block descriptions

These `@`-tags and surrounding markup are parsed by the library's taglet and used to generate Markdown output.

The underlying "taglet" API that generates the documentation is designed for consumption in other Lua modules and the VS Code language server for Lua.

## Tags

The package supports 52 documentation tags. These are prefixed with `@` as a key for the documentation message in the documentation output. Where applicable multiple entries of one `@tag` are acceptable and are rendered as a list.

The full list is available on the [original Docbunto documentation page](https://dev.fandom.com/wiki/Global_Lua_Modules/Docbunto#Tags).

Some developers avoid documentation generators because they aim to protect their codebase from "doctag soup" AKA `@` fatigue. To bypass this DX issue, Loxygen has a `colon` mode where tags are suffixed with `:` instead.

### Item type tags

#### `@function`

| Name        | Aliases      | Category  | Permitted context | Typing     |
| ----------- | ------------ | --------- | ----------------- | ---------- |
| `@function` | `@lfunction` | Item type | Item              | `function` |

#### `@table`

| Name     | Aliases     | Category  | Permitted context | Typing |
| -------- | ----------- | --------- | ----------------- | ------ |
| `@table` | `@property` | Item type | Item              | table  |

#### `@member`

| Name      | Aliases | Category  | Permitted context | Typing   | Modifiers |
| --------- | ------- | --------- | ----------------- | -------- | --------- |
| `@member` |         | Item type | Item              | `{type}` |           |

#### `@variable`

| Name        | Aliases | Category  | Permitted context | Typing   | Modifiers |
| ----------- | ------- | --------- | ----------------- | -------- | --------- |
| `@variable` |         | Item type | Item              | `{type}` |           |

#### `@section`

| Name       | Aliases | Category  | Permitted context | Typing | Modifiers |
| ---------- | ------- | --------- | ----------------- | ------ | --------- |
| `@section` |         | Item type | Item              | N/A    |           |

#### `@type`

| Name    | Aliases | Category  | Permitted context | Typing                    | Modifiers |
| ------- | ------- | --------- | ----------------- | ------------------------- | --------- |
| `@type` |         | Item type | Item              | [`Tag.value`](#Tag.value) |           |

### Subitem tags

#### `@usage`

| Name     | Aliases | Category | Permitted context | Typing | Modifiers |
| -------- | ------- | -------- | ----------------- | ------ | --------- |
| `@usage` | `@code` |          | Module; Item      |        |           |

#### `@param`

| Name     | Aliases     | Category | Permitted context | Typing   | Modifiers |
| -------- | ----------- | -------- | ----------------- | -------- | --------- |
| `@param` | `@argument` |          | Module; Item      | `{type}` |           |

#### `@field`

| Name     | Aliases | Category | Permitted context | Typing   | Modifiers |
| -------- | ------- | -------- | ----------------- | -------- | --------- |
| `@field` |         |          | Item              | `{type}` |           |

#### `@error`

| Name     | Aliases                                 | Category | Permitted context | Typing   | Modifiers   |
| -------- | --------------------------------------- | -------- | ----------------- | -------- | ----------- |
| `@error` | `@raise`<br/>`@throws`<br/>`@exception` |          | Module; Item      | `{type}` | Line number |

#### `@return`

| Name      | Aliases | Category | Permitted context | Typing   | Modifiers |
| --------- | ------- | -------- | ----------------- | -------- | --------- |
| `@return` |         |          | Module; Item      | `{type}` |           |

### Typed subitem tags

#### `@tfield`

| Name      | Aliases | Category | Permitted context | Typing | Modifiers |
| --------- | ------- | -------- | ----------------- | ------ | --------- |
| `@tfield` |         |          |                   | `type` |           |

#### `@tparam`

| Name      | Aliases | Category | Permitted context | Typing | Modifiers |
| --------- | ------- | -------- | ----------------- | ------ | --------- |
| `@tparam` |         |          |                   | `type` |           |

#### `@treturn`

| Name       | Aliases | Category | Permitted context | Typing | Modifiers |
| ---------- | ------- | -------- | ----------------- | ------ | --------- |
| `@treturn` |         |          |                   | `type` |           |

#### `@bool`

| Name    | Aliases | Category | Permitted context | Typing    | Modifiers |
| ------- | ------- | -------- | ----------------- | --------- | --------- |
| `@bool` |         |          |                   | `boolean` |           |

#### `@func`

| Name    | Aliases | Category | Permitted context | Typing     | Modifiers |
| ------- | ------- | -------- | ----------------- | ---------- | --------- |
| `@func` |         |          |                   | `function` |           |

#### `@int`

| Name   | Aliases | Category | Permitted context | Typing   | Modifiers |
| ------ | ------- | -------- | ----------------- | -------- | --------- |
| `@int` |         |          |                   | `number` |           |

#### `@number`

| Name      | Aliases | Category | Permitted context | Typing   | Modifiers |
| --------- | ------- | -------- | ----------------- | -------- | --------- |
| `@number` |         |          |                   | `number` |           |

#### `@string`

| Name      | Aliases | Category | Permitted context | Typing   | Modifiers |
| --------- | ------- | -------- | ----------------- | -------- | --------- |
| `@string` |         |          |                   | `string` |           |

#### `@tab`

| Name   | Aliases | Category | Permitted context | Typing  | Modifiers |
| ------ | ------- | -------- | ----------------- | ------- | --------- |
| `@tab` |         |          |                   | `table` |           |

### Module type tags

#### `@module`

| Name      | Aliases    | Category    | Permitted context | Typing | Modifiers |
| --------- | ---------- | ----------- | ----------------- | ------ | --------- |
| `@module` | `@package` | Module type | Module            | N/A    |           |

#### `@script`

| Name      | Aliases | Category    | Permitted context | Typing | Modifiers |
| --------- | ------- | ----------- | ----------------- | ------ | --------- |
| `@script` |         | Module type | Module            | N/A    |           |

#### `@classmod`

| Name        | Aliases | Category    | Permitted context | Typing | Modifiers |
| ----------- | ------- | ----------- | ----------------- | ------ | --------- |
| `@classmod` |         | Module type | Module            | N/A    |           |

#### `@submodule`

| Name         | Aliases | Category    | Permitted context | Typing | Modifiers |
| ------------ | ------- | ----------- | ----------------- | ------ | --------- |
| `@submodule` |         | Module type | Module            | N/A    |           |

#### `@example`

| Name       | Aliases | Category    | Permitted context | Typing | Modifiers |
| ---------- | ------- | ----------- | ----------------- | ------ | --------- |
| `@example` |         | Module type | Module            | N/A    |           |

#### `@field`

| Name     | Aliases | Category    | Permitted context | Typing | Modifiers |
| -------- | ------- | ----------- | ----------------- | ------ | --------- |
| `@field` |         | Module type | Module            | N/A    |           |

#### `@topic`

| Name     | Aliases | Category    | Permitted context | Typing | Modifiers |
| -------- | ------- | ----------- | ----------------- | ------ | --------- |
| `@topic` |         | Module type | Module            | N/A    |           |

### Module information tags

#### `@image`

| Name           | Aliases     | Category    | Permitted context | Typing | Modifiers |
| -------------- | ----------- | ----------- | ----------------- | ------ | --------- |
| `@image`       |             | Module info | Module            | N/A    |           |

#### `@caption`

| Name           | Aliases     | Category    | Permitted context | Typing | Modifiers |
| -------------- | ----------- | ----------- | ----------------- | ------ | --------- |
| `@caption`     |             | Module info | Module            | N/A    |           |

#### `@release`

| Name           | Aliases     | Category    | Permitted context | Typing | Modifiers |
| -------------- | ----------- | ----------- | ----------------- | ------ | --------- |
| `@release`     |             | Module info | Module            | N/A    |           |

#### `@author`

| Name           | Aliases     | Category    | Permitted context | Typing | Modifiers |
| -------------- | ----------- | ----------- | ----------------- | ------ | --------- |
| `@author`      |             | Module info | Module            | N/A    |           |

#### `@copyright`

| Name           | Aliases     | Category    | Permitted context | Typing | Modifiers |
| -------------- | ----------- | ----------- | ----------------- | ------ | --------- |
| `@copyright`   |             | Module info | Module            | N/A    |           |

#### `@license`

| Name           | Aliases     | Category    | Permitted context | Typing | Modifiers |
| -------------- | ----------- | ----------- | ----------------- | ------ | --------- |
| `@license`     |             | Module info | Module            | N/A    |           |

#### `@require`

| Name           | Aliases     | Category    | Permitted context | Typing | Modifiers |
| -------------- | ----------- | ----------- | ----------------- | ------ | --------- |
| `@require`     | `@requires` | Module info | Module            | N/A    |           |

#### `@credit`

| Name           | Aliases     | Category    | Permitted context | Typing | Modifiers |
| -------------- | ----------- | ----------- | ----------------- | ------ | --------- |
| `@credit`      | `@credits`  | Module info | Module            | N/A    |           |

#### `@attribution`

| Name           | Aliases     | Category    | Permitted context | Typing | Modifiers |
| -------------- | ----------- | ----------- | ----------------- | ------ | --------- |
| `@attribution` |             | Module info | Module            | N/A    |           |

### Flags

#### `@local`

| Name           | Aliases | Category | Permitted context | Typing | Modifiers |
| -------------- | ------- | -------- | ----------------- | ------ | --------- |
| `@local`       |         | Flag     | Item              | N/A    |           |

#### `@export`

| Name           | Aliases | Category | Permitted context | Typing | Modifiers |
| -------------- | ------- | -------- | ----------------- | ------ | --------- |
| `@export`      |         | Flag     | Inline            | N/A    |           |

#### `@private`

| Name           | Aliases | Category | Permitted context | Typing | Modifiers |
| -------------- | ------- | -------- | ----------------- | ------ | --------- |
| `@private`     |         | Flag     | Item              | N/A    |           |

#### `@constructor`

| Name           | Aliases | Category | Permitted context | Typing | Modifiers |
| -------------- | ------- | -------- | ----------------- | ------ | --------- |
| `@constructor` |         | Flag     | Item              | N/A    |           |

#### `@static`

| Name           | Aliases | Category | Permitted context | Typing | Modifiers |
| -------------- | ------- | -------- | ----------------- | ------ | --------- |
| `@static`      |         | Flag     | Item              | N/A    |           |

### Override tags

#### `@class`

| Name           | Aliases | Category | Permitted context | Typing | Modifiers |
| -------------- | ------- | -------- | ----------------- | ------ | --------- |
| `@class`       |         |          |                   |        |           |

#### `@name`

| Name           | Aliases | Category | Permitted context | Typing | Modifiers |
| -------------- | ------- | -------- | ----------------- | ------ | --------- |
| `@name`        |         |          |                   |        |           |

#### `@alias`

| Name           | Aliases | Category | Permitted context | Typing | Modifiers |
| -------------- | ------- | -------- | ----------------- | ------ | --------- |
| `@alias`       |         |          |                   |        |           |

#### `@summary`

| Name           | Aliases | Category | Permitted context | Typing | Modifiers |
| -------------- | ------- | -------- | ----------------- | ------ | --------- |
| `@summary`     |         |          |                   |        |           |

#### `@description`

| Name           | Aliases | Category | Permitted context | Typing | Modifiers |
| -------------- | ------- | -------- | ----------------- | ------ | --------- |
| `@description` |         |          |                   |        |           |

### Annotation tags

#### `@warning`

| Name       | Aliases | Category | Permitted context | Typing | Modifiers |
| ---------- | ------- | -------- | ----------------- | ------ | --------- |
| `@warning` |         |          |                   |        |           |

#### `@fixme`

| Name       | Aliases | Category | Permitted context | Typing | Modifiers |
| ---------- | ------- | -------- | ----------------- | ------ | --------- |
| `@fixme`   |         |          |                   |        |           |

#### `@note`

| Name       | Aliases | Category | Permitted context | Typing | Modifiers |
| ---------- | ------- | -------- | ----------------- | ------ | --------- |
| `@note`    |         |          |                   |        |           |

#### `@todo`

| Name       | Aliases | Category | Permitted context | Typing | Modifiers |
| ---------- | ------- | -------- | ----------------- | ------ | --------- |
| `@todo`    |         |          |                   |        |           |

#### `@see`

| Name       | Aliases | Category | Permitted context | Typing | Modifiers |
| ---------- | ------- | -------- | ----------------- | ------ | --------- |
| `@see`     |         |          |                   |        |           |

### Other tags

#### `@pragma`

| Name       | Aliases | Category | Permitted context | Typing | Modifiers |
| ---------- | ------- | -------- | ----------------- | ------ | --------- |
| `@pragma`  |         |          |                   |        |           |

#### `@factory`

| Name       | Aliases | Category | Permitted context | Typing | Modifiers |
| ---------- | ------- | -------- | ----------------- | ------ | --------- |
| `@factory` |         |          |                   |        |           |