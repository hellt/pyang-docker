#!/bin/sh

# a wrapper for pyang sample-xml-skeleton output format that removes the prefix in the model path
MODEL_PATH="$1"
MODEL="$2"

if [ -z "$MODEL_PATH" ]; then
    echo "Model path should be provided as a first argument. Model path can be obtained from the jstree output"
    echo "usage: xmlsk.sh <model_path> <model>"
    exit 1
fi

if [ -z "$MODEL" ]; then
    echo "Model file should be provided as a second argument."
    echo "usage: xmlsk.sh <model_path> <model>"
    exit 1
fi

PREFIX=$(echo $MODEL_PATH | cut -d ":" -f 1 | cut -d "/" -f 2)

NORMALIZED_PATH=$(echo $MODEL_PATH | sed -e "s/$PREFIX://g")

pyang -f sample-xml-skeleton --sample-xml-skeleton-path ${NORMALIZED_PATH} ${MODEL}
