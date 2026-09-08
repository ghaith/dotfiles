local M = {}
local building = false

function M.build()
  if building then
    vim.notify('A .NET build is already running')
    return
  end
  if vim.fn.executable('dotnet') ~= 1 then
    vim.notify('dotnet is not available', vim.log.levels.ERROR)
    return
  end
  local root = vim.fs.root(vim.api.nvim_buf_get_name(0) ~= '' and vim.api.nvim_buf_get_name(0) or vim.fn.getcwd(), function(name)
    return name:match('%.csproj$') ~= nil or name:match('%.slnx?$') ~= nil
  end)
  if not root then
    vim.notify('No C# project or solution found above this file', vim.log.levels.ERROR)
    return
  end
  local saved, err = pcall(vim.cmd, 'wall')
  if not saved then
    vim.notify(tostring(err), vim.log.levels.ERROR)
    return
  end
  building = true
  vim.notify('Building .NET project: ' .. root)
  local ok, spawn_err = pcall(vim.system, { 'dotnet', 'build', '--nologo', '-consoleloggerparameters:NoSummary' }, {
    cwd = root,
    text = true,
  }, vim.schedule_wrap(function(result)
    building = false
    local lines = vim.split((result.stdout or '') .. '\n' .. (result.stderr or ''), '\n', { trimempty = true })
    local efm = '%E%f(%l\\,%c): error %m,%W%f(%l\\,%c): warning %m,%E%f : error %m,%W%f : warning %m,%-G%.%#'
    local items = vim.fn.getqflist({ lines = lines, efm = efm }).items
    for _, item in ipairs(items) do
      if item.bufnr > 0 then
        local name = vim.fn.bufname(item.bufnr)
        if name ~= '' and not vim.startswith(name, '/') then
          item.filename = vim.fs.joinpath(root, name)
          item.bufnr = nil
        end
      end
    end
    if result.code ~= 0 and #items == 0 then
      for _, line in ipairs(lines) do
        table.insert(items, { text = line })
      end
    end
    vim.fn.setqflist({}, ' ', { title = 'dotnet build: ' .. root, items = items })
    if result.code ~= 0 then
      vim.cmd('copen')
      vim.notify('.NET build failed; see quickfix', vim.log.levels.ERROR)
    else
      vim.notify('.NET build succeeded' .. (#items > 0 and '; see :copen for diagnostics' or ''))
    end
  end))
  if not ok then
    building = false
    vim.notify(tostring(spawn_err), vim.log.levels.ERROR)
  end
end

return M
