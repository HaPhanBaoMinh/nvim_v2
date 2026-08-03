local ok_theme, theme = pcall(require, "tokyonight")
if ok_theme then
	theme.setup({ style = "night", styles = { comments = { italic = true } } })
	vim.cmd.colorscheme("tokyonight")
end

local ok_tree, tree = pcall(require, "nvim-tree")
if ok_tree then
	tree.setup({
		sync_root_with_cwd = true,
		respect_buf_cwd = true,
		update_focused_file = { enable = true, update_root = false },
		view = { width = 28, side = "left" },
		renderer = {
			root_folder_label = false,
			indent_markers = { enable = true },
			icons = { show = { file = false, folder = false, git = true } },
		},
		diagnostics = { enable = false },
		git = { enable = true, ignore = true, timeout = 300 },
		actions = { open_file = { quit_on_open = false, resize_window = true } },
	})
end

local ok_wk, wk = pcall(require, "which-key")
if ok_wk then
	wk.setup({ delay = 250, preset = "classic" })
	wk.add({
		{ "<leader>b", group = "buffers" },
		{ "<leader>c", group = "code" },
		{ "<leader>f", group = "find" },
		{ "<leader>g", group = "git" },
		{ "<leader>s", group = "splits" },
		{ "<leader>t", group = "terminal" },
		{ "<leader>x", group = "diagnostics" },
	})
end
