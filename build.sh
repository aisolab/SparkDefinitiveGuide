#!/usr/bin/env bash
PYTHON_VER=${1}
SPARK_VER=${2}

# Build the image with different arguments
docker build \
    -f Dockerfile \
    -t aisolab/spark-notebook:${SPARK_VER} . \
    --build-arg PYTHON_VER=${PYTHON_VER} \
    --build-arg SPARK_VER=${SPARK_VER}