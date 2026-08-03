local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
	return
end

toggleterm.setup({
	size = 14,
	direction = "horizontal",
	shade_terminals = false,
	start_in_insert = true,
	persist_size = true,
	close_on_exit = true,
})
