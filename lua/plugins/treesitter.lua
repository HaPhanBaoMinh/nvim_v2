local ok, treesitter = pcall(require, "nvim-treesitter")
if not ok then
	return
end

treesitter.setup({})
vim.cmd("syntax enable")

local enabled = {
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

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TreesitterFeatures", { clear = true }),
	pattern = enabled,
	callback = function()
		pcall(vim.treesitter.start)
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})
