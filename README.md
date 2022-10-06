# Dotfiles


# Profiles
- **core**: Core dotfiles installed on every machine
- **dev**: Dev dotfiles (VSCode, Jetbrains, etc)
- **linux**: Linux OS Instance dotfiles (KDE Neon, Ubuntu)


# Install via Git Repo
- Clone this repo into a local folder.
`git clone https://github.com/martokk/dotfiles ~/Dotfiles`
- Continue with Next Steps


# Install Profile from local Repo
- cd into local repo:
`cd ~/Dotfiles`

- list the dotfiles by using `make list profile=<PROFILE>`:
`make list profile=linux`

- install the dotfiles by using `make install profile=<PROFILE>` to create symlinks in $HOME directory:
`make install profile=linux`
