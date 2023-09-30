vim.api.nvim_create_user_command("Chameleon", function(opts)
	require("chameleon").switch(opts.args)
end, {})
