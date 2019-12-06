# PyYANG docker image
This repo contains the [dockerfile](Dockerfile) to build an image with the [PyYANG](https://github.com/mbj4668/pyang) tool installed inside.

## How to build/install
Pull the image from the docker hub with `docker pull hellt/pyang`.

To locally build the image clone the repo and use `docker build -t <your_repo>/<project>:<tag> .` command.

## Usage
`hellt/pyang` image expects you to mount a directory with YANG models (aka working directory) by the path `/yang/`. The following example demonstrates how to use the tools that are part of the PyYANG project with this configuration in mind:

```bash
# pyang tool example

# navigate to a dir with the YANG model(s) and run the container
# assuming the nokia-conf-combined.yang model is in the current directory
## create a tree representation of a yang model
docker run --rm -v $(pwd):/yang hellt/pyang pyang -f tree nokia-conf-combined.yang
```
Along with `pyang`, the following tools are part of the image:

- json2xml
- pyang
- yang2dsdl
- yang2html

## Tags
The image is tagged with accordance to the PyYANG releases. The tag `2.1` means that PyYANG of version `2.1` is installed in the image. The untagged image will always represent the latest pyang version that was available at the time of the build process.
