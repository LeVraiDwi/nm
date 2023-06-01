#!bin/sh

cd docker
docker stop $(docker container ls -q)
docker image rm $(docker image ls -q)
docker container rm $(docker container ls -q)
docker container rm $(docker container ls -q)
docker image prune
docker container prune

docker build -t nm_latest .

docker run -it --name nm_container -v `pwd`/..:/Shared nm_latest