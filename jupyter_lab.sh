#!/usr/bin/env bash

DIR_PATH=$(pwd)

docker run -it \
    --rm \
    -p 8889:8889 \
    -p 4040-4050:4040-4050 \
    -v $DIR_PATH/code:/home/user/workspace/code \
    -v $DIR_PATH/data:/home/user/workspace/data \
    aisolab/spark-notebook:2.4.7\
    jupyter lab --ip 0.0.0.0 --port 8889