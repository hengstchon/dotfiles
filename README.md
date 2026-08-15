## Requirements

- [starship](https://github.com/starship/starship)
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
"kitty", "alacritty", "karabiner", "mpv", "zathura", "aerospace"
]
```

`.dotter/local.toml` example:

```toml
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

Install [antidote](https://antidote.sh) (plugin manager):

```shell
brew install antidote
```

Bundles are declared in `zsh/zsh_plugins.txt` (deployed to
`~/.zsh_plugins.txt`). On the first shell start, antidote clones the plugins
into its cache and generates the static load file `~/.zsh_plugins.zsh`
automatically — just edit `zsh/zsh_plugins.txt` and open a new shell.

### ranger

Install devicons:

```shell
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
```

zoxide integration:

```shell
git clone https://github.com/jchook/ranger-zoxide.git ~/.config/ranger/plugins/zoxide
```
