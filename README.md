chameleon.nvim

Theme switcher for neovim

---

![small demo](https://github.com/dimitriosvalodimos/chameleon.nvim/blob/main/chameleon.gif)

# :construction: CAUTION :construction:

This is my first plugin for anything, ever! It's also my first try at Lua. You have been warned.

## Features

- save/load your last theme selection
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) integration

## Wishlist

- [ ] theme preview on 'hover'

## Setup

The setup is admittedly a little bit involved.

- Install the themes of your choice
  - if your plugin manager has a lazy/ordering feature, make sure to assign a high priority to each of your theme plugins. Each theme has to be loaded inside neovim before `chameleon` can get to work.
- Setup `chameleon` as a [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) extension

```lua
{
    "nvim-telescope/telescope.nvim",
    dependencies = { "dimitriosvalodimos/chameleon.nvim" },
    lazy = false,
    config = function()
        local telescope = require("telescope")
        local chameleon = require("chameleon")
        telescope.setup({
            ..., -- rest of your telescope config
            extensions = {
                ..., -- other extensions
                chameleon = {
                    themes = {
                        "oxocarbon",
                        { name = "lighthaus" },
                        {
                            name = "onedark_deep",
                            colorscheme = "onedark",
                            before = [[
                                function()
                                    require("onedark").setup({ style = "deep" })
                                end
                            ]]
                        },
                        {
                            name = "ronny",
                            after = [[
                                function()
                                    require("ronny").setup()
                                end
                            ]]
                        }
                    },
                    save_path = "~/.config/nvim/lua/chameleon_save.lua",
                }
            }
        })
        telescope.load_extension("chameleon")
        chameleon.restore() -- load your last theme selection from a save-file
    end,
    keys = { { "<leader>ft", "<cmd>Telescope chameleon<cr>" } }
}
```

## What's happening here?

Let's step through this snippet in reverse

- `chameleon.restore()` loads your last theme selection from the `save_path` file
- `save_path` specifies the path to a pre-existing savefile on your machine. I would recommend creating a `.lua` file inside your neovims `lua` directory.
- `themes` has alot going on:

  - at a minimum, you have to specify a singular string-field that is the name of the colorscheme. As long as the colorscheme is callable under that name using `vim.cmd("colorscheme ...)` and you find the name descriptive enough, you're good to go.
  - `name` is the displayed name inside the [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) selection menu
  - `colorscheme` is the actual value being used to set the theme through `vim.cmd("colorscheme ...")`
  - `before` is a stringified function that will be called before setting the selected theme
  - `after` is a stringified function that will be called after setting the selected theme

The current setup only works if lazy-loading is explicitly DISABLED for [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim), since we need `chameleon` to run on startup (getting the last used theme and applying it).

You could load `chameleon` seperatly and later add the same config to the `telescope.setup.extensions` table, thus getting the theme-restoration and keeping telescope lazy-loaded. It's a little more work, but here you go:

```lua
local chameleon_config = {
    themes = {
        "oxocarbon",
        { name = "lighthaus" },
        {
            name = "onedark_deep",
            colorscheme = "onedark",
            before = [[
                function()
                    require("onedark").setup({ style = "deep" })
                end
            ]]
        },
        {
            name = "ronny",
            after = [[
                function()
                    require("ronny").setup()
                end
            ]]
        }
    },
    save_path = "~/.config/nvim/lua/chameleon_save.lua",
}

require("lazy").setup({
    ... -- themes
    {
        "dimitriosvalodimos/chameleon.nvim",
        lazy = false,
        config = function()
            local chameleon = require("chameleon")
            chameleon.setup(chameleon_config)
            chameleon.restore()
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "dimitriosvalodimos/chameleon.nvim" },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                ...,
                extensions = {
                    ...,
                    chameleon = chameleon_config
                }
            })
            telescope.load_extension("chameleon")
        end,
        keys = { { "<leader>ft", "<cmd>Telescope chameleon<cr>" } }
    }
})
```

## Credit

This plugin was heavily inspired by [themery.nvim](https://github.com/zaldih/themery.nvim). If you're looking for a simple theme-switcher with a command interface, I would pick this over my plugin.

### Why does this plugin exist then?

I created this plugin after I couldn't get the persistence feature inside themery to work on my machine. Later I tried "fixing" the persistence feature and failed. Thus I decided to create this plugin, to get persistent theme changes working and because I like using [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) when it comes to simple selection UIs.
