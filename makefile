

# TODO: neovim, qutebrowser, i3 (+i3-gnome), $HOME/.bash*, tmux, firacode,
# TODO: ipsec/VPN
# TODO: other dotfiles - only move the ones for specific commands?

COMMON_PACKAGES=ssh git preload
DESKTOP_PACKAGES=bat ripgrep libjs-pdf fd-find rofi sparse zsh
SERVER_PACKAGES=


.PHONY: all
all: server desktop

DEFAULT_GOAL: server
.PHONY: server
server: server_apt

.PHONY: desktop
desktop: desktop_apt c_scripts nvim nvim-setup kitty


.PHONY: common_apt
common_apt: requires_sudo
	@echo [apt install] $(COMMON_PACKAGES)
	@sudo apt install $(COMMON_PACKAGES)
	
.PHONY: server_apt
server_apt: common_apt requires_sudo
	@echo [apt install] $(SERVER_PACKAGES)
	@sudo apt install $(SERVER_PACKAGES)

.PHONY: desktop_apt
desktop_apt: common_apt requires_sudo
	@echo [apt install] $(DESKTOP_PACKAGES)
	@sudo apt install $(DESKTOP_PACKAGES)

.PHONY: common_setup
common_setup: common_apt
	@git config --global color.ui true


.PHONY: requires_sudo
requires_sudo:
	# Run the sudo command first so the user knows its needed for  the install
	# TODO: Can we quit if sudo fails?
	@echo "This install requires sudo, quit now if you do not want this."
	@sudo printf "sudo permission granted"

.PHONY: c_scripts
c_scripts: requires_sudo
	@echo [wget] Getting "c"
	@wget https://raw.githubusercontent.com/ryanmjacobs/c/master/c
	@echo [install] installing to /usr/bin/c
	@sudo install -m 755 c /usr/bin/c
	@echo [.bashrc] export CC=clang
	@printf "\nexport CC=clang" >> $HOME/.bashrc
	@echo [.bashrc] export CXX=clang
	@printf "export CXX=clang\n" >> $HOME/.bashrc

.PHONY: nvim
NVIM_BRANCH ?=master # or "stable" &c.
NVIM_BUILD_TYPE ?=Release # or "Debug", "RelWithDebInfo" &c.
nvim: cmake requires_sudo
	# https://github.com/neovim/neovim/wiki/Building-Neovim
	# TODO where to clone to?? /tmp/ ?
	@echo [git] cloning https://github.com/neovim/neovim.git to /tmp/neovim
	@git clone --single-branch -b $(NVIM_BRANCH) https://github.com/neovim/neovim.git /tmp/neovim
	@cd /tmp/neovim
	@echo [make] make $(NVIM_BUILD_TYPE)
	@make CMAKE_BUILD_TYPE=$(NVIM_BUILD_TYPE)
	@echo [make] make install
	@sudo make install

.PHONY: nvim-setup
nvim-setup:
	@echo [git] clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	@git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	@echo [cp] .vimrc
	@cp ./dotfiles/vimrc ~/.vimrc
	@echo [vim] install plugins
	@vim +PluginInstall +qall


.PHONY: cmake
cmake:
	@echo NOT IMPLEMENTED
	# TODO check its not installed first

.PHONY: kitty
kitty:
	@if ! command -v kitty &> /dev/null ; then\
		ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/;\
		cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/;\
		sed -i "s|Icon=kitty|Icon=/home/${USER}/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty.desktop;\
 		curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin;\
	fi

.PHONY: zsh
zsh: 
	@mkdir -p ${HOME}/.config/antigen
	@curl -L git.io/antigen > ${HOME}/.config/antigen/antigen.zsh
	# Will be done when we link across!!
	@mkdir -p ~/.config/zsh
	@mkdir -p ~/.config/zsh/custom
	@mkdir -p ~/.config/zsh/include
