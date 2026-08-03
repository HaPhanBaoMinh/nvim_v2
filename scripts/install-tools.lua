local registry = require("mason-registry")

local packages = {
	{ name = "stylua" },
	{ name = "shfmt" },
	{ name = "taplo" },
	{ name = "tree-sitter-cli" },
	{ name = "lua-language-server" },
	{ name = "rust-analyzer" },
	{ name = "clangd" },
	{ name = "ruff" },
	{ name = "clang-format" },
	{ name = "prettier", requires = "npm" },
	{ name = "pyright", requires = "npm" },
	{ name = "typescript-language-server", requires = "npm" },
	{ name = "bash-language-server", requires = "npm" },
	{ name = "json-lsp", requires = "npm" },
	{ name = "yaml-language-server", requires = "npm" },
	{ name = "html-lsp", requires = "npm" },
	{ name = "css-lsp", requires = "npm" },
	{ name = "dockerfile-language-server", requires = "npm" },
	{ name = "gopls", requires = "go" },
	{ name = "goimports", requires = "go" },
}

local pending = 0
local failed = {}
local skipped = {}
local refreshed = false

registry.refresh(function()
	refreshed = true
	for _, spec in ipairs(packages) do
		if spec.requires and vim.fn.executable(spec.requires) == 0 then
			table.insert(skipped, spec.name .. " (needs " .. spec.requires .. ")")
		else
			local ok, package = pcall(registry.get_package, spec.name)
			if not ok then
				table.insert(failed, spec.name .. " (not in registry)")
			elseif not package:is_installed() then
				pending = pending + 1
				package:once("install:success", function()
					pending = pending - 1
				end)
				package:once("install:failed", function()
					pending = pending - 1
					table.insert(failed, spec.name)
				end)
				package:install()
			end
		end
	end
end)

vim.wait(30000, function()
	return refreshed
end, 100)
if pending > 0 then
	vim.wait(600000, function()
		return pending == 0
	end, 200)
end

if vim.fn.executable("cc") == 1 then
	local parsers = {
		"bash",
		"c",
		"cpp",
		"css",
		"dockerfile",
		"go",
		"html",
		"javascript",
		"json",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"query",
		"rust",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"vimdoc",
		"yaml",
	}
	local task = require("nvim-treesitter").install(parsers)
	if task and task.wait then
		task:wait(600000)
	end
else
	table.insert(skipped, "Treesitter parsers (needs a C compiler)")
end

if #skipped > 0 then
	print("Skipped: " .. table.concat(skipped, ", "))
end
if #failed > 0 then
	print("Optional packages that failed: " .. table.concat(failed, ", "))
end
