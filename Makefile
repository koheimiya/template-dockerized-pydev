.PHONY: all clean build jupyter check test
SHELL=/bin/bash
ID=$$(cat ID)
DOCKERHOME=${CURDIR}/.dockerhome
IMAGE=$$(cat IMAGE)
PACKAGE_ROOT=packages
RUN=docker run \
    --rm --init -u $$(id -u):$$(id -g) -v $$(pwd):$$(pwd) -w $$(pwd) \
    -e HOME=${DOCKERHOME} -v ${DOCKERHOME}:${DOCKERHOME} \
    -e PYTHONPATH=${PACKAGE_ROOT}
JUPYTERENV= -e JUPYTER_CONFIG_DIR=${DOCKERHOME}/.jupyter \
	    -e JUPYTERLAB_DIR=${DOCKERHOME}/.local/share/jupyter/lab

all: build ${DOCKERHOME}


clean:
	docker image rm ${IMAGE}
	rm -rf ${DOCKERHOME}

build:
	docker build ${BUILD_OPTION} -t ${IMAGE} -f ./docker/Dockerfile ./docker/

rebuild:
	make build BUILD_OPTION="--no-cache --pull"


${DOCKERHOME}:
	mkdir ${DOCKERHOME}


jupyter: .jupyter/jupyter_notebook_config.py .local/share/jupyter/lab
	@test $(PORT) || (echo Need PORT variable set. && exit 1)
	${RUN} -it -p ${PORT}:${PORT} --name notebook.${ID} ${JUPYTERENV} ${IMAGE} \
	    jupyter lab --port=${PORT} --no-browser --ip=0.0.0.0

${DOCKERHOME}/.jupyter/jupyter_notebook_config.py:
	${RUN} -it ${JUPYTERENV} ${IMAGE} \
	    jupyter notebook --generate-config

${DOCKERHOME}/.local/share/jupyter/lab:
	${RUN} -it ${JUPYTERENV} ${IMAGE} \
	    jupyter lab build


check:
	${RUN} ${IMAGE} mypy ${PACKAGE_ROOT} scripts


test: check
	${RUN} -it ${IMAGE} pytest ${PACKAGE_ROOT} $(OPTION)
