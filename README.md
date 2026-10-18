# lazygit.nvim

A standalone LazyGit integration for Neovim, built on [terminal.nvim](https://codeberg.org/aevre/terminal.nvim).

[简体中文](README.zh-CN.md)

## Requirements

- Neovim 0.10 or newer.
- [LazyGit](https://github.com/jesseduffield/lazygit) installed and available in `$PATH`.
- [terminal.nvim](https://codeberg.org/aevre/terminal.nvim), which provides [win.nvim](https://codeberg.org/aevre/win.nvim).

## Installation

The canonical repository is hosted on Codeberg: <https://codeberg.org/aevre/lazygit.nvim>.

With lazy.nvim:

```lua
{
  "https://codeberg.org/aevre/lazygit.nvim",
  dependencies = {
    "https://codeberg.org/aevre/terminal.nvim",
  },
  opts = {},
}
```

The dependency chain is intentionally explicit:

```text
lazygit.nvim -> terminal.nvim -> win.nvim
```

## Usage

```lua
local lazygit = require("lazygit")

lazygit.open()
lazygit.log()
lazygit.log_file()
```

The module is callable, so `lazygit(opts)` is equivalent to `lazygit.open(opts)`.

## Configuration

`setup()` defines defaults. Per-call options override them.

```lua
require("lazygit").setup({
  args = { "--use-config-file", "~/.config/lazygit/config.yml" },
  configure = true,
  win = {
    position = "float",
    border = "rounded",
  },
})
```

Important options include:

| Option | Description |
| --- | --- |
| `args` | Additional arguments passed to LazyGit. |
| `configure` | Configure LazyGit remote editing and the generated theme. Defaults to `true`. |
| `config` | Extra LazyGit YAML values merged into the generated configuration. |
| `theme` | Mapping of LazyGit theme fields to Neovim highlight groups or colors. |
| `theme_path` | Generated theme file path. Defaults to Neovim's cache directory. |
| `win` | `terminal.nvim` and `win.nvim` options for the LazyGit terminal. |

The integration regenerates its theme after `ColorScheme` and `ThemeApply` events. It preserves existing LazyGit config files through `LG_CONFIG_FILE` and adds the generated theme file.

## API

```lua
local lazygit = require("lazygit")

lazygit.setup(opts?)
lazygit.open(opts?)
lazygit.log(opts?)
lazygit.log_file(opts?)
```

- `open()` starts LazyGit in a terminal window.
- `log()` opens the repository log view.
- `log_file()` opens the log for the current file and uses its directory as the working directory.
