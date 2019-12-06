FROM alpine:3.9

# Labels
LABEL maintainer="dodin.roman@gmail.com" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date= \
    org.label-schema.vcs-ref= \
    org.label-schema.name="hellt/pyang-docker" \
    org.label-schema.description="PYANG inside Docker" \
    org.label-schema.url="https://github.com/hellt/pyang-docker" \
    org.label-schema.vcs-url="https://github.com/hellt/pyang-docker" \
    org.label-schema.vendor="Roman Dodin" \
    org.label-schema.docker.cmd="docker run --rm -it -v $(pwd)/yang_models:/yang hellt/pyang -f tree mymodel.yang"

RUN apk --no-cache add \
    python3 \
    py-pip && \

    apk --no-cache add --virtual build-dependencies \
    python3-dev \
    python-dev \
    libxml2-dev \
    libxslt-dev \
    build-base && \

    pip3 install --upgrade pip && \
    pip3 install --upgrade pyang==2.1 && \

    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

WORKDIR /yang
