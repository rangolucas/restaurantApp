FROM node:20

RUN apt-get update
RUN apt update

# Zsh
RUN apt install -y zsh && zsh --version
RUN yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

