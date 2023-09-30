local _setup = {}

local function normalize_path()
	if not _setup.save_path then
		return
	end

	_setup.save_path = vim.fn.fnamemodify(_setup.save_path, ":p")
end

local function normalize_setup()
	if not _setup.themes then
		error("chameleon: 'themes' is a required field inside the config")
	end

	for index, value in ipairs(_setup.themes) do
		if type(value) == "string" then
			_setup.themes[index] = {
				name = value,
				colorscheme = value,
			}
		end
		if value.name and not value.colorscheme then
			local tmp = vim.tbl_deep_extend("force", _setup.themes[index], value)
			tmp.colorscheme = tmp.name
			_setup.themes[index] = tmp
		end
	end
end

local function setup(user_config)
	_setup = vim.tbl_deep_extend("keep", user_config, {})

	normalize_setup()
	normalize_path()
end

local function get_config()
	return _setup
end

local function save_path_enabled()
	return _setup.save_path ~= nil
end

local function name_to_config(theme_name)
	for _, value in ipairs(_setup.themes) do
		if value.name == theme_name then
			return value
		end
	end
	return {}
end

return {
	setup = setup,
	normalize_path = normalize_path,
	normalize_setup = normalize_setup,
	save_path_enabled = save_path_enabled,
	get_config = get_config,
	name_to_config = name_to_config,
}
