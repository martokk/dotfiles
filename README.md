# Martokk's Dotfiles

Install's Martokk's dotfiles by creating symlinks to the dotfiles in this repo.

### Available Profiles

- **core**: Core dotfiles installed on every machine
- **dev**: Dev dotfiles (VSCode, Jetbrains, etc)
- **server**: Server dotfiles (AWS, Docker, etc)
- **linux**: Linux OS Instance dotfiles (KDE Neon, Ubuntu)

# Install

## Install via Curl command (Recommended):

```shell
bash -c "$(curl -fsSL https://raw.github.com/martokk/dotfiles/master/install.sh)" "" core
```

---

## Install via Script or Makefile

Clone this repo into a local folder.

```shell
git clone https://github.com/martokk/dotfiles ~/dotfiles
```

### Install via install.sh

```shell
cd ~/dotfiles
bash ./install.sh core
```

### OR: Install via Makefile

```shell
cd ~/dotfiles
make install profile=core
```
