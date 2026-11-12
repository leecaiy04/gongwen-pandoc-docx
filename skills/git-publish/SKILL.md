---
name: git-publish
description: Publish a local Git repository to GitHub or a Gitea/Forgejo server. Use when the user asks to create a remote repository, connect a remote, authenticate Git, or push local commits.
---

# Publish Git Repositories

Help the user publish the intended local repository to a named Git hosting service. Keep credentials out of repository files, remote URLs, shell history, and command arguments.

## Before publishing

- Inspect the current branch, working tree, recent commits, and configured remotes.
- Preserve unrelated user changes. Commit only files that belong to the requested publication, and do not create a commit unless the user asked to save those changes or the workflow clearly requires it.
- Confirm the host, owner/account, repository name, and visibility from the user's request or existing repository state. Ask only for missing details that cannot be inferred reliably.
- Check whether the repository already exists before creating one. Never overwrite an existing remote repository by force.
- Use a separate remote name when adding another host; keep existing remotes intact.

## GitHub

Prefer GitHub CLI (`gh`) for authentication and repository creation.

```bash
gh auth status
gh auth login --hostname github.com --git-protocol https --web
gh auth setup-git
```

Create and push when the user has requested a new repository and supplied or established its visibility:

```bash
gh repo create OWNER/NAME --public --source=. --remote=origin --push
```

Use `--private` when requested. If the repo already exists, add or verify its HTTPS/SSH remote and push the requested branch without replacing history.

## Gitea and Forgejo

Gitea-compatible servers commonly expose `/api/v1/version`, `/api/v1/repos/{owner}/{repo}`, and `POST /api/v1/user/repos`. Check the host and repository before creating anything. Use a server-issued token when available; otherwise use an interactive password prompt for the API request or Git push.

For example, curl can prompt for the password when `--user` contains only the account name:

```bash
curl --user ACCOUNT --request POST \
  --header 'Content-Type: application/json' \
  --data '{"name":"REPO","private":true,"auto_init":false}' \
  https://git.example.com/api/v1/user/repos
```

Add a credential-free remote URL and push the requested branch:

```bash
git remote add forgejo https://git.example.com/OWNER/REPO.git
git -c credential.helper= push --set-upstream forgejo BRANCH
```

The empty per-command credential helper lets Git prompt in the terminal without placing the password in the URL. Do not store credentials unless the user explicitly asks; if persistent storage is requested, prefer the host's credential manager or operating-system keychain.

## Network proxy

When the user provides a proxy, set it only for the authentication or network command that needs it:

```bash
HTTPS_PROXY=http://proxy.example:8080 HTTP_PROXY=http://proxy.example:8080 gh auth login --hostname github.com --git-protocol https --web
HTTPS_PROXY=http://proxy.example:8080 HTTP_PROXY=http://proxy.example:8080 git push origin BRANCH
```

For a sequence of related calls, export proxy variables in the current shell and unset them afterward. Do not write proxy credentials or endpoints into Git configuration or repository files. Test the target host directly before assuming a proxy is needed.

## Verify

- Confirm the push result and that the remote branch points to the intended local commit.
- Check `git status` and `git remote -v`; confirm remote URLs contain no username/password or token.
- Report the repository URL, pushed branch, and commit. Do not claim success if the host could not be queried or the push did not complete.
