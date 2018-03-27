FROM node:carbon

# Create app directory
WORKDIR /code

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)

COPY package.json /code
COPY server.js /code

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY . /code

CMD [ "npm", "start" ]