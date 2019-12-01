#!/bin/bash


build () {
    docker-compose build --no-cache --pull $1
    docker-compose push $1
}

build "wrk"
build "jupyter"
build "jupyterhub"
build "jupyter-ml"
build "jupyter-ml-cpu"
build "jupyter-ml-gpu"
