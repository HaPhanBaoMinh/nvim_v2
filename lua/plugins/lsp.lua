local ok_mason, mason = pcall(require, "mason")
local ok_bridge, mason_lspconfig = pcall(require, "mason-lspconfig")
if not (ok_mason and ok_bridge) then
	return
end

mason.setup({ ui = { border = "single" } })

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
	capabilities = blink.get_lsp_capabilities(capabilities)
end

local servers = {
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	},
	pyright = {},
	gopls = {},
	rust_analyzer = {},
	ts_ls = {},
	bashls = {},
	clangd = {},
	jsonls = {},
	yamlls = {},
	html = {},
	cssls = {},
	dockerls = {},
}

for name, config in pairs(servers) do
	config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
	vim.lsp.config(name, config)
end

mason_lspconfig.setup({
	automatic_enable = vim.tbl_keys(servers),
})

vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	underline = true,
	signs = true,
	virtual_text = { spacing = 2, prefix = "●" },
	float = { border = "rounded", source = true },
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
	callback = function(args)
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
		end
		map("n", "gd", vim.lsp.buf.definition, "Definition")
		map("n", "gD", vim.lsp.buf.declaration, "Declaration")
		map("n", "gr", "<cmd>FzfLua lsp_references<cr>", "References")
		map("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", "Implementations")
		map("n", "K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, "Hover documentation")
		map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
		map("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, "Previous diagnostic")
		map("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, "Next diagnostic")
	end,
})
