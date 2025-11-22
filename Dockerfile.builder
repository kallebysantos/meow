FROM node 

WORKDIR builder

COPY ./scripts/alpine-make-rootfs .
COPY ./scripts/create.sh .

RUN apt update -y
RUN apt install -y sudo

ENTRYPOINT ["/builder/create.sh"]
