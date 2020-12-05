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

# Install dependencies via pip
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt
