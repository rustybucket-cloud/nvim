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
    {
      '<leader>ha',
      function()
        require('harpoon'):list():add()
      end,
      desc = 'Harpoon [A]dd File',
    },
    {
      '<leader>hm',
      function()
        local harpoon = require 'harpoon'
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = 'Harpoon [M]enu',
    },
    {
      '<leader>h1',
      function()
        require('harpoon'):list():select(1)
      end,
      desc = 'Harpoon to File 1',
    },
    {
      '<leader>h2',
      function()
        require('harpoon'):list():select(2)
      end,
      desc = 'Harpoon to File 2',
    },
    {
      '<leader>h3',
      function()
        require('harpoon'):list():select(3)
      end,
      desc = 'Harpoon to File 3',
    },
    {
      '<leader>h4',
      function()
        require('harpoon'):list():select(4)
      end,
      desc = 'Harpoon to File 4',
    },
    {
      '<leader>hn',
      function()
        require('harpoon'):list():next()
      end,
      desc = 'Harpoon [N]ext',
    },
    {
      '<leader>hp',
      function()
        require('harpoon'):list():prev()
      end,
      desc = 'Harpoon [P]rev',
    },
  },
}
