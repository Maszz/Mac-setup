# Mac Setup with Ansible Playbook

This playbook is designed to automate the setup process for a development MacBook. It contains configurations and installations commonly used in development environments. 

The script provided is intended to be run on a clean install MacBook to ensure a consistent setup process.

## Usage

Run a script and following the instruction.
```shell
chmod +x ./install.sh
./install.sh
```

## Package Install

### Zsh Shell and Oh My Zsh Installation

First, Zsh shell and Oh My Zsh will be installed
And other config need to be config in `.zshrc` need to be do after this.

### Packages Installed using Homebrew:

The following packages will be installed using Homebrew:

- `gh`
- `wget`
- `bat`
- `ripgrep`
- `fd`
- `fzf`
- `zoxide` (with setup handler: Setup zoxide)
- `neovim`
- `node`
- `nvm` (with setup handler: Setup nvm)
- `golang` (with setup handler: Setup gvm)

### Casks Installed using Homebrew:

The following casks will be installed using Homebrew:

- `google-chrome`
- `arc`
- `warp` (with setup handler: Setup warp)
- `visual-studio-code` (with setup handler: Setup vscode)
- `miniconda` (with setup handler: Init conda)
- `obsidian`
- `docker`
- `raycast`
- `gpg-suite`

## GPG Key Setup for Git Commit Signing

To enhance the security of your Git commits, you can configure Git to use GPG signing. This involves generating a GPG key pair, configuring Git to sign commits with your GPG key, and adding your GPG public key to your GitHub account.

### Grant OAuth Scope and Configure Git

Before setting up GPG signing for Git commits, make sure to grant the necessary OAuth scope and configure Git to use GPG signing:

```shell
gh auth refresh -s write:gpg_key read:gpg_key
git config --global commit.gpgsign true
```

### Generate GPG Key

To generate a new GPG key pair, follow these steps:

```shell
gpg --full-generate-key
```

After generating the key pair, you can list your secret keys to retrieve the key ID:

```shell
gpg --list-secret-keys --keyid-format=long
```

### Export GPG Public Key

Export your GPG public key to an ASCII-armored file:

```shell
gpg --armor --export <key> > public_key.asc
```

Replace <key> with the key ID obtained from the previous step.

### Add GPG Public Key to GitHub

Finally, add your GPG public key to your GitHub account:

```shell
gh gpg-key add ./public_key.asc
```

