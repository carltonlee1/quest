FROM node:16-alpine
WORKDIR /usr/src/app
COPY . /usr/src/app
ENV SECRET_WORD=shhhh
RUN npm install
COPY . .
CMD "npm" "start"