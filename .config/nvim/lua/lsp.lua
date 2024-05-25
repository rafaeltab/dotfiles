require "utils.on_attach"
require "utils.plugins"

Plugins:add({
    {
        "aznhe21/actions-preview.nvim"
    },
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            {
                'j-hui/fidget.nvim',
                opts = {},
                tag = "legacy",
            },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
    },
    { 'folke/neodev.nvim', opts = {} }
})

OnLoad:add(function()
    -- Diagnostic keymaps
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

    vim.diagnostic.config({
        underline = true
    })

    Languages:add_lspconfig(true, "svelte", {})
    Languages:add_lspconfig(true, "html", {})
    Languages:add_lspconfig(true, "gopls", {})
    Languages:add_lspconfig(true, "rust_analyzer", {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
        },
    })
    Languages:add_lspconfig(true, "bufls", {})
    Languages:add_lspconfig(true, "lua_ls", {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    })
    Languages:add_lspconfig(true, "vale_ls", {
        filetypes = { "markdown", "text" --[[ , "dart" ]] },
        -- filetypes = { "*" },
    })

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Setup mason so it can manage external tooling
    require('mason').setup({
        PATH = "prepend"
    })

    -- local lsp_util = require 'lspconfig.util'
    -- vim.lsp.start({
    --     cmd = { 'terramate-ls' },
    --     filetypes = { 'terramate' },
    --     name = 'terramate-ls',
    --     root_dir = lsp_util.root_pattern('terramate.tm.hcl', '.git'),
    -- })

    -- Ensure the servers above are installed
    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup {
        ensure_installed = Languages.mason,
    }

    local function setup_server(server_name)
        local server_config = Languages.lspconfig[server_name]
        if not server_config then
            return
        end

        local filetypes = server_config.filetypes
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = function(client, bufnr) OnAttach:attach(client, bufnr) end,
            settings = server_config,
            filetypes = filetypes
        }
    end

    for k in pairs(Languages.lspconfig) do
        setup_server(k)
    end
end)

OnAttach:add(function(_, bufnr)
    Nmap(bufnr, '<leader>ca', require("actions-preview").code_actions, '[C]ode [A]ction')

    Nmap(bufnr, 'K', vim.lsp.buf.hover, 'Hover')
    Nmap(bufnr, '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    Nmap(bufnr, 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
end)
