# Proton Pass access for agents

Agents get credentials from Proton Pass through `pass-cli`, each with its own
Proton Pass agent identity. An identity sees only the vaults or items the user
granted it, every read is recorded with a reason, and the user can renew or
revoke it at any time (`pass-cli agent list|renew|delete|monitor`). Never use
the user's personal Proton Pass session or their personal SSH agent.

This file follows `pass-cli agent instructions` (the upstream template) with one
local difference: the user logs each identity in once, into a session
directory that persists, so an agent normally reuses that session and never
handles the personal access token (PAT).

## 1. Find your session

1. Check the CLI: `pass-cli --version`. If it is missing, see
   <https://protonpass.github.io/pass-cli/get-started/installation/> and ask
   the user before installing anything.
2. Your harness sets `PROTON_PASS_SESSION_DIR` to your identity's session
   directory (convention: `~/.local/state/<identity-or-project>/pass-cli`,
   mode 0700). If it is unset, stop: without it `pass-cli` falls back to the
   user's personal session. Ask the user which identity you should use.
3. Run `pass-cli info`. Exit code 0 and a line like
   `Personal Access Token: [Agent] <name>` mean you are logged in as that
   agent identity. If it names a person instead of `[Agent] …`, stop and tell
   the user.

**Session monitoring:** run `pass-cli info` before any other `pass-cli` command
and again during long tasks; sessions can expire. If a command fails, read the
whole output (authentication failure, permission denied, invalid parameters)
before retrying.

## 2. Logging in (only when the session is gone)

Normally the user has already logged your identity in. If `pass-cli info`
fails with an authentication error:

- Do not run `pass-cli logout`/`logout --force` in your session directory and
  do not switch to another directory; that would only discard the session.
- Ask the user to log the identity in again. They run, in their own terminal:

      printf 'PAT: '; read -rs PAT; echo
      PROTON_PASS_SESSION_DIR=<your session dir> \
        PROTON_PASS_PERSONAL_ACCESS_TOKEN="$PAT" pass-cli login; unset PAT

- If the user deliberately provides a PAT to you (for example in
  `PROTON_PASS_PERSONAL_ACCESS_TOKEN`), you may run `pass-cli login` with it,
  then `pass-cli info`. Never write a PAT to files, notes, memory, logs or
  chat, and never ask for one to be pasted into the conversation.

A lapsed identity token (identities expire, for example after 3 months) also
shows up as authentication errors; the user renews it with
`pass-cli agent renew <name>`.

## 3. Discover what you may use

    pass-cli vault list --output json                    # vaults your identity can see
    pass-cli share list --output json                    # vaults and directly shared items
    pass-cli item list --vault-name "Name" --output json # items in a vault
    pass-cli item list --output json                     # all accessible items

Use `--output json` for parsing. Listing shows titles and types, not secret
values. Project instructions (for example a repository's `AGENTS.md`) say which
vault and items a task uses; prefer those over guessing from titles.

## 4. Read only what the task needs, with a reason

`item view` requires `PROTON_PASS_AGENT_REASON`, recorded in the identity's
audit log. Make it specific to the task:

    PROTON_PASS_AGENT_REASON="Decrypt Ansible Vault for forgejo.yml check run" \
      pass-cli item view --vault-name "Vault" --item-title "Item" --field password

    PROTON_PASS_AGENT_REASON="..." pass-cli item view "pass://SHARE_ID/ITEM_ID"

These also require a reason: `item create` (all kinds, including
`item create ssh-key`), `item update`, `item trash`, `item untrash`,
`vault update`. A viewer-role identity cannot perform them at all.

Rules:

- Fetch a single field where possible and pipe it straight into the consuming
  command (for example an Ansible `vault_password_file` script). Never print
  secret values to the terminal, logs, commits or chat, and never store them.
- SSH keys stay in Proton Pass. They are served by `pass-cli ssh-agent` on a
  socket the harness exposes as `SSH_AUTH_SOCK`; never export private keys to
  disk. List what you can use with `ssh-add -l`.
- Do not work around missing access by using other sessions, other agents'
  sockets or the user's account; report it to the user.

## Quick reference

    pass-cli info                                          # who am I, is the session valid
    pass-cli test                                          # API connectivity
    pass-cli vault list --output json
    pass-cli item list --vault-name <NAME> --output json
    PROTON_PASS_AGENT_REASON="…" pass-cli item view --vault-name <VAULT> \
      --item-title <TITLE> [--field <FIELD>]
    ssh-add -l                                             # keys on your SSH agent socket
    pass-cli agent instructions                            # upstream instructions

Full CLI documentation: <https://protonpass.github.io/pass-cli/>
