FROM maven:latest

# Install MySQL server and git
RUN apt update -y && \
    apt full-upgrade -y && \
    apt install -y mysql-server git && \
    rm -rf /var/lib/apt/lists/*

# Copy init SQL script
COPY init.sql /init.sql

# Clone and build SQLancer
RUN git clone https://github.com/sqlancer/sqlancer && \
    sed -i 's/mysql:8.0.36/mysql:8.0.41/g' sqlancer/.github/workflows/main.yml && \
    cd sqlancer && \
    mvn package -DskipTests

# Expose MySQL port if needed
EXPOSE 3306

# Start MySQL and apply init script
CMD service mysql start && \
    sleep 5 && \
    mysql < /init.sql && \
    bash
