local battery = require("items.widgets.battery")
local volume = require("items.widgets.volume")
local wechat_and_qq = require("items.widgets.wechat_and_qq")
local wifi = require("items.widgets.wifi")
local bluetooth = require("items.widgets.bluetooth")
local cpu_and_temp = require("items.widgets.cpu_and_temp")
local weather = require("items.weather")
-- local workspaces = require("items.spaces_aero")
-- local workspaces = require("items.spaces_yabai_dev")
local workspaces = require("items.spaces_aero_dev")
-- local workspaces = require("items.spaces")
-- local workspaces = require("items.spaces_flash_dev")
local apple = require("items.apple")
local cal = require("items.calendar")
-- local media = require("items.media")
-- local front_app = require("items.front_app")

local colors = require("colors")

sbar.add("bracket", {
	cpu_and_temp.cpu.name,
	cpu_and_temp.temp.name,
	wifi.wifi.name,
	wifi.wifi_up.name,
	wifi.wifi_down.name,
	volume.volume_icon.name,
	volume.volume_percent.name,
	bluetooth.bluetooth_icon.name,
    wechat_and_qq.wechat.name,
	cal.cal.name,
	weather.weather_icon.name,
	battery.battery.name,
}, {
	background = {
		color = colors.bg3,
		border_color = colors.bg3,
		border_width = 1,
		height = 30,
		corner_radius = 10,
	},
})

sbar.add("bracket", {
	bluetooth.bluetooth_icon.name,
	volume.volume_icon.name,
	volume.volume_percent.name,
    wechat_and_qq.wechat.name,
	cal.cal.name,
	weather.weather_icon.name,
}, { background = {
	color = 0x90494d64,
	height = 25,
} })

-- 构建工作区名称列表
local bracket_items = { apple.apple.name }

-- 添加存在的工作区
for _, ws_name in ipairs({"1", "2", "3", "4", "5", "6", "7", "8", "9", "B", "D", "E", "M", "N", "P", "T", "V"}) do
	if workspaces[ws_name] then
		table.insert(bracket_items, workspaces[ws_name].name)
	end
end

sbar.add("bracket", bracket_items, {
	background = {
		color = colors.bg3,
		border_color = colors.bg3,
		border_width = 1,
		height = 30,
		corner_radius = 10,
		-- padding_right = 200,
		-- padding_left = 0,
	},
})
-- sbar.add("bracket", {
-- 	apple.apple.name,
-- }, { background = {
-- 	color = 0x90494d64,
-- 	height = 25,
-- } })
