#!/usr/bin/env bash

docker build $PWD -t sarlab/humanoid-sim
docker push airfield20/humanoid:latest