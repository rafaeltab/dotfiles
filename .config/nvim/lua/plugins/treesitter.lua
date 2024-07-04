Plugins:add({
	{
		-- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
	},
	{
		'nvim-treesitter/playground'
	}
})

OnLoad:add(function()
	local treesitter_highlight = true
	if vim.g.vscode then
		treesitter_highlight = false
	end

	local treesitter_languages = vim.list_extend({ 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'vimdoc', 'vim', 'ini' },
		Languages.treesitter)


	-- [[ Configure Treesitter ]]
	-- See `:help nvim-treesitter`
	require('nvim-treesitter.configs').setup {
		modules = {},
		sync_install = true,
		ignore_install = {},
		-- Add languages to be installed here that you want installed for treesitter
		ensure_installed = treesitter_languages,

		-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
		auto_install = true,
		highlight = { enable = treesitter_highlight },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = '<c-space>',
				node_incremental = '<c-space>',
				scope_incremental = '<c-s>',
				node_decremental = '<M-space>',
			},
		},
		textobjects = {
			select = {
				enable = false,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					['aa'] = '@parameter.outer',
					['ia'] = '@parameter.inner',
					['af'] = '@function.outer',
					['if'] = '@function.inner',
					['ac'] = '@class.outer',
					['ic'] = '@class.inner',
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					[']m'] = '@function.outer',
					[']]'] = '@class.outer',
				},
				goto_next_end = {
					[']M'] = '@function.outer',
					[']['] = '@class.outer',
				},
				goto_previous_start = {
					['[m'] = '@function.outer',
					['[['] = '@class.outer',
				},
				goto_previous_end = {
					['[M'] = '@function.outer',
					['[]'] = '@class.outer',
				},
			},
			swap = {
				enable = true,
				swap_next = {
					['<leader>a'] = '@parameter.inner',
				},
				swap_previous = {
					['<leader>A'] = '@parameter.inner',
				},
			},
		},
	}

	vim.treesitter.language.register('markdown', 'mdx')
end)
