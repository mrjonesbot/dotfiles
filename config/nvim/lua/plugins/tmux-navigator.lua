-- Ctrl-h/j/k/l moves between nvim splits, and into the next tmux pane at the edge (pairs with ~/.tmux.conf)
return {
  'christoomey/vim-tmux-navigator',
  cmd = { 'TmuxNavigateLeft', 'TmuxNavigateDown', 'TmuxNavigateUp', 'TmuxNavigateRight' },
  keys = {
    { '<C-h>', '<cmd>TmuxNavigateLeft<cr>' },
    { '<C-j>', '<cmd>TmuxNavigateDown<cr>' },
    { '<C-k>', '<cmd>TmuxNavigateUp<cr>' },
    { '<C-l>', '<cmd>TmuxNavigateRight<cr>' },
  },
}
