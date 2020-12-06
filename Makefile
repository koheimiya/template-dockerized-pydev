.PHONY: all clean build rebuild jupyter build-jupyter check test edit env
SHELL=/bin/bash
ID=$$(cat ID)
HOMEDST=/dockerhome
IMAGE=$$(cat IMAGE)
PACKAGE_ROOT=${CURDIR}/packages
RUN=docker run \
    --rm --init -u $$(id -u):$$(id -g) -w $$(pwd) -v $$(pwd):$$(pwd):delegated \
    -e PYTHONPATH=${PACKAGE_ROOT}

all: build


clean:
	docker image rm ${IMAGE}

build:
	docker build ${BUILD_OPTION} -t ${IMAGE} -f ./docker/Dockerfile \
	    --build-arg HOME=${HOMEDST} \
	    --build-arg USER=$$(id -u) \
	    --build-arg GROUP=$$(id -g) \
	    ./docker/

rebuild:
	make .build BUILD_OPTION="--no-cache --pull"


jupyter: .jupyter/jupyter_notebook_config.py .local/share/jupyter/lab
	@test $(PORT) || (echo Need PORT variable set. && exit 1)
	${RUN} -it -p ${PORT}:${PORT} --name notebook.${ID} ${IMAGE} \
	    jupyter lab --port=${PORT} --no-browser --ip=0.0.0.0

build-jupyter:
	${RUN} -it ${IMAGE} jupyter lab build


check:
	${RUN} ${IMAGE} mypy ${PACKAGE_ROOT} scripts


test: check
	${RUN} -it ${IMAGE} pytest ${PACKAGE_ROOT} $(OPTION)


edit:
	${RUN} -it ${IMAGE} nvim .

env:
	${RUN} -it ${IMAGE} bash
