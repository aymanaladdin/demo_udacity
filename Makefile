DOCKER_IMAGE    = 32bit/ubuntu:14.04
current_dir 	:= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

 
all             : build
 
build           :
		mkdir -p $(current_dir)/dist
		docker run --rm -v $(current_dir):/tmp/script $(DOCKER_IMAGE) /tmp/script/get-python.sh
 
clean		:
		rm -rf $(current_dir)/dist
		rm -rf $(current_dir)/pyenv*

git_release	: build
		git checkout -m dist
		git add . 
		git commit -m "new release"
		git push origin dist

.PHONY          : build release clean
