#!/bin/bash
docker run \
  -v $(pwd):/src \
  -ti --rm civisanalytics/datascience-python:7 \
  /bin/bash -c \
    "pip freeze >> /tmp/requirements-aggregated-core.txt && \
    cat /src/requirements-core.txt >> /tmp/requirements-aggregated-core.txt && \
    pip install pip-tools && \
    pip-compile --output-file=/src/requirements-full.txt --pip-args='--prefer-binary' /tmp/requirements-aggregated-core.txt"
