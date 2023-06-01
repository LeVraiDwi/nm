From alpine

RUN apt-get update && \
	apt-get install -y vim git man-db bc propcs \
	libelf-dev \ 
	build-essential valgring && \
	rm -rf /var/lib/apt/lists/*

VOLUME /Shared

WORKDIR /Shared

COPY /mnt/nfs/homes/tcosse/nm ./

