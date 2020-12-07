.PHONY: all clean build rebuild env env-gpu jupyter jupyter-gpu check test edit
SHELL=/bin/bash
CMD ?= /bin/bash -i
ID=$$(cat ID)
DOCKERUSERNAME=makefileuser
DOCKERHOME=/home/${DOCKERUSERNAME}
IMAGE=$$(cat IMAGE)
VOLUME=vol.${ID}
PACKAGE_ROOT=${CURDIR}/packages
RUN=docker run \
    --rm --init -u ${DOCKERUSERNAME} -w $$(pwd) -v $$(pwd):$$(pwd):delegated \
    -e PYTHONPATH=${PACKAGE_ROOT} --mount source=${VOLUME},target=${DOCKERHOME} ${RUN_OPTION}
GPUENV = --gpus all -e NVIDIA_DRIVER_CAPABILITIES=compute,utility -e NVIDIA_VISIBLE_DEVICES=all

all: build

clean:
	docker volume rm ${VOLUME}

build:
	docker build ${BUILD_OPTION} -t ${IMAGE} -f ./docker/simple.Dockerfile \
	    --build-arg USERNAME=${DOCKERUSERNAME} \
	    --build-arg USER=$$(id -u) \
	    --build-arg GROUP=$$(id -g) \
	    ./docker/

rebuild:
	make build BUILD_OPTION="--no-cache --pull"

env:
	${RUN} -it ${IMAGE} ${CMD}

env-gpu:
	make env RUN_OPTION="${GPUENV}"

jupyter:
	@test $(PORT) || (echo Need PORT variable set. && exit 1)
	${RUN} -it -p ${PORT}:${PORT} --name notebook.${ID} ${JUPYTERENV} ${IMAGE} \
	    jupyter notebook --port=${PORT} --no-browser --ip=0.0.0.0

jupyter-gpu:
	make jupyter PORT=${PORT} RUN_OPTION="${GPUENV}"

check:
	${RUN} -it ${IMAGE} mypy ${PACKAGE_ROOT} scripts

test: check
	${RUN} -it ${IMAGE} pytest ${PACKAGE_ROOT} $(OPTION)

edit:
	${RUN} -it ${IMAGE} nvim .
