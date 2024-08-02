FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y bats

ARG USER=user
RUN useradd -m "$USER"
WORKDIR /home/$USER

CMD ["./dotfiles/dot", "test"]
