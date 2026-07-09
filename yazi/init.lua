-- 设置插件配置

-- Full-border 边框美化
require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

--Yazi-line  状态栏美化
require("yaziline"):setup({
	-- color = "#98c379",
	-- secondary_color = "#5A6078",
	-- default_files_color = "darkgray", -- color of the file counter when it's inactive
	-- selected_files_color = "white",
	-- yanked_files_color = "green",
	-- cut_files_color = "red",

	separator_style = "angly", -- "angly" | "curvy" | "liney" | "empty"
	separator_open = "",
	separator_close = "",
	separator_open_thin = "",
	separator_close_thin = "",
	separator_head = "",
	separator_tail = "",

	select_symbol = "",
	yank_symbol = "󰆐",

	filename_max_length = 24, -- truncate when filename > 24
	filename_truncate_length = 6, -- leave 6 chars on both sides
	filename_truncate_separator = "...",
})

-- MacTag插件
require("mactag"):setup({
	-- Keys used to add or remove tags
	keys = {
		r = "Red",
		o = "Orange",
		y = "Yellow",
		g = "Green",
		b = "Blue",
		p = "Purple",
	},
	-- Colors used to display tags
	colors = {
		Red = "#ee7b70",
		Orange = "#f5bd5c",
		Yellow = "#fbe764",
		Green = "#91fc87",
		Blue = "#5fa3f8",
		Purple = "#cb88f8",
	},
	-- Order of the color circle showing in the line mode
	order = 500,
})

-- 回收站管理
require("recycle-bin"):setup({
	-- Optional: Override automatic trash directory discovery
	-- trash_dir = "~/.Trash", -- Uncomment to use specific directory
})

-- Git
require("git"):setup({
	-- Order of status signs showing in the linemode
	order = 1500,
})
