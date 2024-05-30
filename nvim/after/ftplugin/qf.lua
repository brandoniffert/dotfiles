local keymap = require("bti.util").keymap

keymap("n", "o", "<cr><c-w>p", { buffer = true })
keymap("n", "<cr>", "<cr><c-w>p", { buffer = true })
