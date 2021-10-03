# TODO: neovim, qutebrowser, i3 (+i3-gnome), $HOME/.bash*, tmux, firacode,
# TODO: ipsec/VPN
# TODO: other dotfiles - only move the ones for specific commands?

COMMON_PACKAGES=ssh git preload
DESKTOP_PACKAGES=bat ripgrep libjs-pdf fd-find rofi sparse zsh clangd-12 neomutt isync msmtp pandoc stow pass pass-git-helper zathura
SERVER_PACKAGES=

# Dirs
BUILD_DIR=${HOME}/build

# Commands
MKDIR=mkdir -p


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
	@sudo apt install -y $(COMMON_PACKAGES)
	
.PHONY: server_apt
server_apt: common_apt requires_sudo
	@echo [apt install] $(SERVER_PACKAGES)
	@sudo apt install -y $(SERVER_PACKAGES)

.PHONY: desktop_apt
desktop_apt: common_apt requires_sudo
	@echo [apt install] $(DESKTOP_PACKAGES)
	@sudo apt install $(DESKTOP_PACKAGES)

# .PHONY: common_setup
# common_setup: common_apt
# 	@git config --global color.ui true


.PHONY: requires_sudo
requires_sudo:
	@# Run the sudo command first so the user knows its needed for  the install
	@# TODO: Can we quit if sudo fails?
	@echo "This install requires sudo, quit now if you do not want this."
	@sudo printf "sudo permission granted"

.PHONY: c_scripts
c_scripts: requires_sudo
	@echo [wget] Getting "c"
	@wget https://raw.githubusercontent.com/ryanmjacobs/c/master/c
	@echo [install] installing to /usr/bin/c
	@sudo install -m 755 c /usr/bin/c
	@echo [.bashrc] export CC=clang
	@printf "\nexport CC=clang" >> ${HOME}/.bashrc
	@echo [.bashrc] export CXX=clang
	@printf "export CXX=clang\n" >> ${HOME}/.bashrc

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
	@echo [git] clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
	@git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
	@echo [cp] .vimrc
	@cp ./HOME/.vimrc ${HOME}/.vimrc
	@echo [vim] install plugins
	@nvim +PluginInstall +qall
	# things for lsp
	@pip install 'python-lsp-server[all]' pyls-flake8 pyls-isort python-lsp-black


.PHONY: cmake
cmake:
	@echo NOT IMPLEMENTED
	# TODO check its not installed first

.PHONY: kitty
kitty:
	@if ! command -v kitty &> /dev/null ; then\
 		curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin;\
		ln -s ${HOME}/.local/kitty.app/bin/kitty ${HOME}/bin/;\
		cp ${HOME}/.local/kitty.app/share/applications/kitty.desktop ${HOME}/.local/share/applications/;\
		sed -i "s|Icon=kitty|Icon=/home/${USER}/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ${HOME}/.local/share/applications/kitty.desktop;\
	fi

.PHONY: picom
picom: requires_sudo folders
	@sudo apt install -y cmake meson git pkg-config asciidoc libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev  libpcre2-dev  libevdev-dev uthash-dev libev-dev libx11-xcb-dev
	@if [ ! -d '${BUILD_DIR}/picom' ]; then git clone https://github.com/jonaburg/picom ${BUILD_DIR}/picom; fi
	@cd ${BUILD_DIR}/picom
	@git submodule update --init --recursive
	@meson --buildtype=release ${BUILD_DIR}/picom build
	@ninja -C build
	@sudo ninja -C build install
	@cd -

.PHONY: folders
folders:
	@${MKDIR} ${BUILD_DIR}
		
.PHONY: zsh
zsh: 
	@${MKDIR} ${HOME}/.config/zsh/antigen
	@curl -L git.io/antigen > ${HOME}/.config/zsh/antigen/antigen.zsh
	@# Will be done when we link across!!
	@${MKDIR} ${HOME}/.config/zsh
	@${MKDIR} ${HOME}/.config/zsh/custom
	@${MKDIR} ${HOME}/.config/zsh/include

.PHONY:
npm-global-installs:
	npm-i -g bash-language-server
