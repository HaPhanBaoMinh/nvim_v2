local ok, fzf = pcall(require, "fzf-lua")
if not ok then
	return
end

fzf.setup({
	"default-title",
	fzf_bin = vim.fn.stdpath("data") .. "/plugged/fzf/bin/fzf",
	fzf_opts = { ["--layout"] = "reverse-list" },
	files = { git_icons = false, file_icons = false },
	grep = { git_icons = false, file_icons = false },
	winopts = { height = 0.85, width = 0.88, preview = { layout = "vertical" } },
})

fzf.register_ui_select()
