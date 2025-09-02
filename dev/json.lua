--
-- json.lua
--
-- Copyright (c) 2020 rxi
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
-- the Software, and to permit persons to whom the Software is furnished to do
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
-- Modified by Gh0st352 for AETHR project.

--- @module AETHR.json
--- @brief JSON pretty serialization and parsing utilities.
AETHR.json = {}

-- Map of characters to their JSON escape codes
AETHR.json.escape_char_map = {
  ["\\"] = "\\",
  ["\""] = "\"",
  ["\b"] = "b",
  ["\f"] = "f",
  ["\n"] = "n",
  ["\r"] = "r",
  ["\t"] = "t",
}

-- Inverse escape map for parsing
AETHR.json.escape_char_map_inv = { ["/"] = "/" }
for k, v in pairs(AETHR.json.escape_char_map) do
  AETHR.json.escape_char_map_inv[v] = k
end

--- @brief Returns the JSON escape sequence for a given character
function AETHR.json.escape_char(c)
  return "\\" .. (AETHR.json.escape_char_map[c] or string.format("u%04x", c:byte()))
end

--- @brief Encodes a Lua string as a JSON string
function AETHR.json.encode_string(val)
  return '"' .. val:gsub('[%z\1-\31\\"]', AETHR.json.escape_char) .. '"'
end

--- @brief Encodes a Lua number as a JSON numeric literal
function AETHR.json.encode_number(val)
  if val ~= val or val <= -math.huge or val >= math.huge then
    error("unexpected number value '" .. tostring(val) .. "'")
  end
  return string.format("%.14g", val)
end

--- @brief Pretty-formats a Lua value into human-readable JSON with indentation
function AETHR.json.prettyEncode(val, indent)
  indent = indent or 0
  local t = type(val)
  if t == "table" then
    -- Detect array vs object
    local isArray = true
    local maxIndex = 0
    local keyCount = 0
    for k, v in pairs(val) do
      keyCount = keyCount + 1
      if type(k) ~= "number" or k ~= math.floor(k) or k < 1 then
        isArray = false
        break
      end
      if k > maxIndex then maxIndex = k end
    end
    if isArray and keyCount > 0 and maxIndex ~= keyCount then
      isArray = false
    end
    if keyCount == 0 then
      isArray = true
    end

    local items = {}
    if isArray then
      for i = 1, maxIndex do
        table.insert(items, AETHR.json.prettyEncode(val[i], indent + 2))
      end
      if #items == 0 then
        return "[]"
      end
      local pad = string.rep(" ", indent + 2)
      return "[\n" .. pad .. table.concat(items, ",\n" .. pad) .. "\n" .. string.rep(" ", indent) .. "]"
    else
      for k, v in pairs(val) do
        local key   = AETHR.json.encode_string(k)
        local value = AETHR.json.prettyEncode(v, indent + 2)
        table.insert(items, key .. ": " .. value)
      end
      if #items == 0 then
        return "{}"
      end
      local pad = string.rep(" ", indent + 2)
      return "{\n" .. pad .. table.concat(items, ",\n" .. pad) .. "\n" .. string.rep(" ", indent) .. "}"
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

-- Parsing utilities ----------------------------------------------------------

function AETHR.json.create_set(...)
  local res = {}
  for i = 1, select("#", ...) do
    res[select(i, ...)] = true
  end
  return res
end

AETHR.json.space_chars   = AETHR.json.create_set(" ", "\t", "\r", "\n")
AETHR.json.delim_chars   = AETHR.json.create_set(" ", "\t", "\r", "\n", "]", "}", ",")
AETHR.json.escape_chars  = AETHR.json.create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
AETHR.json.literals      = AETHR.json.create_set("true", "false", "null")
AETHR.json.literal_map   = { ["true"] = true, ["false"] = false, ["null"] = nil }

function AETHR.json.next_char(str, idx, set, negate)
  for i = idx, #str do
    if set[str:sub(i, i)] ~= negate then
      return i
    end
  end
  return #str + 1
end

function AETHR.json.decode_error(str, idx, msg)
  local line, col = 1, 1
  for i = 1, idx - 1 do
    col = col + 1
    if str:sub(i, i) == "\n" then
      line = line + 1
      col  = 1
    end
  end
  error(string.format("%s at line %d col %d", msg, line, col))
end

function AETHR.json.codepoint_to_utf8(n)
  local f = math.floor
  if n <= 0x7f then
    return string.char(n)
  elseif n <= 0x7ff then
    return string.char(f(n / 64) + 192, n % 64 + 128)
  elseif n <= 0xffff then
    return string.char(
      f(n / 4096) + 224,
      f(n % 4096 / 64) + 128,
      n % 64 + 128
    )
  elseif n <= 0x10ffff then
    return string.char(
      f(n / 262144) + 240,
      f(n % 262144 / 4096) + 128,
      f(n % 4096 / 64) + 128,
      n % 64 + 128
    )
  end
  error(string.format("invalid unicode codepoint '%x'", n))
end

function AETHR.json.parse_unicode_escape(s)
  local n1 = tonumber(s:sub(1,4), 16)
  local n2 = tonumber(s:sub(7,10),16)
  if n2 then
    return AETHR.json.codepoint_to_utf8((n1-0xd800)*0x400 + (n2-0xdc00) + 0x10000)
  else
    return AETHR.json.codepoint_to_utf8(n1)
  end
end

function AETHR.json.parse_string(str, i)
  local res, j, k = "", i + 1, i + 1
  while j <= #str do
    local xc = str:byte(j)
    if xc < 32 then
      AETHR.json.decode_error(str, j, "control character in string")
    elseif xc == 92 then
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
    elseif xc == 34 then
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
  local res, n = {}, 1
  i = i + 1
  while true do
    i = AETHR.json.next_char(str, i, AETHR.json.space_chars, true)
    if str:sub(i, i) == "]" then
      return res, i + 1
    end
    local val
    val, i = AETHR.json.parse(str, i)
    res[n], n = val, n + 1
    i = AETHR.json.next_char(str, i, AETHR.json.space_chars, true)
    local chr = str:sub(i, i)
    if chr == "]" then
      return res, i + 1
    elseif chr ~= "," then
      AETHR.json.decode_error(str, i, "expected ']' or ','")
    end
    i = i + 1
  end
end

function AETHR.json.parse_object(str, i)
  local res = {}
  i = i + 1
  while true do
    i = AETHR.json.next_char(str, i, AETHR.json.space_chars, true)
    if str:sub(i, i) == "}" then
      return res, i + 1
    end
    if str:sub(i, i) ~= '"' then
      AETHR.json.decode_error(str, i, "expected string for key")
    end
    local key, val
    key, i = AETHR.json.parse(str, i)
    i = AETHR.json.next_char(str, i, AETHR.json.space_chars, true)
    if str:sub(i, i) ~= ":" then
      AETHR.json.decode_error(str, i, "expected ':' after key")
    end
    i = AETHR.json.next_char(str, i + 1, AETHR.json.space_chars, true)
    val, i = AETHR.json.parse(str, i)
    res[key] = val
    i = AETHR.json.next_char(str, i, AETHR.json.space_chars, true)
    local chr = str:sub(i, i)
    if chr == "}" then
      return res, i + 1
    elseif chr ~= "," then
      AETHR.json.decode_error(str, i, "expected '}' or ','")
    end
    i = i + 1
  end
end

AETHR.json.char_func_map = {
  ['"'] = AETHR.json.parse_string,
  ['-'] = AETHR.json.parse_number,
  ['0'] = AETHR.json.parse_number,
  ['1'] = AETHR.json.parse_number,
  ['2'] = AETHR.json.parse_number,
  ['3'] = AETHR.json.parse_number,
  ['4'] = AETHR.json.parse_number,
  ['5'] = AETHR.json.parse_number,
  ['6'] = AETHR.json.parse_number,
  ['7'] = AETHR.json.parse_number,
  ['8'] = AETHR.json.parse_number,
  ['9'] = AETHR.json.parse_number,
  ['t'] = AETHR.json.parse_literal,
  ['f'] = AETHR.json.parse_literal,
  ['n'] = AETHR.json.parse_literal,
  ['['] = AETHR.json.parse_array,
  ['{'] = AETHR.json.parse_object,
}

function AETHR.json.parse(str, idx)
  local i = idx or AETHR.json.next_char(str, 1, AETHR.json.space_chars, true)
  local chr = str:sub(i, i)
  local f = AETHR.json.char_func_map[chr]
  if f then
    return f(str, i)
  end
  AETHR.json.decode_error(str, i, "unexpected character '" .. chr .. "'")
end

--- @brief Parses a JSON string into the corresponding Lua value
function AETHR.json.decode(str)
  if type(str) ~= "string" then
    error("expected argument of type string, got " .. type(str))
  end
  local res, idx = AETHR.json.parse(str)
  idx = AETHR.json.next_char(str, idx, AETHR.json.space_chars, true)
  if idx <= #str then
    AETHR.json.decode_error(str, idx, "trailing garbage")
  end
  return res
end
