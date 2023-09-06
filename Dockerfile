FROM civisanalytics/datascience-python:7.0.0
LABEL maintainer = support@civisanalytics.com

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

RUN pip install -r requirements-full.txt && \
    pip cache purge && \
    rm requirements-full.txt && \
    civis-jupyter-notebooks-install

EXPOSE 8888
WORKDIR /root/work

# Configure container startup
ENTRYPOINT ["/tini", "--"]
CMD ["civis-jupyter-notebooks-start"]
