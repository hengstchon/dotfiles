vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { desc = "Leader: disable bare space", silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Move: up by visual line", expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Move: down by visual line", expr = true, silent = true })

-- Move code blocks
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Selection: move down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Selection: move up" })

-- virtual select movement
vim.keymap.set("v", "<", "<gv", { desc = "Selection: indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Selection: indent right" })

-- Center cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll: half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll: half page up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Search: next result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Search: previous result and center" })

-- Improve copy, cut, paste
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste: replace without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete: without yanking" })

-- Increment/decrement
vim.keymap.set("n", "+", "<C-a>", { desc = "Number: increment" })
vim.keymap.set("n", "-", "<C-x>", { desc = "Number: decrement" })

-- Move around splits using Ctrl + {h,j,k,l}
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window: focus left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window: focus down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window: focus up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window: focus right" })

-- Fast saving and quit
vim.keymap.set("n", "<M-w>", "<cmd>w<CR>", { desc = "File: save" })
vim.keymap.set("i", "<M-w>", "<C-c><cmd>w<CR>", { desc = "File: save from insert mode" })
vim.keymap.set("n", "<M-q>", "<cmd>q<CR>", { desc = "Window: quit" })

-- Resize splits with arrow keys
vim.keymap.set("n", "<up>", "<cmd>resize +5<CR>", { desc = "Window: increase height" })
vim.keymap.set("n", "<down>", "<cmd>resize -5<CR>", { desc = "Window: decrease height" })
vim.keymap.set("n", "<left>", "<cmd>vertical resize -5<CR>", { desc = "Window: decrease width" })
vim.keymap.set("n", "<right>", "<cmd>vertical resize +5<CR>", { desc = "Window: increase width" })

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Search: clear highlight", noremap = true, silent = true })

-- Quickfix mappings
vim.keymap.set("n", "<leader>qx", "<cmd>cexpr []<CR>", { desc = "Quickfix: clear list" })
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Quickfix: close list" })
vim.keymap.set("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Quickfix: open list" })
vim.keymap.set("n", "<leader>qr", ":cfdo %s/", { desc = "Quickfix: replace in list" })
vim.keymap.set("n", "<leader>qp", "<cmd>cprev<CR>zz", { desc = "Quickfix: previous item" })
vim.keymap.set("n", "<leader>qn", "<cmd>cnext<CR>zz", { desc = "Quickfix: next item" })

-- buffer navigation
vim.keymap.set("n", "<leader>bp", "<cmd>bprev<CR>", { desc = "Buffer: previous" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Buffer: next" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Buffer: delete" })
vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#<CR>", { desc = "Buffer: delete others" }) -- https://stackoverflow.com/a/42071865/516188
