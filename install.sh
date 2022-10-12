#!/bin/bash
clear
# run `sh -c "$(curl -fsSL https://raw.github.com/martokk/dotfiles/master/install.sh)" "" dev`

# usage `install.sh <<profile_name>> [-s(simulate)]`
# usage `install.sh server -s` to simulate installing profile 'server' dotfiles.

# CONSTANTS
DOTFILES_REPO="$HOME/dotfiles"
DEFAULT_PROFILE='linux' # When no argument is supplied
IFS=$'\n'

# ARGUMENTS
if [[ $1 == "" ]]; then
    echo "No arguments provided. use 'install.sh <<profile_name>> [-s/simulate]'"
    exit 1
else
    PROFILE=${1:-$DEFAULT_PROFILE} # from argument
fi

if [[ $2 == "" ]]; then
    SIMULATE=1
else
    SIMULATE=0
fi

# DEFINE PROFILE PATHS
if [[ "$PROFILE" == "core" ]]; then
    PROFILE_PATHS=(./core)
elif [[ "$PROFILE" == "dev" ]]; then
    PROFILE_PATHS=(./core ./dev)
elif [[ "$PROFILE" == "server" ]]; then
    PROFILE_PATHS=(./core ./server)
else
    PROFILE_PATHS=(./core ./dev ./linux)
fi

# Clone dotfiles repo locally
git clone https://github.com/martokk/dotfiles "$DOTFILES_REPO"
cd "$DOTFILES_REPO" || exit 1

# Get all dotfiles from PROFILE_PATHS
DOTFILES=$(find "${PROFILE_PATHS[@]}" -not -path "*/.git/*" -not -name ".*swp" -type f | cut -d '/' -f 2- | sed 's: :\\ :g')

echo "--------------------------------- "
echo " INSTALL DOTFILE                  "
echo "--------------------------------- "
echo "  PROFILE: $PROFILE               "
echo "  PWD: $DOTFILES_REPO                "
echo "  PROFILE_PATHS: ${PROFILE_PATHS[*]}   "
echo "  SIMULATE: $SIMULATE   "
echo "--------------------------------- "

printf "\nInstalling dependencies...\n"
echo "--------------------------------- "
if [ $SIMULATE == 1 ]; then
    sudo apt install fontconfig zsh thefuck -y
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions"
fi

printf "\nCreating symlinks to dotfiles\n"
echo "--------------------------------- "
# echo "${DOTFILES[@]}"
for DOTFILE in $DOTFILES; do
    # echo "dofile: $DOTFILE"

    PATH_STRUCTURE=$(echo "$DOTFILE" | cut -d '/' -f 2-)
    # echo "path_struc: $PATH_STRUCTURE"

    TARGET=$(realpath "$DOTFILE")
    LINK_NAME="$HOME/$PATH_STRUCTURE"
    # echo "links_name: $LINK_NAME"

    PARENT_PATH=$(dirname "$LINK_NAME")
    # echo "parent_path: $PARENT_PATH"

    if [ $SIMULATE == 1 ]; then
        mkdir -p "$PARENT_PATH"
        ln -sfnv "$TARGET" "$LINK_NAME"
    else
        echo "mkdir -p $PARENT_PATH"
        echo "ln -sfnv '$TARGET' '$LINK_NAME'"
    fi

    # #mkdir -p "$$(dirname $(HOME)/$(shell echo $(val) | cut -d '/' -f 2- ))"

done

printf "\nRefreshing Fonts\n"
echo "--------------------------------- "
fc-cache -f

printf "\n\nComplete. Dotfiles have been linked to home directory"
