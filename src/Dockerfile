FROM registry.angstrom.co.th:8443/baseimage-node8.9.4

COPY package.json package-lock.json /
RUN npm install 

COPY app.coffee /app.coffee
COPY holidays.csv /holidays.csv
