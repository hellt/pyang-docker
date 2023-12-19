FROM curlimages/curl:8.1.1 as oc-plugin

WORKDIR /work

RUN curl -LO https://github.com/openconfig/oc-pyang/archive/refs/heads/master.tar.gz && tar -zxvf master.tar.gz

FROM pypy:3.10-slim

LABEL maintainer="dodin.roman@gmail.com" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name="hellt/pyang-docker" \
    org.label-schema.description="PYANG inside Docker" \
    org.label-schema.url="https://github.com/hellt/pyang-docker" \
    org.label-schema.vcs-url="https://github.com/hellt/pyang-docker" \
    org.label-schema.vendor="Roman Dodin" \
    org.label-schema.docker.cmd="docker run --rm -it -v $(pwd)/yang_models:/yang ghcr.io/hellt/pyang -f tree mymodel.yang"

# copy openconfig pyang plugin dir
COPY --from=oc-plugin /work/oc-pyang-master/openconfig_pyang/plugins/ /opt/pyang-oc-plugin

ARG PYANG_VER
RUN pip install pyang==${PYANG_VER} six jinja2

COPY xmlsk.sh /usr/local/bin/

WORKDIR /yang
