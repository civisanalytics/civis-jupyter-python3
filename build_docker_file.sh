#!/bin/bash
DS_PYTHON_IMG_VERSION=$(head -n 1 ./.ds_python_version)
docker build --build-arg="DS_PYTHON_IMG_VERSION=${DS_PYTHON_IMG_VERSION}" -t civis-jupyter-python3  -f ./Dockerfile .
