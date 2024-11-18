#!/bin/bash
DS_PYTHON_IMG_VERSION=$(head -n 1 ./.ds_python_version)
docker run \
  -v $(pwd):/src \
  -ti --rm civisanalytics/datascience-python:${DS_PYTHON_IMG_VERSION} \
  /bin/bash -c \
    "pip freeze >> /tmp/requirements-aggregated-core.txt && \
    cat /src/requirements-core.txt >> /tmp/requirements-aggregated-core.txt && \
    pip install pip-tools && \
    pip-compile --output-file=/src/requirements-full.txt --strip-extras --pip-args='--prefer-binary' --upgrade /tmp/requirements-aggregated-core.txt"
