FROM continuumio/anaconda3:latest
RUN conda update conda
RUN conda update anaconda
RUN pip install --upgrade pip


# Install Nodejs for Jupyterlab
RUN apt update
RUN apt install -y nodejs


# Install dependencies via conda
RUN conda install pytorch cpuonly -c pytorch


# Install dependencies via pip
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt
