-- ~/.config/nvim/lua/plugins/dap.lua
-- nvim-dap configuration from reference repo

local ok_dap, dap = pcall(require, 'dap')
if not ok_dap then return end
local ok_dapui, dapui = pcall(require, 'dapui')
if not ok_dapui then return end

dapui.setup()

dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
