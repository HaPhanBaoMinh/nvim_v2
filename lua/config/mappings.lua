local map = function(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Files and editing
map("n", "<leader>w", "<cmd>write<cr>", "Save file")
map("n", "<leader>q", "<cmd>quit<cr>", "Quit window")
map("n", "<leader>Q", "<cmd>qa!<cr>", "Quit all (force)")
map("n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", "Explorer")

-- Buffers
map("n", "]b", "<cmd>bnext<cr>", "Next buffer")
map("n", "[b", "<cmd>bprevious<cr>", "Previous buffer")
map("n", "<leader>bb", "<cmd>FzfLua buffers<cr>", "Choose buffer")
map("n", "<leader>bd", function()
	local ok, bufremove = pcall(require, "mini.bufremove")
	if ok then
		bufremove.delete(0, false)
	else
		vim.cmd.bdelete()
	end
end, "Delete buffer")

-- Windows
map("n", "<C-h>", "<C-w>h", "Window left")
map("n", "<C-j>", "<C-w>j", "Window down")
map("n", "<C-k>", "<C-w>k", "Window up")
map("n", "<C-l>", "<C-w>l", "Window right")
map("n", "<leader>sv", "<cmd>vsplit<cr>", "Vertical split")
map("n", "<leader>sh", "<cmd>split<cr>", "Horizontal split")
map("n", "<leader>sc", "<cmd>close<cr>", "Close split")
map("n", "<leader>se", "<C-w>=", "Equalize splits")
map("n", "<C-Up>", "<cmd>resize +2<cr>", "Grow height")
map("n", "<C-Down>", "<cmd>resize -2<cr>", "Shrink height")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "Shrink width")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "Grow width")

-- Search
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", "Find files")
map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", "Live grep")
map("n", "<leader>fw", "<cmd>FzfLua grep_cword<cr>", "Find word")
map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", "Recent files")
map("n", "<leader>fh", "<cmd>FzfLua helptags<cr>", "Help tags")

-- Git and diagnostics
map("n", "<leader>gs", "<cmd>FzfLua git_status<cr>", "Git status")
map("n", "<leader>gc", "<cmd>FzfLua git_commits<cr>", "Git commits")
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", "Git blame line")
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", "Git diff")
map("n", "<leader>xx", "<cmd>FzfLua diagnostics_workspace<cr>", "Workspace diagnostics")

-- Keep selected text when indenting and move lines cleanly.
map("v", "<", "<gv", "Indent left")
map("v", ">", ">gv", "Indent right")
map("v", "J", ":m '>+1<cr>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<cr>gv=gv", "Move selection up")

-- Terminal
map({ "n", "t" }, "<C-t>", "<cmd>ToggleTerm<cr>", "Toggle terminal")
map("n", "<leader>tt", "<cmd>ToggleTerm<cr>", "Toggle terminal")
map("t", "<Esc><Esc>", "<C-\\><C-n>", "Terminal normal mode")
