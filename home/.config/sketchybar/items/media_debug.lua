local colors = require("colors")

local D = {}

D.probe = sbar.add("item", "media_probe", {
  position = "left",
  icon = { drawing = false },
  label = {
    drawing = true,
    width = "dynamic",
    color = colors.orange,
    font = { size = 10 },
  },
  drawing = true,
})

D.probe:subscribe({ "media_change" }, function(env)
  if env and env.INFO then
    local app = env.INFO.app or "?"
    local state = env.INFO.state or "?"
    local title = env.INFO.title or ""
    local artist = env.INFO.artist or ""
    local l = string.format("[%s] %s - %s (%s)", app, title, artist, state)
    D.probe:set({ label = l })
  else
    D.probe:set({ label = "no media_change" })
  end
end)

return D

