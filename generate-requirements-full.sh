#!/bin/bash
DS_PYTHON_IMG_VERSION=$(head -n 1 ./.ds_python_version)
docker run \
  -v $(pwd):/src \
  -ti --rm civisanalytics/datascience-python:${DS_PYTHON_IMG_VERSION} \
  /bin/bash -c \
    "uv pip freeze >> /tmp/requirements-aggregated-core.txt && \
    cat /src/requirements-core.txt >> /tmp/requirements-aggregated-core.txt && \
    uv pip compile --output-file=/src/requirements-full.txt --upgrade /tmp/requirements-aggregated-core.txt"
