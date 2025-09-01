return {
  'github/copilot.vim',
  config = function()
    -- Disable default ghost text (since we're using cmp integration)
    -- vim.g.copilot_no_tab_map = true
    -- vim.g.copilot_assume_mapped = true
    --
    -- -- Optional: Disable Copilot by default, enable on-demand
    -- -- vim.g.copilot_enabled = false
    --
    -- -- Keymaps for manual control
    -- vim.keymap.set('n', '<leader>ce', '<cmd>Copilot enable<CR>', { desc = 'Enable Copilot' })
    -- vim.keymap.set('n', '<leader>cd', '<cmd>Copilot disable<CR>', { desc = 'Disable Copilot' })
    -- vim.keymap.set('n', '<leader>cs', '<cmd>Copilot status<CR>', { desc = 'Copilot Status' })
    --
    -- -- Toggle Copilot on/off
    -- vim.keymap.set('n', '<leader>ct', function()
    --   if vim.g.copilot_enabled == false then
    --     vim.cmd('Copilot enable')
    --     print('Copilot enabled')
    --   else
    --     vim.cmd('Copilot disable')
    --     print('Copilot disabled')
    --   end
    -- end, { desc = 'Toggle Copilot' })
  end,
}
