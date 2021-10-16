FROM alpine:3.9 as builder

RUN apk --no-cache add \
    python3 \
    curl \
    # build deps
    python3-dev \
    python-dev \
    libxml2-dev \
    libxslt-dev \
    build-base && \
    # pyang
    pip3 install --upgrade pip pyang==2.5.0 && \
    find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf && \
    find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

# install pyang plugin from openconfig
RUN mkdir ./oc-plugin && curl -LO https://github.com/openconfig/oc-pyang/archive/refs/heads/master.tar.gz && tar -zxvf master.tar.gz -C ./oc-plugin

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
    org.label-schema.docker.cmd="docker run --rm -it -v $(pwd)/yang_models:/yang ghcr.io/hellt/pyang -f tree mymodel.yang"

RUN apk --no-cache add \
    python3 &&\
    # six and jinja2 are required by oc-pyang plugin
    pip3 install --upgrade pip six jinja2 && \
    # cleanup
    find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf && \
    find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

COPY --from=builder /usr/lib/libx*.* /usr/lib/
COPY --from=builder /usr/lib/libexslt.so.0 /usr/lib/
COPY --from=builder /usr/lib/libgcrypt.so.20 /usr/lib/
COPY --from=builder /usr/lib/libgpg-error.so.0 /usr/lib/

COPY --from=builder /usr/lib/python3.6/site-packages/ /usr/lib/python3.6/site-packages/
COPY --from=builder /usr/bin/pyang /usr/bin/pyang
COPY --from=builder /usr/bin/json2xml /usr/bin/json2xml
COPY --from=builder /usr/bin/yang2dsdl /usr/bin/yang2dsdl
COPY --from=builder /usr/bin/yang2html /usr/bin/yang2html

# copy openconfig pyang plugin dir
COPY --from=builder oc-plugin/oc-pyang-master/openconfig_pyang/plugins/ /opt/pyang-oc-plugin

COPY xmlsk.sh /usr/local/bin/

WORKDIR /yang
