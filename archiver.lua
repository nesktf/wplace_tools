local conf = {["row-init"] = 647, ["row-end"] = 655, ["col-init"] = 1166, ["col-end"] = 1174}
local function make_dir(dirname)
  os.execute(("mkdir -p ./" .. dirname))
  return dirname
end
local function make_cmd(dir, row, col, count)
  local url = string.format("https://backend.wplace.live/files/s0/tiles/%d/%d.png", row, col)
  return string.format("wget \"%s\" -O ./%s/%d_%d_%d.png", url, dir, count, row, col)
end
local function populate_cmds(dir, grid)
  local count = 0
  local row_init = grid["row-init"]
  local row_end = grid["row-end"]
  local col_init = grid["col-init"]
  local col_end = grid["col-end"]
  local cmds = {}
  for row = row_init, row_end do
    for col = col_init, col_end do
      table.insert(cmds, make_cmd(dir, row, col, count))
      count = (count + 1)
    end
  end
  return cmds
end
local function call_cmds_21(cmds)
  print(("Remaining: " .. tostring(#cmds)))
  local remaining = {}
  for _i, cmd in ipairs(cmds) do
    local succ = os.execute(cmd)
    print(cmd)
    if not succ then
      table.insert(remaining, cmd)
    else
    end
  end
  return remaining
end
local dir = make_dir(os.date("%s"))
local cmds = populate_cmds(dir, conf)
while (#cmds > 0) do
  print(string.format("Calling %d commands!", #cmds))
  os.execute("sleep 1")
  cmds = call_cmds_21(cmds)
end
return print("Done!")
