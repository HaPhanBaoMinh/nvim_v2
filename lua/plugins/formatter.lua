local ok, conform = pcall(require, "conform")
if not ok then
	return
end

local function first_available(...)
	local available = {}
	for _, spec in ipairs({ ... }) do
		if vim.fn.executable(spec.command) == 1 then
			table.insert(available, spec.formatter)
		end
	end
	if #available == 0 then
		return nil
	end
	available.stop_after_first = true
	return available
end

local prettier = first_available(
	{ formatter = "prettierd", command = "prettierd" },
	{ formatter = "prettier", command = "prettier" }
)

conform.setup({
	formatters_by_ft = {
		lua = first_available({ formatter = "stylua", command = "stylua" }),
		python = first_available({ formatter = "ruff_format", command = "ruff" }),
		javascript = prettier,
		javascriptreact = prettier,
		typescript = prettier,
		typescriptreact = prettier,
		json = prettier,
		jsonc = prettier,
		yaml = prettier,
		markdown = prettier,
		html = prettier,
		css = prettier,
		sh = first_available({ formatter = "shfmt", command = "shfmt" }),
		bash = first_available({ formatter = "shfmt", command = "shfmt" }),
		go = first_available(
			{ formatter = "goimports", command = "goimports" },
			{ formatter = "gofmt", command = "gofmt" }
		),
		rust = first_available({ formatter = "rustfmt", command = "rustfmt" }),
		c = first_available({ formatter = "clang_format", command = "clang-format" }),
		cpp = first_available({ formatter = "clang_format", command = "clang-format" }),
		toml = first_available({ formatter = "taplo", command = "taplo" }),
	},
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 800, lsp_format = "fallback" }
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, { bang = true, desc = "Disable format-on-save (! = buffer only)" })

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, { desc = "Enable format-on-save" })

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	conform.format({ async = true, lsp_format = "fallback" })
end, { silent = true, desc = "Format" })
