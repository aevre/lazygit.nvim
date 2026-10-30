local M = {}

---@type string?
local config_dir

---@param opts lazygit.Config
function M.setup(opts)
	if config_dir then
		return
	end

	local output = vim.fn.system({ "lazygit", "-cd" })
	local lines = vim.split(output, "\n", { plain = true })
	if vim.v.shell_error ~= 0 or #lines <= 1 then
		local message = {
			"Failed to get **lazygit** config directory.",
			"Will not apply **lazygit** config.",
			"",
			"# Error:",
			vim.trim(output),
		}
		vim.notify(table.concat(message, "\n"), vim.log.levels.ERROR, { title = "lazygit" })
		return
	end

	config_dir = lines[1]
	local config_files = vim.tbl_filter(function(value)
		return value:match("%S") ~= nil
	end, vim.split(vim.env.LG_CONFIG_FILE or "", ",", { plain = true }))

	if #config_files == 0 then
		local default_config = vim.fs.normalize(config_dir .. "/config.yml")
		if vim.uv.fs_stat(default_config) then
			config_files[1] = default_config
		end
	end
	if not vim.tbl_contains(config_files, opts.theme_path) then
		config_files[#config_files + 1] = opts.theme_path
	end
	vim.env.LG_CONFIG_FILE = table.concat(config_files, ",")
end

return M
