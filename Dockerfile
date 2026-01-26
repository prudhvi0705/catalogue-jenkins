FROM node:20.19.6-alpine3.21 AS build
WORKDIR /opt/server/
COPY package.json .
COPY server.js .
RUN npm install

FROM node:20.19.6-alpine3.21 
WORKDIR /opt/server/
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop && \
    chown -R roboshop:roboshop /opt/server
EXPOSE 8080
LABEL com.project="roboshop" \
      component="catalogue" \
      created_by="sivakumar"
ENV MONGO=true \
    MONGO_URL="mongodb://mongodb:27017/catalogue"
COPY --from=build --chown=roboshop:roboshop /opt/server /opt/server
USER roboshop
CMD ["server.js"]
ENTRYPOINT [ "node" ]

# FROM node:20
# WORKDIR /opt/server/
# COPY package.json .
# COPY server.js .
# RUN npm install
# ENV MONGO=true
# ENV MONGO_URL="mongodb://mongodb:27017/catalogue"
# CMD ["node", "server.js"]