local failures = {}

-- `nvim -l` starts in Lua-script mode without sourcing init.lua.
if vim.fn.exists(":PlugInstall") ~= 2 then
	dofile(vim.fn.stdpath("config") .. "/init.lua")
end

local function check(name, condition)
	if condition then
		print("PASS " .. name)
	else
		print("FAIL " .. name)
		table.insert(failures, name)
	end
end

for _, module in ipairs({
	"blink.cmp",
	"conform",
	"fzf-lua",
	"gitsigns",
	"mason",
	"mason-lspconfig",
	"mini.comment",
	"mini.pairs",
	"mini.surround",
	"nvim-tree",
	"nvim-treesitter",
	"toggleterm",
	"tokyonight",
	"which-key",
}) do
	check("module " .. module, pcall(require, module))
end

for _, command in ipairs({
	"ConformInfo",
	"FzfLua",
	"Gitsigns",
	"Mason",
	"NvimTreeToggle",
	"ToggleTerm",
}) do
	check("command :" .. command, vim.fn.exists(":" .. command) == 2)
end

for _, mapping in ipairs({ "<leader>ff", "<leader>fg", "<leader>e", "<leader>bd", "<C-t>" }) do
	check("mapping " .. mapping, vim.fn.maparg(mapping, "n") ~= "")
end

for _, tool in ipairs({ "stylua", "shfmt", "taplo" }) do
	check("tool " .. tool, vim.fn.executable(tool) == 1)
end

check("fzf binary", vim.fn.executable(vim.fn.stdpath("data") .. "/plugged/fzf/bin/fzf") == 1)

if #failures > 0 then
	error(table.concat(failures, ", "))
end
print("All core checks passed.")
