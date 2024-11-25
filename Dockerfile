# Default value provided here; will be overridden at build time.
# Unfortunately Dockerhub isn't as flexible as CircleCi or AWS Codebuild, so we have to hardcode this value here.
# So if you in the future need to update this value, make sure you also edit the value in .ds_python_version.
# These values should be kept in sync.
ARG DS_PYTHON_IMG_VERSION=8.1.0

ARG PLATFORM=linux/x86_64

FROM --platform=$PLATFORM civisanalytics/datascience-python:${DS_PYTHON_IMG_VERSION}

LABEL maintainer=support@civisanalytics.com

# Version strings are set in datascience-python
# Set to blank strings here; they'd be misleading.
ENV VERSION= \
    VERSION_MAJOR= \
    VERSION_MINOR= \
    VERSION_MICRO= \
    TINI_VERSION=v0.19.0 \
    DEFAULT_KERNEL=python3

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y --no-install-recommends && \
  apt-get install -y --no-install-recommends \
        vim \
        nano \
        htop \
        tmux \
        emacs && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/*

# Install Tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

COPY requirements-full.txt .

# setuptools is required since the notebook package uses distutils, which isn't in Python 3.12.6+.
# It's installed here since pip-compile doesn't include setuptools in requirements files.
RUN pip install --progress-bar off --no-cache-dir setuptools==75.5.0 && \
    pip install --progress-bar off --no-cache-dir -r requirements-full.txt && \
    rm requirements-full.txt && \
    civis-jupyter-notebooks-install

EXPOSE 8888
WORKDIR /root/work

# Configure container startup
ENTRYPOINT ["/tini", "--"]
CMD ["civis-jupyter-notebooks-start", "--NotebookApp.show_banner=False"]
