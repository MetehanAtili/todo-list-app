#!/bin/bash

# if container is running, stop it
if [ $(docker ps -q -f name=todo-list-app) ]; then
    docker stop todo-list-app
fi

# if container exists, remove it
if [ $(docker ps -aq -f name=todo-list-app) ]; then
    docker rm todo-list-app
fi

# create dockerfile
cat > Dockerfile <<EOF
FROM node:10-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy both package.json and package-lock.json
COPY package*.json ./

# Install app dependencies
# RUN npm install
# For production use
RUN npm ci --only=production

# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "node", "app.js" ]
EOF


# build the container
docker build -t thoba/todo-list-app .

# run the container
docker run -d -p 8080:8080 thoba/todo-list-app

