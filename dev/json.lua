--
-- json.lua
--
-- Copyright (c) 2020 rxi
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
-- _version = "0.1.2"

--- @module AETHR.json
--- @brief JSON serialization and parsing utilities.
AETHR.json = {}

-------------------------------------------------------------------------------
-- Encode
-------------------------------------------------------------------------------

 AETHR.json.escape_char_map = {
  [ "\\" ] = "\\",
  [ "\"" ] = "\"",
  [ "\b" ] = "b",
  [ "\f" ] = "f",
  [ "\n" ] = "n",
  [ "\r" ] = "r",
  [ "\t" ] = "t",
}

AETHR.json.escape_char_map_inv = { [ "/" ] = "/" }
for k, v in pairs(AETHR.json.escape_char_map) do
  AETHR.json.escape_char_map_inv[v] = k
end


 function AETHR.json.escape_char(c)
  return "\\" .. (AETHR.json.escape_char_map[c] or string.format("u%04x", c:byte()))
end


function AETHR.json.encode_nil(val)
  return "null"
end


function AETHR.json.encode_table(val, stack)
  local res = {}
  stack = stack or {}

  -- Circular reference?
  if stack[val] then error("circular reference") end

  stack[val] = true

  if rawget(val, 1) ~= nil or next(val) == nil then
    -- Treat as array -- check keys are valid and it is not sparse
    local n = 0
    for k in pairs(val) do
      if type(k) ~= "number" then
        error("invalid table: mixed or invalid key types")
      end
      n = n + 1
    end
    if n ~= #val then
      error("invalid table: sparse array")
    end
    -- Encode
    for i, v in ipairs(val) do
      table.insert(res, AETHR.json.encode(v, stack))
    end
    stack[val] = nil
    return "[" .. table.concat(res, ",") .. "]"

  else
    -- Treat as an object
    for k, v in pairs(val) do
      if type(k) ~= "string" then
        error("invalid table: mixed or invalid key types")
      end
      table.insert(res, AETHR.json.encode(k, stack) .. ":" .. AETHR.json.encode(v, stack))
    end
    stack[val] = nil
    return "{" .. table.concat(res, ",") .. "}"
  end
end


function AETHR.json.encode_string(val)
  return '"' .. val:gsub('[%z\1-\31\\"]', AETHR.json.escape_char) .. '"'
end


function AETHR.json.encode_number(val)
  -- Check for NaN, -inf and inf
  if val ~= val or val <= -math.huge or val >= math.huge then
    error("unexpected number value '" .. tostring(val) .. "'")
  end
  return string.format("%.14g", val)
end


AETHR.json.type_func_map = {
  [ "nil"     ] = AETHR.json.encode_nil,
  [ "table"   ] = AETHR.json.encode_table,
  [ "string"  ] = AETHR.json.encode_string,
  [ "number"  ] = AETHR.json.encode_number,
  [ "boolean" ] = AETHR.json.tostring,
}


AETHR.json.encode = function(val, stack)
  local t = type(val)
  local f = AETHR.json.type_func_map[t]
  if f then
    return f(val, stack)
  end
  error("unexpected type '" .. t .. "'")
end


-------------------------------------------------------------------------------
-- Decode
-------------------------------------------------------------------------------



function AETHR.json.create_set(...)
  local res = {}
  for i = 1, select("#", ...) do
    res[ select(i, ...) ] = true
  end
  return res
end

AETHR.json.space_chars   = AETHR.json.create_set(" ", "\t", "\r", "\n")
AETHR.json.delim_chars   = AETHR.json.create_set(" ", "\t", "\r", "\n", "]", "}", ",")
AETHR.json.escape_chars  = AETHR.json.create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
AETHR.json.literals      = AETHR.json.create_set("true", "false", "null")

AETHR.json.literal_map = {
  [ "true"  ] = true,
  [ "false" ] = false,
  [ "null"  ] = nil,
}


function AETHR.json.next_char(str, idx, set, negate)
  for i = idx, #str do
    if set[str:sub(i, i)] ~= negate then
      return i
    end
  end
  return #str + 1
end


function AETHR.json.decode_error(str, idx, msg)
  local line_count = 1
  local col_count = 1
  for i = 1, idx - 1 do
    col_count = col_count + 1
    if str:sub(i, i) == "\n" then
      line_count = line_count + 1
      col_count = 1
    end
  end
  error( string.format("%s at line %d col %d", msg, line_count, col_count) )
end


function AETHR.json.codepoint_to_utf8(n)
  -- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
  local f = math.floor
  if n <= 0x7f then
    return string.char(n)
  elseif n <= 0x7ff then
    return string.char(f(n / 64) + 192, n % 64 + 128)
  elseif n <= 0xffff then
    return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
  elseif n <= 0x10ffff then
    return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128,
                       f(n % 4096 / 64) + 128, n % 64 + 128)
  end
  error( string.format("invalid unicode codepoint '%x'", n) )
end


function AETHR.json.parse_unicode_escape(s)
  local n1 = tonumber( s:sub(1, 4),  16 )
  local n2 = tonumber( s:sub(7, 10), 16 )
   -- Surrogate pair?
  if n2 then
    return AETHR.json.codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
  else
    return AETHR.json.codepoint_to_utf8(n1)
  end
end


function AETHR.json.parse_string(str, i)
  local res = ""
  local j = i + 1
  local k = j

  while j <= #str do
    local x = str:byte(j)

    if x < 32 then
      AETHR.json.decode_error(str, j, "control character in string")

    elseif x == 92 then -- `\`: Escape
      res = res .. str:sub(k, j - 1)
      j = j + 1
      local c = str:sub(j, j)
      if c == "u" then
        local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
                 or str:match("^%x%x%x%x", j + 1)
                 or AETHR.json.decode_error(str, j - 1, "invalid unicode escape in string")
        res = res .. AETHR.json.parse_unicode_escape(hex)
        j = j + #hex
      else
        if not AETHR.json.escape_chars[c] then
          AETHR.json.decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
        end
        res = res .. AETHR.json.escape_char_map_inv[c]
      end
      k = j + 1

    elseif x == 34 then -- `"`: End of string
      res = res .. str:sub(k, j - 1)
      return res, j + 1
    end

    j = j + 1
  end

  AETHR.json.decode_error(str, i, "expected closing quote for string")
end


function AETHR.json.parse_number(str, i)
  local x = AETHR.json.next_char(str, i, AETHR.json.delim_chars)
  local s = str:sub(i, x - 1)
  local n = tonumber(s)
  if not n then
    AETHR.json.decode_error(str, i, "invalid number '" .. s .. "'")
  end
  return n, x
end


function AETHR.json.parse_literal(str, i)
  local x = AETHR.json.next_char(str, i, AETHR.json.delim_chars)
  local word = str:sub(i, x - 1)
  if not AETHR.json.literals[word] then
    AETHR.json.decode_error(str, i, "invalid literal '" .. word .. "'")
  end
  return AETHR.json.literal_map[word], x
end


function AETHR.json.parse_array(str, i)
  local res = {}
  local n = 1
  i = i + 1
  while 1 do
    local x
    i = AETHR.json.next_char(str, i, AETHR.json.space_chars, true)
    -- Empty / end of array?
    if str:sub(i, i) == "]" then
      i = i + 1
      break
    end
    -- Read token
    x, i = AETHR.json.parse(str, i)
    res[n] = x
    n = n + 1
    -- Next token
    i = AETHR.json.next_char(str, i, AETHR.json.space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "]" then break end
    if chr ~= "," then AETHR.json.decode_error(str, i, "expected ']' or ','") end
  end
  return res, i
end


function AETHR.json.parse_object(str, i)
  local res = {}
  i = i + 1
  while 1 do
    local key, val
    i = AETHR.json.next_char(str, i, AETHR.json.space_chars, true)
    -- Empty / end of object?
    if str:sub(i, i) == "}" then
      i = i + 1
      break
    end
    -- Read key
    if str:sub(i, i) ~= '"' then
      AETHR.json.decode_error(str, i, "expected string for key")
    end
    key, i = AETHR.json.parse(str, i)
    -- Read ':' delimiter
    i = AETHR.json.next_char(str, i, AETHR.json.space_chars, true)
    if str:sub(i, i) ~= ":" then
      AETHR.json.decode_error(str, i, "expected ':' after key")
    end
    i = AETHR.json.next_char(str, i + 1, AETHR.json.space_chars, true)
    -- Read value
    val, i = AETHR.json.parse(str, i)
    -- Set
    res[key] = val
    -- Next token
    i = AETHR.json.next_char(str, i, AETHR.json.space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "}" then break end
    if chr ~= "," then AETHR.json.decode_error(str, i, "expected '}' or ','") end
  end
  return res, i
end


AETHR.json.char_func_map = {
  [ '"' ] = AETHR.json.parse_string,
  [ "0" ] = AETHR.json.parse_number,
  [ "1" ] = AETHR.json.parse_number,
  [ "2" ] = AETHR.json.parse_number,
  [ "3" ] = AETHR.json.parse_number,
  [ "4" ] = AETHR.json.parse_number,
  [ "5" ] = AETHR.json.parse_number,
  [ "6" ] = AETHR.json.parse_number,
  [ "7" ] = AETHR.json.parse_number,
  [ "8" ] = AETHR.json.parse_number,
  [ "9" ] = AETHR.json.parse_number,
  [ "-" ] = AETHR.json.parse_number,
  [ "t" ] = AETHR.json.parse_literal,
  [ "f" ] = AETHR.json.parse_literal,
  [ "n" ] = AETHR.json.parse_literal,
  [ "[" ] = AETHR.json.parse_array,
  [ "{" ] = AETHR.json.parse_object,
}


AETHR.json.parse = function(str, idx)
  local chr = str:sub(idx, idx)
  local f = AETHR.json.char_func_map[chr]
  if f then
    return f(str, idx)
  end
  AETHR.json.decode_error(str, idx, "unexpected character '" .. chr .. "'")
end


function AETHR.json.decode(str)
  if type(str) ~= "string" then
    error("expected argument of type string, got " .. type(str))
  end
  local res, idx = AETHR.json.parse(str, AETHR.json.next_char(str, 1, AETHR.json.space_chars, true))
  idx = AETHR.json.next_char(str, idx, AETHR.json.space_chars, true)
  if idx <= #str then
    AETHR.json.decode_error(str, idx, "trailing garbage")
  end
  return res
end

function AETHR.json.prettyEncode(val, indent)
	indent = indent or 0
	local t = type(val)
	if t == "table" then
		-- Better array detection: check if all keys are consecutive integers starting from 1
		local isArray = true
		local maxIndex = 0
		local keyCount = 0
		
		for k, v in pairs(val) do
			keyCount = keyCount + 1
			if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
				isArray = false
				break
			end
			if k > maxIndex then
				maxIndex = k
			end
		end
		
		-- If it's not empty and has gaps or doesn't start at 1, it's not an array
		if isArray and keyCount > 0 and maxIndex ~= keyCount then
			isArray = false
		end
		
		-- Empty table is treated as array
		if keyCount == 0 then
			isArray = true
		end
		
		local items = {}
		if isArray then
			-- Handle as array
			for i = 1, maxIndex do
				table.insert(items, AETHR.json.prettyEncode(val[i], indent + 2))
			end
			if #items == 0 then
				return "[]"
			end
			return "[\n" .. string.rep(" ", indent + 2) ..
				table.concat(items, ",\n" .. string.rep(" ", indent + 2)) .. "\n" ..
				string.rep(" ", indent) .. "]"
		else
			-- Handle as object
			for k, v in pairs(val) do
				local key = AETHR.json.prettyEncode(k, 0) -- Keys don't need indentation
				local value = AETHR.json.prettyEncode(v, indent + 2)
				table.insert(items, key .. ": " .. value)
			end
			if #items == 0 then
				return "{}"
			end
			return "{\n" .. string.rep(" ", indent + 2) ..
				table.concat(items, ",\n" .. string.rep(" ", indent + 2)) .. "\n" ..
				string.rep(" ", indent) .. "}"
		end
	elseif t == "string" then
		return AETHR.json.encode_string(val)
	elseif t == "number" then
		return AETHR.json.encode_number(val)
	elseif t == "boolean" then
		return tostring(val)
	elseif t == "nil" then
		return "null"
	end
	error("Cannot prettyEncode type '" .. t .. "'")
end
