FROM postgres:latest

# Define arguments for username, password, and database name
ARG POSTGRES_USER=myuser
ARG POSTGRES_PASSWORD=mypassword
ARG POSTGRES_DB=mydatabase

# Set environment variables
ENV POSTGRES_USER=$POSTGRES_USER
ENV POSTGRES_PASSWORD=$POSTGRES_PASSWORD
ENV POSTGRES_DB=$POSTGRES_DB

# Expose the PostgreSQL port
EXPOSE 5432

# Manually create the initialization directory
RUN mkdir -p /docker-entrypoint-initdb.d

# Copy SQL script to create table
COPY init.sql /docker-entrypoint-initdb.d/

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
