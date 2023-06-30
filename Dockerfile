FROM docker/dev-environments-default:stable-1

ENV BUILD_DIR=$HOME
WORKDIR $BUILD_DIR

RUN git config user.name "PICTC"
RUN git config user.email "support@premier-ictc.com"
RUN git clone https://github.com/PREMIER-ICT-CONSULTING/CloudServices.git
RUN cd "CloudServices"

RUN dockker swarm init

RUN docker network create -d overlay public_dmz
RUN docker network create -d overlay agent_network 


RUN docker volume create datastore_portainer 
RUN docker volume create datastore_config 

RUN docker stack deploy --compose-file docker-compose.yaml control-plane

# RUN docker attach -it 