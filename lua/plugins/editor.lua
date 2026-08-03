for _, module in ipairs({ "pairs", "comment", "surround", "bufremove" }) do
	local ok, mini = pcall(require, "mini." .. module)
	if ok then
		mini.setup()
	end
end

local ok_git, gitsigns = pcall(require, "gitsigns")
if ok_git then
	gitsigns.setup({
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		current_line_blame = false,
		update_debounce = 200,
		max_file_length = 20000,
	})
end
