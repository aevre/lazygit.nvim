# lazygit.nvim

一个独立的 Neovim LazyGit 集成插件，基于 [terminal.nvim](https://codeberg.org/aevre/terminal.nvim) 构建。

[English](README.md)

## 环境要求

- Neovim 0.10 或更新版本。
- 已安装 [LazyGit](https://github.com/jesseduffield/lazygit)，并且命令位于 `$PATH` 中。
- [terminal.nvim](https://codeberg.org/aevre/terminal.nvim)，它会提供 [win.nvim](https://codeberg.org/aevre/win.nvim)。

## 安装

项目托管于 Codeberg：<https://codeberg.org/aevre/lazygit.nvim>。

使用 lazy.nvim：

```lua
{
  "https://codeberg.org/aevre/lazygit.nvim",
  dependencies = {
    "https://codeberg.org/aevre/terminal.nvim",
  },
  opts = {},
}
```

依赖链保持显式：

```text
lazygit.nvim -> terminal.nvim -> win.nvim
```

## 使用

```lua
local lazygit = require("lazygit")

lazygit.open()
lazygit.log()
lazygit.log_file()
```

模块可以直接调用，因此 `lazygit(opts)` 等价于 `lazygit.open(opts)`。

## 配置

使用 `setup()` 设置默认值。单次调用传入的选项会覆盖默认值。

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

常用选项包括：

| 选项 | 说明 |
| --- | --- |
| `args` | 传给 LazyGit 的额外参数。 |
| `configure` | 配置 LazyGit 远程编辑并生成主题，默认为 `true`。 |
| `config` | 与生成配置合并的额外 LazyGit YAML 值。 |
| `theme` | 将 LazyGit 主题字段映射到 Neovim 高亮组或颜色。 |
| `theme_path` | 生成主题文件的路径，默认为 Neovim cache 目录。 |
| `win` | LazyGit 终端使用的 `terminal.nvim` 和 `win.nvim` 配置。 |

插件会在 `ColorScheme` 和 `ThemeApply` 事件后重新生成主题，并通过 `LG_CONFIG_FILE` 保留已有 LazyGit 配置文件，同时加入生成的主题文件。

## API

```lua
local lazygit = require("lazygit")

lazygit.setup(opts?)
lazygit.open(opts?)
lazygit.log(opts?)
lazygit.log_file(opts?)
```

- `open()` 在终端窗口中启动 LazyGit。
- `log()` 打开仓库日志视图。
- `log_file()` 打开当前文件的日志，并将文件所在目录作为工作目录。
