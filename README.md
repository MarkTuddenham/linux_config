# Config

Clone this to your home directory: `~/linux_config` and then use `stow <config>` to install a set of files.

e.g. 
```bash
stow --dotfiles nvim
stow -D nvim  # to uninstall
```

For directories ending in `_root`, use the `-t` option.

e.g. 
```bash
sudo stow --dotfiles -t / i3_root
```

