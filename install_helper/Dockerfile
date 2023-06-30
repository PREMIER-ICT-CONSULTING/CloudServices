FROM docker/dev-environments-default:stable-1
ENV BUILD_DIR=$HOME
WORKDIR $BUILD_DIR
RUN git clone https://github.com/PREMIER-ICT-CONSULTING/CloudServices.git
RUN cd "CloudServices"
RUN docker-compose "up -d"
