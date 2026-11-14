# SSH keys

Private keys never live on disk. They are in Proton Pass (loaded into the
agent) or on a YubiKey (FIDO2 `ed25519-sk`, the file on disk is only a handle).

```
Proton vault(s) ──► proton-ssh-load.service / ssh-unlock ─┐
YubiKeys ─────────► resident sk handles (ssh-add) ────────┤
                                                          ▼
every session ──► $XDG_RUNTIME_DIR/ssh-agent.socket (OpenSSH, key lifetime -t)
```

## Pieces

| Piece | Where |
|---|---|
| Agent | `~/.config/systemd/user/ssh-agent.service`; distro `ssh-agent.socket` and `gcr-ssh-agent` masked |
| Vaults per machine | chezmoi data `sshVaults` (prompted by `chezmoi init`); empty = no Proton parts |
| Auto-load at login | `proton-ssh-load.service` (skips when pass-cli is locked or logged out) |
| Manual load | `ssh-unlock` (unlocks or logs in to pass-cli if needed); keys stay loaded after pass-cli re-locks |
| Public keys | `~/.ssh/keys/<name>.pub`; personal keys may be committed, others stay local |
| Host → key map | `~/.config/chezmoi/ssh-hosts.json` (machine-local) rendered into `~/.ssh/config` |
| Other host settings | `~/.ssh/config.local` (machine-local, read first) |
| Leftover key files | `ssh-key-audit` |

Mapped blocks are `Match host <pattern> exec` guards that only apply while
`SSH_AUTH_SOCK` is the personal agent socket. Tools that run their own
ssh-agent keep default ssh behavior. Keys that such tools use must not be
loaded into the personal agent, so keep them in vaults not listed in
`sshVaults`.

`ssh-hosts.json` example:

```json
[
  {"host": "github.com", "keys": ["github", "yk1", "yk2"]},
  {"host": "10.0.0.*", "keys": ["servers", "yk1", "yk2"]}
]
```

Keys are tried in order; list the Proton key first and the YubiKeys as
fallback. Each `IdentityFile` is emitted only once its `.pub` exists. Servers
without FIDO2 support (for example dropbear) only accept the Proton key.

## New machine

1. `chezmoi init` and answer the vault prompt (comma separated, or empty).
   Existing config: add `sshVaults = ["<vault>"]` under `[data]` in
   `~/.config/chezmoi/chezmoi.toml`.
2. Create `~/.config/chezmoi/ssh-hosts.json`.
3. `chezmoi apply`, then:
   `systemctl --user daemon-reload && systemctl --user enable --now ssh-agent.service proton-ssh-load.service`
4. Log out and back in once so the session drops a gcr/inherited `SSH_AUTH_SOCK`.
5. `ssh-unlock`.
6. YubiKeys: `cd ~/.ssh && ssh-keygen -K` with each key, then `ssh-unlock`.

## New Proton key

```sh
pass-cli item create ssh-key generate --vault-name <vault> --title <name>
ssh-unlock
ssh-key-export <vault> <name> <name>
chezmoi add ~/.ssh/keys/<name>.pub     # personal keys only
```

Add the host to `ssh-hosts.json`, then put the public key in the host's
`authorized_keys` or the service's key settings.

## YubiKey keys (once per key)

```sh
ssh-keygen -t ed25519-sk -O resident -O application=ssh:yk1 -C yk1 -f ~/.ssh/id_ed25519_sk_yk1
ssh-key-export --file ~/.ssh/id_ed25519_sk_yk1.pub yk1
chezmoi add ~/.ssh/keys/yk1.pub
```

Repeat with `yk2` on the backup key. Authorize both next to the Proton key
wherever it is authorized. Remote hosts need OpenSSH >= 8.2.

## Migrating old on-disk keys

1. `ssh-key-audit` lists key files still on disk.
2. Create a fresh Proton key per use (above); authorize it, test with
   `ssh -v <host>`.
3. Remove the old public key everywhere it is authorized.
4. `shred -u ~/.ssh/id_<old> ~/.ssh/id_<old>.pub`; `ssh-key-audit` exits 0.

## Agent forwarding

Off by default (`Host *`). Enable per host with `"forward": true` in
`ssh-hosts.json` or `ForwardAgent yes` in `config.local`, only for hosts you
trust with your agent. YubiKey keys still need a touch on the local device
when used through a forwarded agent.
