.PHONY: all clean build rebuild jupyter check test edit env
SHELL=/bin/bash
ID=$$(cat ID)
HOMESRC=${CURDIR}/.dockerhome
HOMEDST=/dockerhome
IMAGE=$$(cat IMAGE)
PACKAGE_ROOT=${CURDIR}/packages
RUN=docker run \
    --rm --init -u $$(id -u):$$(id -g) -w $$(pwd) -v $$(pwd):$$(pwd):delegated \
    -e HOME=${HOMEDST} \
    -e XDG_CONFIG_HOME=${HOMEDST}/.config \
    -e PYTHONPATH=${PACKAGE_ROOT} \
    -v $$(pwd)/docker/editor/nvim:${HOMEDST}/.config/nvim:delegated
JUPYTERENV= -e JUPYTER_CONFIG_DIR=${HOMEDST}/.jupyter \
	    -e JUPYTERLAB_DIR=${HOMEDST}/.local/share/jupyter/lab

all: build ${HOMESRC}


clean:
	docker image rm ${IMAGE}
	rm -rf ${HOMESRC}

build:
	docker build ${BUILD_OPTION} -t ${IMAGE} -f ./docker/Dockerfile \
	    --build-arg HOME=${HOMEDST} \
	    --build-arg USER=$$(id -u) \
	    --build-arg GROUP=$$(id -g) \
	    ./docker/

rebuild:
	make .build BUILD_OPTION="--no-cache --pull"


${HOMESRC}:
	mkdir ${HOMESRC}


jupyter: .jupyter/jupyter_notebook_config.py .local/share/jupyter/lab
	@test $(PORT) || (echo Need PORT variable set. && exit 1)
	${RUN} -it -p ${PORT}:${PORT} --name notebook.${ID} ${JUPYTERENV} ${IMAGE} \
	    jupyter lab --port=${PORT} --no-browser --ip=0.0.0.0

${HOMESRC}/.jupyter/jupyter_notebook_config.py:
	${RUN} -it ${JUPYTERENV} ${IMAGE} \
	    jupyter notebook --generate-config

${HOMESRC}/.local/share/jupyter/lab:
	${RUN} -it ${JUPYTERENV} ${IMAGE} \
	    jupyter lab build


check:
	${RUN} ${IMAGE} mypy ${PACKAGE_ROOT} scripts


test: check
	${RUN} -it ${IMAGE} pytest ${PACKAGE_ROOT} $(OPTION)


edit:
	${RUN} -it ${IMAGE} nvim .

# .install.plug:
# 	${RUN} -it ${IMAGE} sh -c 'curl -fLo "$${XDG_DATA_HOME:-$$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# 	@touch $@

env:
	${RUN} -it ${IMAGE} bash
