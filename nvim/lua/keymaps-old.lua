vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move code blocks
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- virtual select movement
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Center cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Improve copy, cut, paste
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

-- Increment/decrement
vim.keymap.set("n", "+", "<C-a>")
vim.keymap.set("n", "-", "<C-x>")

-- Move around splits using Ctrl + {h,j,k,l}
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Fast saving and quit
vim.keymap.set("n", "<M-w>", ":w<CR>")
vim.keymap.set("i", "<M-w>", "<C-c>:w<CR>")
vim.keymap.set("n", "<M-q>", ":q<CR>")

-- Resize splits with arrow keys
vim.keymap.set("n", "<up>", ":resize +5<CR>", { desc = "Resize +5" })
vim.keymap.set("n", "<down>", ":resize -5<CR>", { desc = "Resize -5" })
vim.keymap.set("n", "<left>", ":vertical resize -5<CR>", { desc = "Vertical Resize -5" })
vim.keymap.set("n", "<right>", ":vertical resize +5<CR>", { desc = "Vertical Resize +5" })

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

-- Change split orientation
-- vim.keymap.set('n', '<leader>tk', '<C-w>t<C-w>K') -- change vertical to horizontal
-- vim.keymap.set('n', '<leader>th', '<C-w>t<C-w>H') -- change horizontal to vertical

-- Quickfix mappings
vim.keymap.set('n', '<leader>ck', ':cexpr []<cr>', { desc = 'Quickfix: Clear list' })
vim.keymap.set('n', '<leader>cc', ':cclose <cr>', { desc = 'Quickfix: Close list' })
vim.keymap.set('n', '<leader>co', ':copen <cr>', { desc = 'Quickfix: Open list' })
vim.keymap.set('n', '<leader>cf', ':cfdo %s/', { desc = 'Quickfix: Search & Replace' })
vim.keymap.set('n', '<leader>cp', ':cprev<cr>zz', { desc = 'Quickfix: Prev Item' })
vim.keymap.set('n', '<leader>cn', ':cnext<cr>zz', { desc = 'Quickfix: Next Item' })


-- buffer navigation
vim.keymap.set('n', '<leader>kp', ':bprev<cr>', { desc = 'Buffer: Prev buffer' })
vim.keymap.set('n', '<leader>kn', ':bnext<cr>', { desc = 'Buffer: Next buffer' })
vim.keymap.set('n', '<leader>kd', ':bdelete<cr>', { desc = 'Buffer: Delete buffer' })
vim.keymap.set('n', '<leader>ko', '<cmd>%bd|e#<cr>', { desc = 'Buffer: Close all buffers but the current one' }) -- https://stackoverflow.com/a/42071865/516188
