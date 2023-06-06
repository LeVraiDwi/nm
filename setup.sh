#!bin/sh

cd docker

docker build -t nm_latest .

docker run -it --name nm_container -v `pwd`/..:/Shared nm_latest