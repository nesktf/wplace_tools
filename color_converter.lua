local chima = require("chimatools")
local insp = require("inspect")
local ctx = chima.context.new()
local ffi = require("ffi")
local function write_to_file(path, str)
  local _1_ = io.open(path, "wb")
  if (nil ~= _1_) then
    local file = _1_
    file:write(str)
    return file:close()
  elseif (_1_ == nil) then
    return print(("Failed to open " .. path))
  else
    return nil
  end
end
local function parse_color_str(str)
  local color_start = str:find("#")
  local cols = {}
  if (color_start == nil) then
    return nil
  else
    local len = (str:len() - color_start)
    for i = color_start, len, 2 do
      local hex = str:sub((i + 1), (i + 2))
      local num = tonumber(hex, 16)
      if (num ~= nil) then
        table.insert(cols, num)
      else
      end
    end
    return cols
  end
end
local function to_color_str(col)
  local str = "#"
  for _i, comp in ipairs(col) do
    str = (str .. string.format("%X", comp))
  end
  return str
end
local function wpl_lvl_pixels(lvl)
  local lvl_pow = (math.floor(lvl) * math.pow(30, 0.65))
  local pxl_pow = math.pow(lvl_pow, (1 / 0.65))
  return math.ceil(pxl_pow)
end
local function wpl_lvl_remaining(lvl, painted)
  return (wpl_lvl_pixels(lvl) - painted)
end
print(wpl_lvl_pixels(108), wpl_lvl_remaining(108, 39771))
local colors = {{name = "black", value = {0, 0, 0}}, {name = "dark-gray", value = {60, 60, 60}}, {name = "gray", value = {120, 120, 120}}, {name = "light-gray", value = {210, 210, 210}}, {name = "white", value = {255, 255, 255}}, {name = "deep-red", value = {96, 0, 24}}, {name = "red", value = {237, 28, 36}}, {name = "orange", value = {255, 127, 39}}, {name = "gold", value = {246, 170, 9}}, {name = "yellow", value = {249, 221, 59}}, {name = "light-yellow", value = {255, 250, 188}}, {name = "dark-green", value = {14, 185, 104}}, {name = "green", value = {19, 230, 123}}, {name = "light-green", value = {135, 255, 94}}, {name = "dark-teal", value = {12, 129, 110}}, {name = "teal", value = {16, 174, 166}}, {name = "light-teal", value = {19, 225, 190}}, {name = "cyan", value = {96, 247, 242}}, {name = "dark-blue", value = {40, 80, 158}}, {name = "blue", value = {64, 147, 228}}, {name = "indigo", value = {107, 80, 246}}, {name = "light-indigo", value = {153, 177, 251}}, {name = "dark-purple", value = {120, 12, 153}}, {name = "purple", value = {170, 56, 185}}, {name = "light-purple", value = {224, 159, 249}}, {name = "dark-pink", value = {203, 0, 122}}, {name = "pink", value = {236, 31, 128}}, {name = "light-pink", value = {243, 141, 169}}, {name = "dark-brown", value = {104, 70, 52}}, {name = "brown", value = {149, 104, 42}}, {name = "beige", value = {248, 178, 119}}, {name = "medium-gray", value = {170, 170, 170}}, {name = "dark-red", value = {165, 14, 30}}, {name = "light-red", value = {250, 128, 114}}, {name = "dark-orange", value = {228, 92, 26}}, {name = "dark-goldenrod", value = {156, 132, 49}}, {name = "goldenrod", value = {197, 173, 49}}, {name = "light-goldenrod", value = {232, 212, 95}}, {name = "dark-olive", value = {74, 107, 58}}, {name = "olive", value = {90, 148, 74}}, {name = "light-olive", value = {132, 197, 115}}, {name = "dark-cyan", value = {15, 121, 159}}, {name = "light-cyan", value = {187, 250, 242}}, {name = "light-blue", value = {125, 199, 255}}, {name = "dark-indigo", value = {77, 49, 184}}, {name = "dark-slate-blue", value = {74, 66, 132}}, {name = "slate-blue", value = {122, 113, 196}}, {name = "light-slate-blue", value = {181, 174, 241}}, {name = "dark-peach", value = {155, 82, 73}}, {name = "peach", value = {209, 128, 120}}, {name = "light-peach", value = {250, 182, 164}}, {name = "light-brown", value = {219, 164, 99}}, {name = "dark-tan", value = {123, 99, 82}}, {name = "tan", value = {156, 132, 107}}, {name = "light-tan", value = {214, 181, 148}}, {name = "dark-beige", value = {209, 128, 81}}, {name = "light-beige", value = {255, 197, 165}}, {name = "dark-stone", value = {109, 100, 63}}, {name = "stone", value = {148, 140, 107}}, {name = "light-stone", value = {205, 197, 158}}, {name = "dark-slate", value = {51, 57, 65}}, {name = "slate", value = {109, 117, 141}}, {name = "light-slate", value = {179, 185, 209}}}
local paid_names = {["medium-gray"] = {170, 170, 170}, ["dark-red"] = {165, 14, 30}, ["light-red"] = {250, 128, 114}, ["dark-orange"] = {228, 92, 26}, ["dark-goldenrod"] = {156, 132, 49}, goldenrod = {197, 173, 49}, ["light-goldenrod"] = {232, 212, 95}, ["dark-olive"] = {74, 107, 58}, olive = {90, 148, 74}, ["light-olive"] = {132, 197, 115}, ["dark-cyan"] = {15, 121, 159}, ["light-cyan"] = {187, 250, 242}, ["light-blue"] = {125, 199, 255}, ["dark-indigo"] = {77, 49, 184}, ["dark-slate-blue"] = {74, 66, 132}, ["slate-blue"] = {122, 113, 196}, ["light-slate-blue"] = {181, 174, 241}, ["dark-peach"] = {155, 82, 73}, peach = {209, 128, 120}, ["light-peach"] = {250, 182, 164}, ["light-brown"] = {219, 164, 99}, ["dark-tan"] = {123, 99, 82}, tan = {156, 132, 107}, ["light-tan"] = {214, 181, 148}, ["dark-beige"] = {209, 128, 81}, ["light-beige"] = {255, 197, 165}, ["dark-stone"] = {109, 100, 63}, stone = {148, 140, 107}, ["light-stone"] = {205, 197, 158}, ["dark-slate"] = {51, 57, 65}, slate = {109, 117, 141}, ["light-slate"] = {179, 185, 209}}
local base_colors
do
  local tbl_21_ = {}
  local i_22_ = 0
  for _, color in ipairs(colors) do
    local val_23_
    if (paid_names[color.name] == nil) then
      val_23_ = color
    else
      val_23_ = nil
    end
    if (nil ~= val_23_) then
      i_22_ = (i_22_ + 1)
      tbl_21_[i_22_] = val_23_
    else
    end
  end
  base_colors = tbl_21_
end
local function clamp_color(r, g, b)
  local col = base_colors[1]
  local min_dist = math.huge
  for _, color in ipairs(base_colors) do
    local pr = color.value[1]
    local pg = color.value[2]
    local pb = color.value[3]
    local rmean = ((pr + r) / 2)
    local dr = (pr - r)
    local dg = (pg - g)
    local db = (pb - b)
    local x = math.floor((((512 + rmean) * dr * dr) / 256))
    local y = (4 * dg * dg)
    local z = math.floor((((767 - rmean) * db * db) / 256))
    local dist = math.sqrt((x + y + z))
    if (dist < min_dist) then
      min_dist = dist
      col = color
    else
    end
  end
  return col.value
end
local in_file = arg[1]
if (type(in_file) ~= "string") then
  print("No file provided")
  os.exit(1)
else
end
local out_file = ("converted-" .. in_file)
local function write_file(src)
  local non_empties = 0
  print(string.format("Image size: %dx%d - Channels: %d", src.width, src.height, src.channels))
  local chima_empty = chima.color.new(0, 0, 0, 0)
  local dst = chima.image.new(ctx, src.width, src.height, src.channels, chima_empty)
  local stride = (src.channels * 1)
  local src_data = ffi.cast("uint8_t*", src.data)
  local dst_data = ffi.cast("uint8_t*", dst.data)
  for y = 0, (src.height - 1) do
    for x = 0, (src.width - 1) do
      local pixel_pos = (((y * src.width) + x) * stride)
      local src_pixel = (src_data + pixel_pos)
      local dst_pixel = (dst_data + pixel_pos)
      local r = src_pixel[0]
      local g = src_pixel[1]
      local b = src_pixel[2]
      local a = src_pixel[3]
      local _let_9_ = clamp_color(r, g, b)
      local nr = _let_9_[1]
      local ng = _let_9_[2]
      local nb = _let_9_[3]
      if (a ~= 0) then
        non_empties = (non_empties + 1)
      else
      end
      dst_pixel[0] = nr
      dst_pixel[1] = ng
      dst_pixel[2] = nb
      dst_pixel[3] = a
    end
  end
  dst:write(out_file, chima.image.format.png)
  return print(string.format("File written at %s (%d pixels)", out_file, non_empties))
end
local _11_, _12_, _13_ = chima.image.load(ctx, nil, in_file)
if (nil ~= _11_) then
  local src = _11_
  return write_file(src)
elseif ((_11_ == nil) and (nil ~= _12_) and true) then
  local err = _12_
  local _ret = _13_
  print(err)
  return os.exit(1)
else
  return nil
end
