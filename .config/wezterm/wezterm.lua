local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

local process_icons = {
	["docker"] = wezterm.nerdfonts.linux_docker,
	["docker-compose"] = wezterm.nerdfonts.linux_docker,
	["psql"] = wezterm.nerdfonts.dev_postgresql,
	["kuberlr"] = wezterm.nerdfonts.linux_docker,
	["kubectl"] = wezterm.nerdfonts.linux_docker,
	["stern"] = wezterm.nerdfonts.linux_docker,
	["nvim"] = wezterm.nerdfonts.custom_vim,
	["make"] = wezterm.nerdfonts.seti_makefile,
	["vim"] = wezterm.nerdfonts.dev_vim,
	["go"] = wezterm.nerdfonts.seti_go,
	["zsh"] = wezterm.nerdfonts.dev_terminal,
	["bash"] = wezterm.nerdfonts.cod_terminal_bash,
	["btm"] = wezterm.nerdfonts.mdi_chart_donut_variant,
	["htop"] = wezterm.nerdfonts.mdi_chart_donut_variant,
	["cargo"] = wezterm.nerdfonts.dev_rust,
	["sudo"] = wezterm.nerdfonts.fa_hashtag,
	["lazydocker"] = wezterm.nerdfonts.linux_docker,
	["git"] = wezterm.nerdfonts.dev_git,
	["lua"] = wezterm.nerdfonts.seti_lua,
	["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
	["curl"] = wezterm.nerdfonts.mdi_flattr,
	["gh"] = wezterm.nerdfonts.dev_github_badge,
	["ruby"] = wezterm.nerdfonts.cod_ruby,
	["pwsh"] = wezterm.nerdfonts.seti_powershell,
	["node"] = wezterm.nerdfonts.dev_nodejs_small,
	["dotnet"] = wezterm.nerdfonts.md_language_csharp,
}
local function get_process(tab)
	local process_name = tab.active_pane.foreground_process_name:match("([^/\\]+)%.exe$")
		or tab.active_pane.foreground_process_name:match("([^/\\]+)$")

	-- local icon = process_icons[process_name] or string.format('[%s]', process_name)
	local icon = process_icons[process_name] or wezterm.nerdfonts.seti_checkbox_unchecked

	return icon
end
local get_last_folder_segment = function(cwd)
	local s = string.gsub(cwd, "cute", "great")
	if cwd ~= nil then
		return s -- or some default value you prefer
	end
	-- Strip off 'file:///' if present
	local pathStripped = cwd:match("^file://(.+)") or cwd
	-- Normalize backslashes to slashes for Windows paths
	pathStripped = pathStripped:gsub("\\", "/")
	-- Split the path by '/'
	local path = {}
	for segment in string.gmatch(pathStripped, "[^/]+") do
		table.insert(path, segment)
	end
	return "test" -- returns the last segment
end

local function get_current_working_dir(tab)
	local process_name = tab.active_pane.foreground_process_name:match("([^/\\]+)%.exe$")
		or tab.active_pane.foreground_process_name:match("([^/\\]+)$")
	return process_name
end
function scandir()
	print()
	local i, t, popen = 0, {}, io.popen

	local pfile = popen("find ~/personal ~/.config -mindepth 1 -maxdepth 1 -type d ")
	for filename in pfile:lines() do
		i = i + 1
		t[i] = { id = filename, label = filename:match("^.+[\\/](.+)$") }
	end
	pfile:close()
	return t
end
--
-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
--local colors = require("lua/rose-pine").colors()
--local window_frame = require("lua/rose-pine").window_frame()
config.color_scheme = "rose-pine"
config.colors = {
	tab_bar = {
		background = "rgba(0,0,0,0)",
		active_tab = {
			bg_color = "#524f67",
			fg_color = "#e0def4",
		},
		inactive_tab = {
			bg_color = "#21202e",
			fg_color = "#e0def4",
		},
		new_tab = {
			bg_color = "#21202e",
			fg_color = "#e0def4",
		},
	},
}
config.font = wezterm.font_with_fallback({
	"Jetbrains Mono",
	"Hack Nerd Font",
})
-- then finally apply the plugin
-- these are currently the defaults:
config.disable_default_key_bindings = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = "b", mods = "CTRL" }
config.keys = {
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "h",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
	{
		key = "%",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "v",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "x",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ domain = "CurrentPaneDomain", confirm = true }),
	},
	{ key = "W", mods = "LEADER|SHIFT", action = wezterm.action.ShowLauncher },
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			-- Here you can dynamically construct a longer list if needed
			local workfolders = scandir()
			window:perform_action(
				act.InputSelector({
					action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
						if not id and not label then
							wezterm.log_info("cancelled")
						else
							wezterm.log_info("id = " .. id)
							wezterm.log_info("label = " .. label)
							inner_window:perform_action(
								act.SwitchToWorkspace({
									name = label,
									spawn = {
										label = "Workspace: " .. label,
										cwd = id,
									},
								}),
								inner_pane
							)
						end
					end),
					title = "Choose Workspace",
					choices = workfolders,
					fuzzy = true,
					fuzzy_description = "Fuzzy find and/or make a workspace",
				}),
				pane
			)
		end),
	},
}
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, caonfig, hover, max_width)
	local has_unseen_output = false
	local is_zoomed = false

	for _, pane in ipairs(tab.panes) do
		if not tab.is_active and pane.has_unseen_output then
			has_unseen_output = true
		end
		if pane.is_zoomed then
			is_zoomed = true
		end
	end

	local cwd = get_current_working_dir(tab)
	local process = get_process(tab)
	local zoom_icon = is_zoomed and wezterm.nerdfonts.cod_zoom_in or ""
	local title = string.format(" %s: %s ~ %s ", tab.tab_index + 1, process, cwd) -- Add placeholder for zoom_icon

	return wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Text = title },
	})
end)
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.96
config.tab_bar_at_bottom = true
local mux = wezterm.mux

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

return config
