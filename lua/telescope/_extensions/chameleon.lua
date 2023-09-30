local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
	return
end

local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local telescope_config = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local config = require("chameleon.config")
local _chameleon = require("chameleon")

local function create_finder()
	local themes = config.get_config().themes

	table.sort(themes, function(a, b)
		return a.name:upper() < b.name:upper()
	end)
	return finders.new_table({
		results = themes,
		entry_maker = function(entry)
			return {
				value = entry,
				display = entry.name,
				ordinal = entry.name,
			}
		end,
	})
end

local function chameleon(opts)
	opts = opts or {}

	pickers
		.new(opts, {
			prompt_title = "Chameleon: Themes",
			finder = create_finder(),
			previewer = false,
			sorter = telescope_config.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local theme_config = selection.value
					_chameleon.switch(theme_config.name)
				end)
				return true
			end,
		})
		:find()
end

return telescope.register_extension({
	setup = config.setup,
	exports = {
		chameleon = chameleon,
	},
})
