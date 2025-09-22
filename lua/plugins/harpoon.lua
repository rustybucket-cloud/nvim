-- Harpoon quick file navigation
-- https://github.com/ThePrimeagen/harpoon

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('harpoon'):setup()
  end,
  keys = {
    { '<leader>ma', function() require('harpoon'):list():add() end, desc = 'Harpoon Add File' },
    { '<leader>mm', function() local harpoon = require('harpoon'); harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = 'Harpoon Menu' },
    { '<leader>m1', function() require('harpoon'):list():select(1) end, desc = 'Harpoon to File 1' },
    { '<leader>m2', function() require('harpoon'):list():select(2) end, desc = 'Harpoon to File 2' },
    { '<leader>m3', function() require('harpoon'):list():select(3) end, desc = 'Harpoon to File 3' },
    { '<leader>m4', function() require('harpoon'):list():select(4) end, desc = 'Harpoon to File 4' },
    { '<leader>mn', function() require('harpoon'):list():next() end, desc = 'Harpoon Next' },
    { '<leader>mp', function() require('harpoon'):list():prev() end, desc = 'Harpoon Prev' },
  },
}
