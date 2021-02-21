#!/usr/bin/env bash
PYTHON_VER=3.7.9
SPARK_VER=2.4.7

# Build the image with different arguments
docker build \
    -f Dockerfile \
    -t aisolab/spark-notebook:${SPARK_VER} . \
    --build-arg PYTHON_VER=${PYTHON_VER} \
    --build-arg SPARK_VER=${SPARK_VER}