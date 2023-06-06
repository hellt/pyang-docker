# usage
# build the image
## bash build.sh 2.2.1
# build the image and tag it also as latest
## bash build.sh 2.2.1 latest
PYANG_VER="$1"

PKG_TAG=ghcr.io/hellt/pyang
PYPY_TAG=${PKG_TAG}:pypy
ALPINE_TAG=${PKG_TAG}:alpine
LATEST_TAG=${PKG_TAG}:latest
VERSION_TAG=${PKG_TAG}:${PYANG_VER}
PYPY_VER_TAG=${PKG_TAG}:${PYANG_VER}-pypy
ALPINE_VER_TAG=${PKG_TAG}:${PYANG_VER}-alpine

# PyPy
docker build --build-arg PYANG_VER=${PYANG_VER} -t ${VERSION_TAG} -t ${PYPY_VER_TAG} -t ${PYPY_TAG} -t ${LATEST_TAG} -f pypy.Dockerfile .

# Alpine
docker build --build-arg PYANG_VER=${PYANG_VER} -t ${ALPINE_VER_TAG} -t ${ALPINE_TAG} -f alpine.Dockerfile .

# push to ghcr
# docker push --all-tags ghcr.io/hellt/pyang

# if [ "$2" == "latest" ]; then
#     docker tag hellt/pyang:$PYANG_VER hellt/pyang:latest
#     docker push hellt/pyang:latest
# fi
