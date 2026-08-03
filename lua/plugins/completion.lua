local ok, blink = pcall(require, "blink.cmp")
if not ok then
	return
end

blink.setup({
	keymap = {
		preset = "enter",
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 300 },
		ghost_text = { enabled = false },
	},
	signature = { enabled = true },
	sources = { default = { "lsp", "path", "snippets", "buffer" } },
	fuzzy = { implementation = "lua" },
})
