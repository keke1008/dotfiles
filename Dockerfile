FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
	pacman -S --noconfirm bats

ARG USERNAME=user
RUN useradd -m "${USERNAME}"
USER "${USERNAME}"

CMD ["sh", "-c", "yes | /dotfiles/dot migrate && /dotfiles/dot test"]
