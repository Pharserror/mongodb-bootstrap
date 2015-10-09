FROM ubuntu:trusty
MAINTAINER Pharserror <sunboxnet@gmail.com>
ENV REFRESHED_AT 2015-09-03

# Setup environment
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV RUBY_VERSION 2.2.0

USER root

# Setup User
RUN useradd --home /home/worker -M worker -K UID_MIN=10000 -K GID_MIN=10000 -s /bin/bash
RUN mkdir /home/worker
RUN chown worker:worker /home/worker
RUN adduser worker sudo
RUN echo 'worker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER worker

# Add apt GPG keys for MongoDB
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10

# Create list file for MongoDB repo
RUN echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

# Update apt packages
RUN sudo apt-get update

# Install packages
RUN sudo apt-get install -y git htop ncdu build-essential libssl-dev curl mongodb-org

# Ensure MongoDB is running
RUN sudo service mongod restart

# Create MongoDB database
RUN /bin/bash -l -c "mongo admin --eval \"db.createCollection('evedemo')\""

# db setup
RUN /bin/bash -l -c 'mongo ./mongo-setup.js'
