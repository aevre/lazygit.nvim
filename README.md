# lazygit.nvim

A standalone LazyGit integration for Neovim, built on [terminal.nvim](https://codeberg.org/aevre/terminal.nvim).

## Installation

```lua
{
  "https://codeberg.org/aevre/lazygit.nvim",
  dependencies = {
    "https://codeberg.org/aevre/terminal.nvim",
    "https://codeberg.org/aevre/win.nvim",
  },
}
```

## Usage

```lua
local lazygit = require("lazygit")
lazygit.open()
lazygit.log()
lazygit.log_file()
```

Configure defaults with `require("lazygit").setup(opts)`. The integration writes a temporary LazyGit theme based on the current Neovim colorscheme and configures Neovim remote editing.
