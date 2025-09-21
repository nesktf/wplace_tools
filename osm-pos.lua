local zoom_lvl = 19
local anchors_corner = {{chunk = {x = 651, y = 1170}, pos = {x = 0, y = 0}, view = {x = 3000, y = 2000}, coord = {lat = -24.846644802634, lng = -65.566318690723}}, {chunk = {x = 650, y = 1170}, pos = {x = 999, y = 0}, view = {x = 2999, y = 2000}, coord = {lat = -24.846644802634, lng = -65.566494471973}}, {chunk = {x = 650, y = 1169}, pos = {x = 999, y = 999}, view = {x = 2999, y = 1999}, coord = {lat = -24.846485292349, lng = -65.566494471973}}, {chunk = {x = 651, y = 1169}, pos = {x = 0, y = 999}, view = {x = 3000, y = 1999}, coord = {lat = -24.846485292349, lng = -65.566318690723}}}
local anchors_single = {{pos = {x = 0, y = 0}, view = {x = 3000, y = 2000}, coord = {lat = -24.846644802634, lng = -65.566318690723}}, {pos = {x = 999, y = 999}, view = {x = 3999, y = 2999}, coord = {lat = -25.005892703814, lng = -65.390713221973}}, {pos = {x = 999, y = 0}, view = {x = 3999, y = 2000}, coord = {lat = -24.846644802634, lng = -65.390713221973}}, {pos = {x = 0, y = 999}, view = {x = 3000, y = 2999}, coord = {lat = -25.005892703814, lng = -65.566318690723}}}
local pixel_ratios = {["x-lng"] = (anchors_corner[1].coord.lng - anchors_corner[2].coord.lng), ["y-lat"] = (anchors_corner[2].coord.lat - anchors_corner[3].coord.lat)}
local chunk_ratios = {["x-lng"] = (pixel_ratios["x-lng"] * 1000), ["y-lat"] = (pixel_ratios["y-lat"] * 1000)}
print((chunk_ratios["x-lng"] * 651), (chunk_ratios["y-lat"] * 1170))
local function rad__3edeg(rad_ang)
  return (rad_ang * (180 / math.pi))
end
local function deg__3erad(deg_ang)
  return (deg_ang * (math.pi / 180))
end
local function sinh(x)
  return ((math.exp(x) - math.exp(( - x))) / 2)
end
local function coord__3eosmtile(lat, lng, zoom)
  local lat_rad = deg__3erad(lat)
  local n = math.pow(2, zoom)
  local nz_1 = (n / 2)
  local xtile = (n * ((lng + 180) / 360))
  local lat_log = math.log((math.tan(lat_rad) + (1 / math.cos(lat_rad))))
  local ytile = (nz_1 * (1 - (lat_log / math.pi)))
  return {xtile = xtile, ytile = ytile, zoom = zoom}
end
local function osmtile__3ecoord(xtile, ytile, zoom)
  local n = math.pow(2, zoom)
  local lng = (((xtile / n) * 360) - 180)
  local lat_sinh = sinh((math.pi * (1 - (2 * (ytile / n)))))
  local lat = rad__3edeg(math.atan(lat_sinh))
  return {lat = lat, lng = lng, zoom = zoom}
end
for _i, _1_ in ipairs(anchors_corner) do
  local _chunk = _1_["_chunk"]
  local _pos = _1_["_pos"]
  local coord = _1_["coord"]
  local lat = coord["lat"]
  local lng = coord["lng"]
  local _let_2_ = coord__3eosmtile(lat, lng, zoom_lvl)
  local xtile = _let_2_["xtile"]
  local ytile = _let_2_["ytile"]
  local _let_3_ = osmtile__3ecoord(xtile, ytile, zoom_lvl)
  local lat2 = _let_3_["lat"]
  local lng2 = _let_3_["lng"]
  print(string.format("(%f,%f) -> (%d,%d) -> (%f,%f)", lat, lng, xtile, ytile, lat2, lng2))
end
return nil
