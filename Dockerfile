FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm bats

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME
COPY --chown=${USERNAME}:${USERNAME} . ./dotfiles

CMD [ "sh", "-c", "eval $(~/dotfiles/dot shellenv) && bats -r ~/dotfiles/configs"]
