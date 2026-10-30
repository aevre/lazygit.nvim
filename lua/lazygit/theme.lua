local M = {}

local function tui_attached()
	if vim.fn.has("nvim-0.10") == 0 then
		return true
	end
	for _, ui in ipairs(vim.api.nvim_list_uis()) do
		if ui.chan == 1 and ui.stdout_tty then
			return true
		end
	end
	return false
end

---@param color lazygit.Color
---@return string[]
function M.resolve_color(color)
	local result = {}
	for _, key in ipairs({ "fg", "bg" }) do
		local name = color[key]
		if name then
			local highlight = vim.api.nvim_get_hl(0, { name = name, link = false })
			local value = key == "fg" and highlight.fg or highlight.bg
			if value then
				result[#result + 1] = string.format("#%06x", value)
			end
		end
	end
	if color.bold then
		result[#result + 1] = "bold"
	end
	return result
end

---@param value any
---@return string|any
local function yaml_value(value)
	if type(value) == "boolean" then
		return tostring(value)
	end
	return type(value) == "string" and not value:find("^[\"'`]") and ("%q"):format(value) or value
end

---@param values table<string, any>
---@param indent? integer
---@return string[]
local function to_yaml(values, indent)
	indent = indent or 0
	local lines = {}
	for key, value in pairs(values) do
		lines[#lines + 1] = string.rep(" ", indent)
			.. key
			.. (type(value) == "table" and ":" or ": " .. yaml_value(value))
		if type(value) == "table" then
			if vim.islist(value) then
				for _, item in ipairs(value) do
					lines[#lines + 1] = string.rep(" ", indent + 2) .. "- " .. yaml_value(item)
				end
			else
				vim.list_extend(lines, to_yaml(value, indent + 2))
			end
		end
	end
	return lines
end

---@param opts lazygit.Config
function M.write(opts)
	---@type table<string, any>
	local theme = {}
	for key, color in pairs(opts.theme or {}) do
		local resolved = M.resolve_color(color)
		if type(key) == "number" then
			if vim.api.nvim_ui_send then
				pcall(vim.api.nvim_ui_send, ("\27]4;%d;%s\7"):format(key, resolved[1]))
			elseif tui_attached() then
				pcall(io.write, ("\27]4;%d;%s\7"):format(key, resolved[1]))
			end
		else
			theme[key] = resolved
		end
	end

	local values = vim.tbl_deep_extend("force", { gui = { theme = theme } }, opts.config or {})
	vim.fn.writefile(to_yaml(values), opts.theme_path)
end

return M
