return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup({
      defaults = {
        vimgrep_arguments = {
          'ag',
          '--nocolor',
          '--noheading',
          '--numbers',
          '--column',
          '--smart-case',
        },
      },
      pickers = {
        find_files = {
          find_command = { 'ag', '-l', '--nocolor', '-g', '' },
        },
      },
    })
  end
}
