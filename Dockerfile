FROM civisanalytics/datascience-python:5.0.0
MAINTAINER support@civisanalytics.com

# Version strings are set in datascience-python
# Set to blank strings here; they'd be misleading.
ENV VERSION= \
    VERSION_MAJOR= \
    VERSION_MINOR= \
    VERSION_MICRO= \
    TINI_VERSION=v0.16.1 \
    DEFAULT_KERNEL=python3 \
    CIVIS_JUPYTER_NOTEBOOK_VERSION=1.0.1

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y --no-install-recommends && \
  apt-get install -y --no-install-recommends software-properties-common && \
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

RUN pip install civis-jupyter-notebook==${CIVIS_JUPYTER_NOTEBOOK_VERSION} && \
    civis-jupyter-notebooks-install

RUN pip install git+git://github.com/civisanalytics/civis-mpl-style.git@v0.1.0 && \
    install-civis-style

EXPOSE 8888
WORKDIR /root/work

# Configure container startup
ENTRYPOINT ["/tini", "--"]
CMD ["civis-jupyter-notebooks-start"]
