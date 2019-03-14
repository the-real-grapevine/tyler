FROM node:10
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ENV PATH "node_modules/.bin:node_modules/hubot/node_modules/.bin:${PATH}"
CMD [ "node_modules/.bin/hubot", "--name", "tyler", "--adapter", "slack" ]
