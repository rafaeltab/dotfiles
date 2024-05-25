require "utils.plugins"
require "utils.on_load"

Plugins:add({
	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
	},
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
})

OnLoad:add(function()

end)