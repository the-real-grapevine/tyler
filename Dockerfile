FROM node:lts
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
CMD [ "./bin/hubot", "--adapter", "slack" ]
