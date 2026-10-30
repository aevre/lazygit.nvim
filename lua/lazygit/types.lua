---@alias lazygit.Color {fg?: string, bg?: string, bold?: boolean}

---@class lazygit.Theme: table<number|string, lazygit.Color>
---@field activeBorderColor lazygit.Color
---@field cherryPickedCommitBgColor lazygit.Color
---@field cherryPickedCommitFgColor lazygit.Color
---@field defaultFgColor lazygit.Color
---@field inactiveBorderColor lazygit.Color
---@field optionsTextColor lazygit.Color
---@field searchingActiveBorderColor lazygit.Color
---@field selectedLineBgColor lazygit.Color
---@field unstagedChangesColor lazygit.Color

---@class lazygit.Config: terminal.Opts
---@field args? string[] Additional LazyGit command arguments.
---@field configure? boolean Configure LazyGit and generate its theme.
---@field config? table<string, any> Extra LazyGit YAML values.
---@field theme? lazygit.Theme Theme fields mapped to highlight groups or terminal colors.
---@field theme_path? string Generated theme file path.

---@class lazygit.Api
---@overload fun(opts?: lazygit.Config): terminal?
---@field setup fun(opts?: lazygit.Config): lazygit.Api
---@field open fun(opts?: lazygit.Config): terminal?
---@field log fun(opts?: lazygit.Config): terminal?
---@field log_file fun(opts?: lazygit.Config): terminal?
