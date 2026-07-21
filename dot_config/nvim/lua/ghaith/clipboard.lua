-- Smart clipboard provider
--
-- Copy priority:
--   1. tmux     → `tmux load-buffer -w` — tmux forwards the text via OSC 52
--                 to whichever client is attached *right now* (local terminal
--                 or Windows Terminal over SSH) and fills the tmux paste
--                 buffer. Env vars like WAYLAND_DISPLAY are snapshots from
--                 pane creation and lie after re-attaching from another
--                 machine, so they must not decide the backend inside tmux.
--   2. SSH      → OSC 52 via /dev/tty (local terminal must support it:
--                 kitty, wezterm, alacritty, foot, ghostty, WT ≥ 1.11 …)
--   3. Wayland  → wl-copy
--   4. X11      → xclip (or xsel)
--   5. macOS    → pbcopy
--   6. Fallback → OSC 52
--
-- Paste: a live local display wins (copy in browser → paste in vim); inside
-- tmux the paste buffer (= last copy) is the fallback. Reading the clipboard
-- of a remote SSH client is impossible — use the terminal's own paste
-- (right-click / Ctrl+V in Windows Terminal) for that.

local M = {}

--- Emit OSC 52 directly to the terminal tty.
local function osc52_copy(lines, _regtype)
  local text = table.concat(lines, '\n')
  -- base64-encode without newlines
  local encoded = vim.fn.system({ 'base64' }, text):gsub('\n', '')

  local seq
  if vim.env.TMUX then
    -- DCS passthrough: tmux forwards this to the outer terminal unchanged
    seq = '\027Ptmux;\027\027]52;c;' .. encoded .. '\a\027\\'
  else
    seq = '\027]52;c;' .. encoded .. '\a'
  end

  -- /dev/tty is the real terminal, regardless of redirections
  local tty = io.open('/dev/tty', 'w')
  if tty then
    tty:write(seq)
    tty:close()
  end
end

--- Copy via tmux: fills the tmux paste buffer, and -w forwards the text to
--- the attached client's terminal clipboard via OSC 52.
local function tmux_copy(lines, _regtype)
  vim.fn.system({ 'tmux', 'load-buffer', '-w', '-' }, table.concat(lines, '\n'))
end

--- Paste inside tmux: prefer a live local display, fall back to the tmux
--- paste buffer. Checked at call time, not setup time — the display can die
--- or the session can be re-attached from elsewhere while nvim keeps running.
local function tmux_paste()
  if vim.env.WAYLAND_DISPLAY and vim.fn.executable('wl-paste') == 1 then
    local out = vim.fn.systemlist({ 'wl-paste', '--no-newline' })
    if vim.v.shell_error == 0 then
      return out
    end
  end
  if vim.env.DISPLAY and vim.fn.executable('xclip') == 1 then
    local out = vim.fn.systemlist({ 'xclip', '-selection', 'clipboard', '-o' })
    if vim.v.shell_error == 0 then
      return out
    end
  end
  local out = vim.fn.systemlist({ 'tmux', 'save-buffer', '-' })
  if vim.v.shell_error == 0 then
    return out
  end
  return { '' }
end

function M.setup()
  -- ── tmux ──────────────────────────────────────────────────────────────────
  if vim.env.TMUX and vim.fn.executable('tmux') == 1 then
    vim.g.clipboard = {
      name  = 'tmux',
      copy  = { ['+'] = tmux_copy,  ['*'] = tmux_copy },
      paste = { ['+'] = tmux_paste, ['*'] = tmux_paste },
    }
    return
  end

  -- ── SSH (no tmux) ─────────────────────────────────────────────────────────
  if vim.env.SSH_TTY then
    vim.g.clipboard = {
      name  = 'OSC 52',
      copy  = { ['+'] = osc52_copy, ['*'] = osc52_copy },
      paste = { ['+'] = function() return { '' } end, ['*'] = function() return { '' } end },
    }
    return
  end

  -- ── Wayland ──────────────────────────────────────────────────────────────
  if vim.env.WAYLAND_DISPLAY and vim.fn.executable('wl-copy') == 1 then
    vim.g.clipboard = {
      name  = 'wl-clipboard',
      copy  = { ['+'] = { 'wl-copy' },                    ['*'] = { 'wl-copy', '--primary' } },
      paste = { ['+'] = { 'wl-paste', '--no-newline' },   ['*'] = { 'wl-paste', '--primary', '--no-newline' } },
    }
    return
  end

  -- ── X11 ──────────────────────────────────────────────────────────────────
  if vim.env.DISPLAY then
    if vim.fn.executable('xclip') == 1 then
      vim.g.clipboard = {
        name  = 'xclip',
        copy  = { ['+'] = { 'xclip', '-selection', 'clipboard' },   ['*'] = { 'xclip', '-selection', 'primary' } },
        paste = { ['+'] = { 'xclip', '-selection', 'clipboard', '-o' }, ['*'] = { 'xclip', '-selection', 'primary', '-o' } },
      }
      return
    end
    if vim.fn.executable('xsel') == 1 then
      vim.g.clipboard = {
        name  = 'xsel',
        copy  = { ['+'] = { 'xsel', '--clipboard', '--input' },  ['*'] = { 'xsel', '--primary', '--input' } },
        paste = { ['+'] = { 'xsel', '--clipboard', '--output' }, ['*'] = { 'xsel', '--primary', '--output' } },
      }
      return
    end
  end

  -- ── macOS ─────────────────────────────────────────────────────────────────
  if vim.fn.executable('pbcopy') == 1 then
    vim.g.clipboard = {
      name  = 'pbcopy',
      copy  = { ['+'] = { 'pbcopy' }, ['*'] = { 'pbcopy' } },
      paste = { ['+'] = { 'pbpaste' }, ['*'] = { 'pbpaste' } },
    }
    return
  end

  -- ── OSC 52 fallback (headless / unknown) ─────────────────────────────────
  vim.g.clipboard = {
    name  = 'OSC 52',
    copy  = { ['+'] = osc52_copy, ['*'] = osc52_copy },
    paste = { ['+'] = function() return { '' } end, ['*'] = function() return { '' } end },
  }
end

return M
