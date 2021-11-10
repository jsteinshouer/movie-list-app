
ARG COMMANDBOX_VERSION=3.4.4

# api-dev stage
FROM  ortussolutions/commandbox:${COMMANDBOX_VERSION} as api-dev
WORKDIR $APP_DIR
COPY api/box.json ./
COPY api/server.json ./
COPY scripts/api/run.sh /usr/local/bin/run.sh
RUN box install \
    && box server start saveSettings=false dryrun=true startScript=bash profile=development \
    && mv ./server-start.sh /usr/local/bin/startup.sh \
    &&  chmod +x /usr/local/bin/startup.sh \
    &&  chmod +x /usr/local/bin/run.sh
EXPOSE 8080
CMD /usr/local/bin/run.sh

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
FROM node:14.18.0-alpine as app-prod
RUN npm install -g npm@latest
#RUN npm install -g @vue/cli @vue/cli-service-global
ENV PATH /app/node_modules/.bin:$PATH
WORKDIR /app
COPY ./app .
RUN npm install && npm run build

# build api server stage
FROM  ortussolutions/commandbox:${COMMANDBOX_VERSION} as api-workbench
WORKDIR /app
COPY ./api ./
COPY scripts/api/run.sh /usr/local/bin/run.sh
WORKDIR $APP_DIR
RUN box install \
    && box server start saveSettings=false dryrun=true startScript=bash profile=production \
    && mv ./server-start.sh /usr/local/bin/startup.sh \
    &&  chmod +x /usr/local/bin/startup.sh \
    &&  chmod +x /usr/local/bin/run.sh

# Production build
FROM adoptopenjdk/openjdk11:ubuntu-jre as prod

COPY --from=api-workbench /app /app
COPY --from=api-workbench /usr/local/lib/CommandBox/server/serverHome /usr/local/lib/CommandBox/server/serverHome

RUN mkdir -p /usr/local/lib/CommandBox/lib \
	&& rm -Rf /app/tests \
    && rm -Rf /app/testbox \
    && rm /app/box.json \
    && rm /app/server.json

COPY --from=api-workbench /usr/local/lib/CommandBox/lib/runwar-4.5.2.jar /usr/local/lib/CommandBox/lib/runwar-4.5.2.jar
COPY --from=api-workbench /usr/local/lib/CommandBox/cfml/system/config/urlrewrite.xml /usr/local/lib/CommandBox/cfml/system/config/urlrewrite.xml
COPY --from=api-workbench /usr/local/bin/startup.sh /usr/local/bin/startup.sh
COPY --from=api-workbench /usr/local/bin/run.sh /usr/local/bin/run.sh

RUN chmod +x /usr/local/bin/startup.sh \
    &&  chmod +x /usr/local/bin/run.sh

COPY --from=app-prod /app/dist/assets /app/assets
COPY --from=app-prod /app/dist/index.html /app/views/main/index.cfm
ENTRYPOINT ["/bin/bash", "/usr/local/bin/run.sh"]
