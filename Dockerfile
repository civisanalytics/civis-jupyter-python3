# Default value provided here; will be overridden at build time.
# Unfortunately Dockerhub isn't as flexible as CircleCi or AWS Codebuild, so we have to hardcode this value here.
# So if you in the future need to update this value, make sure you also edit the value in .ds_python_version.
# These values should be kept in sync.
ARG DS_PYTHON_IMG_VERSION=8.2.0
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

# Install Tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

# Layer 1: System dependencies and user setup (rarely changes)
RUN set -ex && \
  # Make tini executable
  chmod 755 /tini && \
  # Update package lists and install system packages
  DEBIAN_FRONTEND=noninteractive apt-get update -y --no-install-recommends && \
  apt-get install -y --no-install-recommends \
  vim \
  nano \
  htop \
  tmux \
  emacs && \
  # Clean up apt cache
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/* && \
  # Create non-root user and group
  groupadd -r civis && \
  useradd -r -g civis -m -d /home/civis civis && \
  # Create working directory with proper permissions
  mkdir -p /home/civis/work && \
  chown -R civis:civis /home/civis

# Layer 2: Python dependencies (changes more frequently)
COPY requirements-full.txt /tmp/requirements-full.txt
RUN set -ex && \
  # Install Python packages
  pip install --progress-bar off --no-cache-dir setuptools==75.5.0 && \
  pip install --progress-bar off --no-cache-dir -r /tmp/requirements-full.txt && \
  rm /tmp/requirements-full.txt && \
  civis-jupyter-notebooks-install && \
  # Clean pip cache
  pip cache purge || true && \
  # Remove any temporary files
  rm -rf /tmp/* /var/tmp/*

EXPOSE 8888
WORKDIR /home/civis/work

# Switch to non-root user
USER civis

# Configure container startup
ENTRYPOINT ["/tini", "--"]
CMD ["civis-jupyter-notebooks-start", "--NotebookApp.show_banner=False"]
