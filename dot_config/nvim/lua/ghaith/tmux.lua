local M = {}

M.work_window_name = 'work'

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO)
end

local function has_tmux()
  return vim.fn.executable('tmux') == 1 and vim.env.TMUX and vim.env.TMUX ~= ''
end

local function cwd()
  return vim.fn.getcwd()
end

local function current_file()
  local path = vim.fn.expand '%:p'
  if path == '' then
    return nil
  end
  return path
end

local function shellescape(value)
  return vim.fn.shellescape(value)
end

local function tmux_capture(args)
  local result = vim.system(vim.list_extend({ 'tmux' }, args), { text = true }):wait()
  if result.code ~= 0 then
    return nil, (result.stderr or result.stdout or ''):gsub('%s+$', '')
  end
  return (result.stdout or ''):gsub('%s+$', '')
end

local function tmux_run(args)
  local result = vim.system(vim.list_extend({ 'tmux' }, args), { text = true }):wait()
  if result.code ~= 0 then
    notify((result.stderr or result.stdout or 'tmux command failed'):gsub('%s+$', ''), vim.log.levels.WARN)
    return false
  end
  return true
end

local function ensure_tmux()
  if has_tmux() then
    return true
  end
  notify('tmux not available in this Neovim session', vim.log.levels.WARN)
  return false
end

local function current_session()
  return tmux_capture { 'display-message', '-p', '#S' }
end

local function work_target()
  local session = current_session()
  if not session then
    return nil
  end
  return string.format('%s:%s', session, M.work_window_name)
end

local function work_window_exists()
  local target = work_target()
  if not target then
    return false
  end
  local result = vim.system({ 'tmux', 'has-session', '-t', target }, { text = true }):wait()
  return result.code == 0
end

local function ensure_work_window()
  if not ensure_tmux() then
    return false
  end
  if work_window_exists() then
    return true
  end
  return tmux_run { 'new-window', '-d', '-n', M.work_window_name, '-c', cwd() }
end

function M.focus_work_window()
  if not ensure_work_window() then
    return
  end
  tmux_run { 'select-window', '-t', work_target() }
end

function M.open_editor_in_current_window(direction, path)
  if not ensure_tmux() then
    return false
  end
  local file = path or current_file()
  local command = file and ('nvim ' .. shellescape(file)) or 'nvim'
  local split_flag = direction == 'horizontal' and '-v' or '-h'
  return tmux_run { 'split-window', split_flag, '-c', cwd(), command }
end

function M.run_command_in_work_window(command)
  if not ensure_work_window() then
    return false
  end
  local target = work_target()
  tmux_run { 'split-window', '-v', '-t', target, '-c', cwd(), command }
  tmux_run { 'select-window', '-t', target }
  return true
end

function M.open_editor_in_current_context(direction, path)
  return M.open_editor_in_current_window(direction, path)
end

function M.run_command_in_current_context(command)
  if not ensure_tmux() then
    return false
  end
  return tmux_run { 'split-window', '-v', '-c', cwd(), command }
end

function M.open_popup(command)
  if not ensure_tmux() then
    return false
  end
  local popup_command = command or os.getenv('SHELL') or 'sh'
  return tmux_run {
    'display-popup',
    '-w',
    '80%',
    '-h',
    '80%',
    '-d',
    cwd(),
    '-E',
    popup_command,
  }
end

function M.prompt_and_run_in_work_window()
  vim.ui.input({ prompt = 'Work window command: ' }, function(input)
    if input and input ~= '' then
      M.run_command_in_work_window(input)
    end
  end)
end

function M.prompt_and_run_in_current_context()
  vim.ui.input({ prompt = 'Current tmux context command: ' }, function(input)
    if input and input ~= '' then
      M.run_command_in_current_context(input)
    end
  end)
end

function M.pick_ref(callback)
  vim.ui.input({ prompt = 'Git ref/branch: ' }, function(input)
    if input and input ~= '' then
      callback(input)
    end
  end)
end

function M.git_base_ref()
  local result = vim.system({ 'git', 'rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{upstream}' }, { text = true }):wait()
  if result.code == 0 then
    return (result.stdout or ''):gsub('%s+$', '')
  end

  local origin_head = vim.system({ 'git', 'symbolic-ref', 'refs/remotes/origin/HEAD' }, { text = true }):wait()
  if origin_head.code == 0 then
    return ((origin_head.stdout or ''):gsub('%s+$', ''))
  end

  for _, candidate in ipairs({ 'main', 'master' }) do
    local probe = vim.system({ 'git', 'rev-parse', '--verify', candidate }, { text = true }):wait()
    if probe.code == 0 then
      return candidate
    end
  end

  return 'HEAD~1'
end

return M
