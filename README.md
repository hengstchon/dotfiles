## Requirements

- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [fzf](https://github.com/junegunn/fzf)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [delta](https://github.com/dandavison/delta)
- Font (for alacritty): [sarasa-fixed-sc-nerd-font](https://github.com/jonz94/Sarasa-Gothic-Nerd-Fonts/releases)
- Font (for kitty): [Sarasa Term SC](https://github.com/be5invis/Sarasa-Gothic/releases)

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
"kitty", "alacritty", "karabiner", "phoenix", "mpv", "zathura", "aerospace"
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

Install `zsh-proxy`:

```shell
git clone https://github.com/sukkaw/zsh-proxy.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-proxy
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
