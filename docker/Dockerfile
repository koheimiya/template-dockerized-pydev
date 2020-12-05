FROM continuumio/anaconda3:latest
RUN apt update
RUN pip install --upgrade pip

# editor
RUN apt install neovim -y
RUN pip install neovim


# # python package managers
# RUN conda update conda -y
# RUN conda update anaconda -y
# 
# # Install Nodejs for Jupyterlab
# RUN apt install -y nodejs
# 
# # Install dependencies via conda
# RUN conda install pytorch cpuonly -c pytorch -y
# 
# # Install dependencies via pip
# COPY requirements.txt /tmp/
# RUN pip install -r /tmp/requirements.txt
