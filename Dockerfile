
ARG COMMANDBOX_VERSION=3.4.4

##  build
FROM openjdk:11.0.11-slim as api-base
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

# api-dev stage
FROM  ortussolutions/commandbox:${COMMANDBOX_VERSION} as api-dev
COPY api/box.json ./
COPY api/server.json ./
COPY scripts/api-run.sh /opt/run.sh
WORKDIR $APP_DIR
RUN box install \
    && box server start saveSettings=false dryrun=true startScript=bash profile=development \
    && mv ./server-start.sh /opt/startup.sh \
    &&  chmod +x /opt/startup.sh \
    &&  chmod +x /opt/run.sh
EXPOSE 8080
CMD /opt/run.sh

## Dev container
FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:14 as app-devcontainer
# Install dependencies for cypress
RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  libgtk2.0-0 \
  libgtk-3-0 \
  libnotify-dev \
  libgconf-2-4 \
  libgbm-dev \
  libnss3 \
  libxss1 \
  libasound2 \
  libxtst6 \
  xauth \
  xvfb \
  # clean up
  && rm -rf /var/lib/apt/lists/*

RUN sudo -u node npm install -g npm@latest

# Install global packages
RUN sudo -u node npm install -g @vue/cli @vue/cli-service-global

FROM app-devcontainer as app-dev
WORKDIR /workspace/app
# ENV PATH /app/node_modules/.bin:$PATH
COPY app/package*.json ./
RUN sudo npm install
EXPOSE 3000
CMD ["npm", "run", "serve"]



# production build stage
FROM app-devcontainer as app-prod
WORKDIR /workspace/app
COPY ./app .
RUN npm install && npm run build

# production stage
FROM  ortussolutions/commandbox:${COMMANDBOX_VERSION} as api-workbench
WORKDIR /app
COPY ./api ./
COPY scripts/api-run.sh /opt/run.sh
WORKDIR $APP_DIR
RUN box install \
    && box server start saveSettings=false dryrun=true startScript=bash profile=production \
    && mv ./server-start.sh /opt/startup.sh \
    &&  chmod +x /opt/startup.sh \
    &&  chmod +x /opt/run.sh \
    && rm -Rf tests \
    && rm box.json \
    && rm server.json

FROM adoptopenjdk/openjdk11:debianslim-jre as prod

# COPY our generated files
COPY --from=api-workbench /app /app
COPY --from=api-workbench /usr/local/lib/CommandBox/server/serverHome /usr/local/lib/CommandBox/server/serverHome

RUN mkdir -p /usr/local/lib/CommandBox/lib

COPY --from=api-workbench /usr/local/lib/CommandBox/lib/runwar-4.5.2.jar /usr/local/lib/CommandBox/lib/runwar-4.5.2.jar
COPY --from=api-workbench /usr/local/lib/CommandBox/cfml/system/config/urlrewrite.xml /usr/local/lib/CommandBox/cfml/system/config/urlrewrite.xml
COPY --from=api-workbench /opt/startup.sh /opt/startup.sh
COPY --from=api-workbench /opt/run.sh /opt/run.sh

COPY --from=app-prod /workspace/app/dist/assets /app/assets
COPY --from=app-prod /workspace/app/dist/index.html /app/views/main/index.cfm
CMD /opt/run.sh