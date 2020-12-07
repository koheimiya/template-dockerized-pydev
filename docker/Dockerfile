FROM ubuntu:20.04

ARG USERNAME
ARG USER
ARG GROUP

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:neovim-ppa/stable && \
    apt-get update

RUN apt-get -y install python3 python3-pip python3-venv
RUN apt-get -y install neovim wget curl git

RUN pip3 install mypy pytest
RUN pip3 install jupyter click numpy matplotlib seaborn pandas tqdm
RUN pip3 install torch torchvision
RUN pip3 install python-language-server[all]

COPY editor /editor
RUN chmod -R a+r /editor

RUN groupadd ${USERNAME}-group -g $GROUP
RUN useradd -m -s /bin/bash -u $USER -g $GROUP $USERNAME
USER $USERNAME

RUN jupyter notebook --generate-config

# Set up editor
ENV HOME /home/${USERNAME}
WORKDIR $HOME
RUN mkdir .config && cp -r /editor/nvim $HOME/.config/nvim
RUN curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugUpdate +qall
# RUN python3 -m venv .pyls-venv && . ./.pyls-venv/bin/activate && pip install -U pip && pip install python-language-server[all] && \
#         mkdir -p $HOME/.local/bin && ln -s $HOME/.pyls-venv/bin/pyls $HOME/.local/bin/pyls
# ENV PATH $HOME/.local/bin:$PATH

# Finalize
VOLUME $HOME
