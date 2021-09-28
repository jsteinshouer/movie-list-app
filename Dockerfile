# base-api build
FROM openjdk:11.0.11-slim as base-api
# Update packages
RUN apt update && apt install -y curl && rm -rf /var/lib/apt/lists/*
# Install CommandBox
RUN mkdir -p /opt \
    && curl --location -o /opt/box https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/5.2.1/box-light \
    && chmod -R a+rx /opt/box \
    && echo "commandbox_home=/opt/.CommandBox" > /opt/commandbox.properties
ENV APP_DIR /app
WORKDIR $APP_DIR
EXPOSE 8080

# Dev container
FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:14 as dev-app
# Install dependencies for cypress
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb
# RUN sudo -u node npm install -g @vue/cli @vue/cli-service-global
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY app/package*.json ./
RUN sudo npm install
EXPOSE 3000
CMD ["npm", "run", "serve"]

# Used for testing
# FROM node:14.17.3-alpine as test-app
# WORKDIR /app
# ENV PATH /app/node_modules/.bin:$PATH
# COPY app/package*.json ./
# RUN npm install
# EXPOSE 3000
# CMD ["npm", "run", "serve"]

# production build stage
FROM node:14.17.3-alpine as build-prod
WORKDIR /app
COPY ./app .
RUN npm install && npm run build

# dev-api stage
FROM base-api as dev-api
COPY api/box.json ./
COPY scripts/api-run.sh /opt/run.sh
RUN /opt/box install \
    && /opt/box server start cfengine=lucee@5.3.7 port=8080 saveSettings=false host=0.0.0.0 trayEnable=false openbrowser=false rewritesEnable=true console=true dryrun=true startScript=bash profile=development \
    && mv ./server-start.sh /opt/startup.sh \
    &&  chmod +x /opt/startup.sh \
    &&  chmod +x /opt/run.sh
CMD /opt/run.sh

# production stage
FROM base-api as prod
COPY ./api ./
COPY scripts/api-run.sh /opt/run.sh
RUN /opt/box install --production \
    && /opt/box server start cfengine=lucee@5.3.7 port=8080 saveSettings=false host=0.0.0.0 trayEnable=false openbrowser=false rewritesEnable=true console=true dryrun=true startScript=bash profile=production \
    && mv ./server-start.sh /opt/startup.sh \
    &&  chmod +x /opt/startup.sh \
    &&  chmod +x /opt/run.sh \
    && rm -Rf tests 
COPY --from=build-prod /app/dist/assets /app/assets
COPY --from=build-prod /app/dist/index.html /app/views/main/index.cfm
CMD /opt/run.sh