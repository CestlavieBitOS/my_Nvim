#!/bin/bash

# Repository URL
REPO_URL="https://github.com/your-username/minimal-neovim-plugin-installer"

# Function to install Neovim and dependencies
install_dependencies() {
  echo "Installing dependencies..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS"
    brew install neovim git
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Detected Linux"
    sudo apt update && sudo apt install -y neovim git curl
  else
    echo "Unsupported OS. Please install dependencies manually."
    exit 1
  fi
}

# Function to clone the configuration repository
clone_repo() {
  echo "Cloning configuration repository..."
  git clone "$REPO_URL" ~/.minimal-neovim-plugin-installer || {
    echo "Repository already cloned. Pulling latest changes..."
    git -C ~/.minimal-neovim-plugin-installer pull
  }
}

# Function to install Lazy.nvim plugin manager
install_lazy_nvim() {
  echo "Installing lazy.nvim plugin manager..."
  local lazypath=~/.local/share/nvim/lazy/lazy.nvim
  if [[ ! -d "$lazypath" ]]; then
    git clone https://github.com/folke/lazy.nvim.git "$lazypath"
  fi
}

# Function to copy Neovim configuration files
setup_neovim_config() {
  echo "Setting up Neovim configuration..."
  mkdir -p ~/.config/nvim
  cp -a ~/.minimal-neovim-plugin-installer/nvim/. ~/.config/nvim/
}

# Function to launch Neovim for initial plugin setup
initialize_plugins() {
  echo "Initializing plugins..."
  nvim --headless "+Lazy! sync" +qa
}

# Main installer logic
main() {
  install_dependencies
  clone_repo
  install_lazy_nvim
  setup_neovim_config
  initialize_plugins
  echo "Installation completed! Neovim is fully configured and ready to use."
}

main
