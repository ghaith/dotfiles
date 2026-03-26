-- Smart clipboard provider
--
-- Priority:
--   1. Wayland  → wl-copy / wl-paste
--   2. X11      → xclip (or xsel)
--   3. macOS    → pbcopy / pbpaste
--   4. Fallback → OSC 52 via /dev/tty
--
-- The OSC 52 path works over SSH as long as your *local* terminal supports it
-- (kitty, wezterm, alacritty, foot, iTerm2 …).
--
-- How the SSH chain works:
--   nvim (remote) → /dev/tty → SSH → local tmux pane
--   tmux (set-clipboard on) intercepts the OSC 52 and forwards it to the
--   outer terminal, which puts the text in the local clipboard.
--
-- Note: `TMUX` env is usually NOT forwarded over SSH (by default sshd doesn't
-- export it), so the DCS passthrough wrapper is only added when nvim is running
-- *directly* inside a local tmux session — not when accessed via SSH.

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

function M.setup()
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

  -- ── OSC 52 fallback (SSH / headless) ─────────────────────────────────────
  -- Paste over SSH is not supported — the remote has no access to the local
  -- clipboard. Only copy works.
  vim.g.clipboard = {
    name  = 'OSC 52',
    copy  = { ['+'] = osc52_copy, ['*'] = osc52_copy },
    paste = { ['+'] = function() return { '' } end, ['*'] = function() return { '' } end },
  }
end

return M
