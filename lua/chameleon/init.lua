local config = require("chameleon.config")
local loader = require("chameleon.loader")

local switch = function(opts)
	local theme_config = config.name_to_config(opts)

	if theme_config.before and type(theme_config.before) == "string" then
		local ok, before = pcall(loadstring, theme_config.before)
		if not ok then
			error("chameleon: failed executing 'before' action.")
		end
		if before then
			before()
		end
	end

	local ok, _ = pcall(vim.cmd, string.format("colorscheme %s", theme_config.colorscheme))
	if not ok then
		error(string.format("chameleon: theme is not loaded %s", theme_config.colorscheme))
	end

	if theme_config.after and type(theme_config.after) == "string" then
		local ok, after = pcall(loadstring, theme_config.after)
		if not ok then
			error("chameleon: failed executing 'after' action.")
		end
		if after then
			after()
		end
	end

	if config.save_dir_enabled() then
		loader.save(opts)
	end
end

return {
	switch = switch,
	setup = config.setup,
	restore = loader.restore,
}
