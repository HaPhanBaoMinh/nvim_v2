local modules = {
	"plugins.ui",
	"plugins.editor",
	"plugins.fzf-lua",
	"plugins.treesitter",
	"plugins.completion",
	"plugins.lsp",
	"plugins.formatter",
	"plugins.terminal",
}

for _, module in ipairs(modules) do
	local ok, err = pcall(require, module)
	if not ok then
		vim.schedule(function()
			vim.notify(("%s: %s"):format(module, err), vim.log.levels.WARN)
		end)
	end
end
