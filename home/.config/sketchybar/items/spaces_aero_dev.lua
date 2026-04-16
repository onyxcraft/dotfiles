-- items/aerospace.lua
local colors = require("colors")
local settings = require("settings")
local icons = require("icons")
local app_icons = require("helpers.app_icons")

sbar.add("event", "aerospace_workspace_change")

local workspaces = {}

-- 获取所有工作区
local function getAllWorkspaces()
	local handle = io.popen("aerospace list-workspaces --all")
	local result = handle:read("*a")
	handle:close()
	
	local workspace_list = {}
	for workspace in result:gmatch("[^\r\n]+") do
		table.insert(workspace_list, workspace)
	end
	return workspace_list
end

-- 为每个工作区创建 item
local workspace_list = getAllWorkspaces()

for _, workspace_name in ipairs(workspace_list) do
	local space_item = sbar.add("item", "space." .. workspace_name, {
		position = "left",
		icon = {
			string = workspace_name,
			font = { family = settings.font.numbers },
			color = colors.white,
			highlight_color = colors.aerospace_icon_highlight_color,
			padding_left = 10,
			padding_right = 5,
		},
		label = {
			string = "",
			font = { family = "sketchybar-app-font", style = "Regular", size = 16.0 },
			color = colors.aerospace_label_color,
			highlight_color = colors.aerospace_label_highlight_color,
			padding_right = 10,
			y_offset = -1,
			drawing = false,
		},
		padding_right = 2,
		padding_left = 2,
		background = {
			color = colors.transparent,
			border_width = 0,
			border_color = colors.aerospace_border_color,
			height = 28,
		},
		click_script = "aerospace workspace " .. workspace_name,
	})

	workspaces[workspace_name] = space_item

	-- 订阅工作区切换事件
	space_item:subscribe("aerospace_workspace_change", function(env)
		local focused_workspace = env.FOCUSED_WORKSPACE
		local is_focused = (focused_workspace == workspace_name)

		-- 获取该工作区的窗口
		sbar.exec("aerospace list-windows --workspace " .. workspace_name .. " --format '%{app-name}' --json", function(windows)
			local icon_line = ""
			local has_windows = false
			
			if windows and type(windows) == "table" and #windows > 0 then
				has_windows = true
				for _, window in ipairs(windows) do
					local app_name = window["app-name"]
					local icon = app_icons[app_name] or app_icons["Default"] or ":default:"
					icon_line = icon_line .. " " .. icon
				end
			else
				icon_line = " —"
			end

			-- 只显示有窗口的工作区或当前聚焦的工作区
			local should_show = has_windows or is_focused

			sbar.animate("tanh", 15, function()
				space_item:set({
					icon = {
						highlight = is_focused,
						drawing = should_show,
					},
					label = {
						string = icon_line,
						highlight = is_focused,
						drawing = should_show and icon_line ~= "",
					},
					background = {
						border_width = is_focused and 1 or 0,
						drawing = should_show,
					},
					padding_right = should_show and 2 or 0,
					padding_left = should_show and 2 or 0,
				})
			end)
		end)
	end)

	-- 鼠标悬停效果
	space_item:subscribe("mouse.entered", function()
		sbar.animate("tanh", 20, function()
			space_item:set({
				background = {
					color = { color = colors.grey, alpha = 0.3 },
					border_color = { color = colors.bg1, alpha = 1.0 },
					border_width = 1,
				},
			})
		end)
	end)

	space_item:subscribe({ "mouse.exited", "mouse.exited.global" }, function()
		sbar.exec("aerospace list-workspaces --focused", function(focused)
			local is_focused = (focused:match("^%s*(.-)%s*$") == workspace_name)
			sbar.animate("tanh", 20, function()
				space_item:set({
					background = {
						color = colors.transparent,
						border_color = colors.aerospace_border_color,
						border_width = is_focused and 1 or 0,
					},
				})
			end)
		end)
	end)
end

-- 初始化：获取当前聚焦的工作区并触发更新
sbar.exec("aerospace list-workspaces --focused", function(focused_workspace)
	local focused = focused_workspace:match("^%s*(.-)%s*$")
	sbar.trigger("aerospace_workspace_change", { FOCUSED_WORKSPACE = focused })
end)

return workspaces
