FROM docker/dev-environments-default:stable-1

ENV BUILD_DIR=$HOME
WORKDIR $BUILD_DIR

RUN git config --global user.name "PICTC"
RUN git config --global user.email "support@premier-ictc.com"
RUN git clone https://github.com/PREMIER-ICT-CONSULTING/CloudServices.git#main
RUN cd "CloudServices"

VOLUME ["/var/run/docker.sock"]
RUN docker swarm init

RUN docker network create -d overlay public_dmz
RUN docker network create -d overlay agent_network 


RUN docker volume create datastore_portainer 
RUN docker volume create datastore_config 

RUN docker stack deploy --compose-file docker-compose.yaml control-plane

# RUN docker attach -it 