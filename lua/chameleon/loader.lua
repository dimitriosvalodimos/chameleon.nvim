local config = require("chameleon.config")

local function save(theme_name)
	local theme_config = config.name_to_config(theme_name)
	local save_path = config.get_config().save_path

	local file = io.open(save_path, "r")
	if file == nil then
		error(string.format("chameleon: Invalid file path '%s' for saving theme choice.", save_path))
	end

	local before_str = "nil"
	local after_str = "nil"

	if theme_config.before then
		before_str = theme_config.before
	end

	if theme_config.after then
		after_str = theme_config.after
	end

	local config_content = "-- chameleon.nvim\n"
		.. "-- This file is used to reload your theme settings on restart\n"
		.. string.format("local colorscheme = '%s'\n", theme_config.colorscheme)
		.. string.format("local before = %s\n", before_str)
		.. string.format("local after = %s\n", after_str)
		.. "return { colorscheme = colorscheme, before = before, after = after }"

	local outfile = io.open(save_path, "w")
	if outfile == nil then
		error(string.format("chameleon: Invalid file path '%s' for saving theme choice.", save_path))
	end
	outfile:write(config_content)
	outfile:close()
end

local function restore()
	local save_path = config.get_config().save_path
	local saved_config = dofile(save_path)

	if not saved_config.colorscheme then
		return
	end

	if saved_config.before and type(saved_config.before) == "function" then
		saved_config.before()
	end

	local ok, _ = pcall(vim.cmd, string.format("colorscheme %s", saved_config.colorscheme))
	if not ok then
		error("chameleon: theme not loaded")
	end

	if saved_config.after and type(saved_config.after) == "function" then
		saved_config.after()
	end
end

return {
	save = save,
	restore = restore,
}
