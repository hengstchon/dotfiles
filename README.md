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
