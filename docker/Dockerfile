FROM continuumio/anaconda3:latest
RUN apt update && apt upgrade -y

# editor
# RUN apt install neovim -y
RUN apt update && apt install tzdata -y && apt install build-essential cmake pkg-config unzip git -y 
RUN apt install autoconf automake libtool autoconf-doc libtool-doc libtool-bin gettext -y 
WORKDIR /tmp
RUN git clone https://github.com/neovim/neovim.git
WORKDIR /tmp/neovim
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo && make install
ENV PATH /opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# python package managers
RUN pip install --upgrade pip
RUN conda update conda -y
RUN conda update anaconda -y

# Install Nodejs for Jupyterlab
RUN apt install -y nodejs

# Install dependencies via conda
RUN conda install pytorch cpuonly -c pytorch -y
RUN conda install neovim -c conda-forge -y

# Install dependencies via pip
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

# Post processing
ARG HOME 
ARG USER
ARG GROUP
COPY editor /editor
RUN chmod -R a+r /editor
RUN mkdir $HOME && chmod -R a+rwx $HOME
USER $USER:$GROUP
WORKDIR $HOME

# Set up editor
RUN mkdir .config && cp -r /editor/nvim $HOME/.config/nvim
RUN curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugUpdate +qall
RUN python -m venv .pyls-venv && . ./.pyls-venv/bin/activate && pip install -U pip && pip install python-language-server[all] && \
        mkdir -p $HOME/.local/bin && ln -s $HOME/.pyls-venv/bin/pyls $HOME/.local/bin/pyls
ENV PATH $HOME/.local/bin:$PATH

# Jupyter
ARG JUPYTER_CONFIG_DIR
ARG JUPYTERLAB_DIR
ENV JUPYTER_CONFIG_DIR $JUPYTER_CONFIG_DIR
ENV JUPYTERLAB_DIR $JUPYTERLAB_DIR
RUN jupyter lab build

# Finalize
VOLUME $HOME
ENV HOME $HOME
