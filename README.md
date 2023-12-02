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

### zsh

Install `zsh-autosuggestions`:

```shell
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

Install `zsh-syntax-highlighting`:

```shell
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### ranger

Install devicons:

```shell
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
```

zoxide integration:

```shell
git clone https://github.com/jchook/ranger-zoxide.git ~/.config/ranger/plugins/zoxide
```
