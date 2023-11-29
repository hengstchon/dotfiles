## Requirement tools

- zoxide
- fzf
- rg
- delta

## dotfiles install

```shell
git clone https://github.com/hengstchon/dotfiles.git ~/.dotfiles
```

All packages:

```toml
packages = [
# shell
"git", "zsh", "tmux", "neovim", "ranger",
# gui
"alacritty", "karabiner", "phoenix", "mpv", "zathura"
]
```

`.dotter/local.toml` example:

```toml
includes = [".dotter/include/mba.toml"]

packages = [
# shell
"git", "zsh", "tmux", "neovim", "ranger",
# gui
"alacritty", "mpv"
]

[variables]
git_username = "xxx"
git_email = "xxx"
```

## Setup

### ranger

Install devicons:

```shell
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
```

zoxide integration:

```shell
git clone https://github.com/jchook/ranger-zoxide.git ~/.config/ranger/plugins/zoxide
```
