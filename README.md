# Civis Jupyter Notebook Docker Image for Python 3
[![CircleCI](https://circleci.com/gh/civisanalytics/civis-jupyter-python3/tree/master.svg?style=svg)](https://circleci.com/gh/civisanalytics/civis-jupyter-python3/tree/master)

# Installation

Either build the Docker image locally
```bash
docker build -t civis-jupyter-python3 .
```

or download the image from DockerHub
```bash
docker pull civisanalytics/civis-jupyter-python3:latest
```

The `latest` tag (Docker's default if you don't specify a tag)
will give you the most recently-built version of the civis-jupyter-python3
image. You can replace the tag `latest` with a version number such as `1.0`
to retrieve a reproducible environment.

# Testing Integration with the Civis Platform

If you would like to test the image locally follow the steps below:

1. Create a notebook in your Civis platform account and grab the id of the notebook. This ID is the number that appears at the end of the URL for the notebook, https://platform.civisanalytics.com/#/notebooks/<NOTEBOOK ID>
2. Grab a Civis API Key from your account. [How to Generate a Civis API Key](https://civis.zendesk.com/hc/en-us/articles/216341583-Generating-an-API-Key)
3. Create an environment file called ```my.env``` and add the following to it:
```bash
PLATFORM_OBJECT_ID=<NOTEBOOK ID>
CIVIS_API_KEY=<YOUR API KEY>
```
3. Build your image locally: ```docker build -t civis-jupyter-python3 .```
4. Run the container: ```docker run --rm -p 8888:8888 --env-file my.env civis-jupyter-python3```
5. Access the notebook at the ip of your docker host with port 8888 i.e. ```<docker-host-ip>:8888```

# Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for information about contributing to this project.

If you make any changes, be sure to build a container to verify that it successfully completes:
```bash
docker build -t civis-jupyter-python3:test .
```
and describe any changes in the [change log](CHANGELOG.md).

## For Maintainers

This repo has autobuild enabled. Any PR that is merged to master will
be built as the `latest` tag on Dockerhub.
Once you are ready to create a new version, go to the "releases" tab of the repository and click
"Draft a new release". Github will prompt you to create a new tag, release title, and release
description. The tag should use semantic versioning in the form "vX.X.X"; "major.minor.micro".
The title of the release should be the same as the tag. Include a change log in the release description.
Once the release is tagged, DockerHub will automatically build three identical containers, with labels
"major", "major.minor", and "major.minor.micro".

# License

BSD-3

See [LICENSE.md](LICENSE.md) for details.
