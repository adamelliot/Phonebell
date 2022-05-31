FROM ubuntu:21.04

ENV TZ=America/Vancouver

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y curl python3 python3-pip jq
RUN pip3 install google-api-python-client google-cloud-pubsub libcst==0.3.23

WORKDIR /work
CMD /bin/bash
