# Downloading even stable version

FROM node:20-alpine

# Set the working directory
WORKDIR /backend

# Copy package.json and package-lock.json
COPY package*.json /backend/
COPY yarn.lock /backend/


# Install dependencies
RUN yarn install

# Copy the rest of the application
COPY . .

# Expose the backend port
EXPOSE 3000

# Command to run the backend
CMD yarn migrate; \
        yarn start
	
