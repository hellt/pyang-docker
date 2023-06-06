# PYANG docker image

This repo contains the [dockerfile](Dockerfile) to build an image with the [PyYANG](https://github.com/mbj4668/pyang) tool installed inside.

As well as the following plugins are included:

* [Openconfig plugins](https://github.com/openconfig/oc-pyang) - installed at `/opt/pyang-oc-plugin`

## How to install

Pull the `hellt/pyang` image from GitHub container registry with `docker pull ghcr.io/hellt/pyang`.

To locally build the image, clone the repo and use `docker build -t <your_repo>/<project>:<tag> -f <Dockerfile> .` command.

## Image tags

The repo contains two Dockerfiles, one is based on Alpine Linux and has a smaller size, the other one is based on PyPy and has faster execution time.

Starting from pyang 2.5.3, we tag with `latest` tag the PyPy image, and with `alpine` tag the Alpine Linux image.

Check available tags here - <https://github.com/hellt/pyang-docker/pkgs/container/pyang/versions>

## Usage

`hellt/pyang` image expects you to mount a directory with YANG models (aka working directory) by the path `/yang/`. The following example demonstrates how to use the tools that are part of the PyYANG project with this configuration in mind:

```bash
# pyang tool example

# navigate to a dir with the YANG model(s) and run the container
# assuming the nokia-conf-combined.yang model is in the current directory
## create a tree representation of a yang model
docker run --rm -v $(pwd):/yang ghcr.io/hellt/pyang pyang -f tree nokia-conf-combined.yang
```

Along with `pyang`, the following tools are part of the image:

* json2xml
* pyang
* yang2dsdl
* yang2html

### Additional enhancements

##### XML skeleton wrapper

To simplify the process of getting the XML skeleton for the data modelled in YANG and referenced by its model path the `xmlsk.sh` wrapper has been created. The sole purpose of this wrapper is to remove the prefix from the path string, since pyang's XML_SKELETON does not digest them.

With `xmlsk.sh` wrapper the workflow of getting the XML skeleton boils down to the following steps:

1. Take a YANG module's `M.yang` jstree (HTML) representation and get the node path (`P`) from the column named `Path`. To make an example: `/state:state/state:users/state:session/state:session-id`;
2. run the `xmlsk.sh` wrapper with the both the node path and the YANG module referenced as follows:

    ```bash
    # using the node path and the model from step 1
    docker run --rm -v $(pwd):/yang hellt/pyang xmlsk.sh "/state:state/state:users/state:session/state:session-id" nokia-state-combined.yang
    ```

3. As a result, you will be presented with an XML skeleton that you can use in your subtree filters.

Under the hood, the following command is executed inside the container:

```
pyang -f sample-xml-skeleton --sample-xml-skeleton-path "/state/users/session/session-id" nokia-state-combined.yang
```
