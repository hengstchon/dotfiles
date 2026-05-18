local M = {}

local function file_exists(path)
  return path and vim.uv.fs_stat(path) ~= nil
end

local function read_file(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then return nil end
  return table.concat(lines, "\n")
end

local function sibling(path, extension)
  return path:gsub("%.[^.]+$", extension)
end

local function resolve_relative(base_dir, target)
  if target:sub(1, 1) == "/" then return target end
  return vim.fs.normalize(vim.fs.joinpath(base_dir, target))
end

local function template_from_component(component_path)
  local content = read_file(component_path)
  if not content then return nil end

  local template_url = content:match("templateUrl%s*:%s*['\"]([^'\"]+)['\"]")
  if template_url then
    local template_path = resolve_relative(vim.fs.dirname(component_path), template_url)
    if file_exists(template_path) then return template_path end
  end

  local convention_path = sibling(component_path, ".html")
  if file_exists(convention_path) then return convention_path end

  return nil
end

local function component_from_template(template_path)
  local convention_path = sibling(template_path, ".ts")
  if file_exists(convention_path) then return convention_path end

  local template_name = vim.fs.basename(template_path)
  local dir = vim.fs.dirname(template_path)
  local candidates = vim.fn.globpath(dir, "*.ts", false, true)

  for _, candidate in ipairs(candidates) do
    if not candidate:match("%.spec%.ts$") then
      local content = read_file(candidate)
      local template_url = content and content:match("templateUrl%s*:%s*['\"]([^'\"]+)['\"]")
      if template_url and vim.fs.basename(template_url) == template_name then return candidate end
    end
  end

  return nil
end

function M.alternate()
  local current = vim.api.nvim_buf_get_name(0)
  if current == "" then
    vim.notify("Angular: current buffer has no file name", vim.log.levels.WARN)
    return
  end

  local target
  if current:match("%.html$") then
    target = component_from_template(current)
  elseif current:match("%.ts$") and not current:match("%.spec%.ts$") then
    target = template_from_component(current)
  end

  if not target then
    vim.notify("Angular: no alternate component file found", vim.log.levels.WARN)
    return
  end

  vim.cmd.edit(vim.fn.fnameescape(target))
end

local function is_angular_component_file(path)
  return path:match("%.component%.ts$") or path:match("%.component%.html$")
end

function M.setup_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(bufnr)
  if not is_angular_component_file(path) then return end

  vim.api.nvim_buf_create_user_command(bufnr, "AngularAlternate", M.alternate, {
    desc = "Switch between an Angular component and its template",
  })

  vim.keymap.set("n", "<leader>aa", M.alternate, {
    buffer = bufnr,
    desc = "Angular: alternate component file",
  })
end

return M
