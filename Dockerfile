FROM docker/dev-environments-default:stable-1

ENV BUILD_DIR=$HOME
WORKDIR $BUILD_DIR

RUN git config --global user.name "PICTC"
RUN git config --global user.email "support@premier-ictc.com"

RUN git clone https://github.com/PREMIER-ICT-CONSULTING/CloudServices.git
RUN cd "CloudServices"
