pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S ttf-maple \
  wezterm\
  neovim\
  php \
  composer \
  tldr \
  fzf \
  fd \
  ripgrep \
  gdu \
  go \
  nvm \
  ruby \
  pnpm \
  eza \
  zsh \
  zoxide \
  bat \
  lazygit \
  make \
  chezmoi

chsh -s /usr/bin/zsh
nvm install --lts
nvm use --lts
gem install theme-check
pnpm add -g @shopify/cli @shopify/theme prettier
