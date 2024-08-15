# Civis Jupyter Notebook Docker Image for Python 3
[![CircleCI](https://circleci.com/gh/civisanalytics/civis-jupyter-python3/tree/master.svg?style=shield)](https://circleci.com/gh/civisanalytics/civis-jupyter-python3/tree/master)

## Installation

Either build the Docker image locally
```bash
./build_docker_file.sh
```

or download the image from DockerHub
```bash
docker pull civisanalytics/civis-jupyter-python3:latest
```

The `latest` tag (Docker's default if you don't specify a tag)
will give you the most recently-built version of the civis-jupyter-python3
image. You can replace the tag `latest` with a version number such as `1.0`
to retrieve a reproducible environment.

## Updating the version of Dockerfile's Base Image: civisanalytics/datascience-python

The version number has been pulled out into a dedicated file to centralize consumption of the file through the scripts that require it.

To update the version simply change the version number in `.ds_python_version`

## Testing Integration with Civis Platform

If you would like to test the image locally follow the steps below:

1. Create a notebook in your Civis platform account and grab the id of the notebook. This ID is the number that appears at the end of the URL for the notebook, https://platform.civisanalytics.com/#/notebooks/<NOTEBOOK ID>
2. Grab a Civis API Key from your account. [How to Generate a Civis API Key](https://civis.zendesk.com/hc/en-us/articles/216341583-Generating-an-API-Key)
3. Build your image locally: ```docker build -t civis-jupyter-python3 .```
4. Run the container: ```docker run --rm -p 8888:8888 -e PLATFORM_OBJECT_ID=<NOTEBOOK ID> -e CIVIS_API_KEY=$CIVIS_API_KEY civis-jupyter-python3``` (This assumes $CIVIS_API_KEY is set in your environment.)
5. Access the notebook at the ip of your docker host with port 8888 i.e. ```<docker-host-ip>:8888```

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for information about contributing to this project.

If you make any changes, be sure to build a container to verify that it successfully completes:
```bash
./build_docker_file.sh
```
and describe any changes in the [change log](CHANGELOG.md).

### For Maintainers

#### Updating Dependencies

Updating the `civis-jupyter-python3` Docker image entails the following:

* Update the base `datascience-python` image to the latest one;
* Update `requirements-core.txt`, the Python dependencies specific to this `civis-jupyter-python3` image.
* Update `requirements-full.txt` so that it has all transitive dependencies pinned
  while respecting those already pinned at both `datascience-python` and `requirements-core.txt`.

To execute these updates, follow these steps:

* Update the version number of the `datascience-python` image in both `Dockerfile` and `.ds_python_version`.
* Update the Python dependencies in `requirements-core.txt` as necessary.
* Locally, have Docker Desktop running in prep for the next step.
* Run `sh generate-requirements-full.sh` to update `requirements-full.txt`.
* To verify the new `civis-jupyter-python3` image would successfully build with your changes, locally run `sh build_docker_file.sh`.

#### Making a New Release

This repo has autobuild enabled. Any PR that is merged to master will
be built as the `latest` tag on Dockerhub.
Once you are ready to create a new version, go to the "releases" tab of the repository and click
"Draft a new release". GitHub will prompt you to create a new tag, release title, and release
description. The tag should use semantic versioning in the form "vX.X.X"; "major.minor.micro".
The title of the release should be the same as the tag. Include a change log in the release description.
Once the release is tagged, DockerHub will automatically build three identical containers, with labels
"major", "major.minor", and "major.minor.micro".

## License

BSD-3

See [LICENSE.txt](LICENSE.txt) for details.
