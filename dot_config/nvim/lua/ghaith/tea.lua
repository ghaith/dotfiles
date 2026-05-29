-- Thin wrapper around the `tea` CLI for Gitea PR review.
-- Headline use case: "I know PR #N, check it out and start reviewing."
-- Pairs with diffview.nvim for the actual reading.
-- Assumes `tea login add` has already been done; surfaces errors verbatim if not.

local M = {}

local function tea_available()
  if vim.fn.executable('tea') == 1 then return true end
  vim.notify('tea CLI not installed', vim.log.levels.ERROR)
  return false
end

local function notify_err(stderr, fallback)
  local raw = (stderr and stderr ~= '') and stderr or (fallback or 'tea command failed')
  local msg = raw
  if raw:lower():match('cannot open tty') or raw:lower():match('open /dev/tty') then
    msg = 'tea needs interactive input (likely SSH passphrase). '
       .. 'Load your key with `ssh-add`, set up agent forwarding for tmux, '
       .. 'or switch tea to an HTTPS+token login. Raw: ' .. raw
  end
  vim.notify(msg, vim.log.levels.ERROR)
end

local function extract_ref_name(node)
  if type(node) == 'string' then return node end
  if type(node) == 'table' then
    return node.ref or node.label or node.name
  end
  return nil
end

local function ensure_branch(id, head_ref)
  vim.fn.system({ 'git', 'symbolic-ref', '-q', 'HEAD' })
  if vim.v.shell_error == 0 then return end

  local name
  if head_ref and head_ref ~= '' then
    vim.fn.system({ 'git', 'rev-parse', '--verify', 'refs/heads/' .. head_ref })
    if vim.v.shell_error ~= 0 then
      name = head_ref
    end
  end
  name = name or ('pr-' .. id)
  name = name:gsub('[^%w%-_/.]', '-')

  vim.fn.system({ 'git', 'switch', '-C', name })
  if vim.v.shell_error ~= 0 then
    vim.notify('could not create branch for PR #' .. id .. ' (still detached)', vim.log.levels.WARN)
  end
end

local function fallback_base()
  local short = vim.fn.systemlist({ 'git', 'symbolic-ref', '--short', 'refs/remotes/origin/HEAD' })
  if vim.v.shell_error == 0 and short[1] and short[1] ~= '' then
    return (short[1]:gsub('^origin/', ''))
  end
  for _, candidate in ipairs({ 'main', 'master' }) do
    vim.fn.system({ 'git', 'rev-parse', '--verify', 'refs/remotes/origin/' .. candidate })
    if vim.v.shell_error == 0 then return candidate end
  end
  return nil
end

local function open_diffview(base)
  base = base or fallback_base()
  if not base then
    vim.notify("couldn't determine base branch; run :DiffviewOpen manually", vim.log.levels.WARN)
    return
  end
  vim.cmd(string.format('DiffviewOpen origin/%s...HEAD', base))
end

local function resolve_pr_meta(id, cb)
  vim.system({ 'tea', 'pr', 'show', tostring(id), '--output', 'json' }, { text = true }, function(res)
    local meta = { base = nil, head = nil }
    if res.code == 0 then
      local ok, data = pcall(vim.json.decode, res.stdout or '')
      if ok and type(data) == 'table' then
        meta.base = extract_ref_name(data.base)
        meta.head = extract_ref_name(data.head)
      end
    end
    vim.schedule(function() cb(meta) end)
  end)
end

local function do_checkout(id, base, head)
  vim.notify(string.format('checking out PR #%d…', id), vim.log.levels.INFO)
  vim.system({ 'tea', 'pr', 'checkout', tostring(id) }, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        notify_err(res.stderr, 'tea pr checkout failed')
        return
      end
      ensure_branch(id, head)
      vim.notify(string.format('checked out PR #%d', id), vim.log.levels.INFO)
      vim.cmd('checktime')
      open_diffview(base)
    end)
  end)
end

function M.checkout(id_or_nil)
  if not tea_available() then return end
  local function go(id_str)
    if not id_str or id_str == '' then return end
    local id = tonumber(id_str)
    if not id then
      vim.notify('PR number must be numeric', vim.log.levels.ERROR)
      return
    end
    resolve_pr_meta(id, function(meta)
      do_checkout(id, meta.base, meta.head)
    end)
  end
  if id_or_nil then
    go(tostring(id_or_nil))
  else
    vim.ui.input({ prompt = 'PR #: ' }, go)
  end
end

local function open_picker(prs)
  local ok_t, pickers = pcall(require, 'telescope.pickers')
  if not ok_t then
    vim.notify('telescope.nvim not available', vim.log.levels.ERROR)
    return
  end
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  pickers.new({}, {
    prompt_title = 'Gitea PRs',
    finder = finders.new_table {
      results = prs,
      entry_maker = function(pr)
        local id = pr.index or pr.number or pr.id or 0
        local state = pr.state or '?'
        local title = pr.title or '(no title)'
        local author = (pr.poster and pr.poster.login) or (pr.user and pr.user.login) or '?'
        local display = string.format('#%d  [%s]  %s  (@%s)', id, state, title, author)
        return {
          value = pr,
          display = display,
          ordinal = display,
          pr_id = id,
          pr_base = extract_ref_name(pr.base),
          pr_head = extract_ref_name(pr.head),
        }
      end,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if not entry then return end
        do_checkout(entry.pr_id, entry.pr_base, entry.pr_head)
      end)
      return true
    end,
  }):find()
end

function M.list()
  if not tea_available() then return end
  vim.notify('loading PRs…', vim.log.levels.INFO)
  vim.system({ 'tea', 'pr', 'list', '--output', 'json' }, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        notify_err(res.stderr, 'tea pr list failed')
        return
      end
      local ok, prs = pcall(vim.json.decode, res.stdout or '')
      if not ok or type(prs) ~= 'table' then
        vim.notify('failed to parse tea pr list output', vim.log.levels.ERROR)
        return
      end
      open_picker(prs)
    end)
  end)
end

function M.setup()
  vim.api.nvim_create_user_command('TeaCheckout', function(opts)
    M.checkout(opts.args ~= '' and opts.args or nil)
  end, { nargs = '?', desc = 'Check out a Gitea PR via tea CLI' })

  vim.api.nvim_create_user_command('TeaList', function()
    M.list()
  end, { desc = 'Browse open Gitea PRs (telescope)' })

  vim.keymap.set('n', '<leader>gtc', function() M.checkout() end, { desc = 'Tea: checkout PR' })
  vim.keymap.set('n', '<leader>gtl', function() M.list() end,     { desc = 'Tea: list PRs (telescope)' })
end

return M
-- vim: ts=2 sts=2 sw=2 et
