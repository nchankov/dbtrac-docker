FROM nginx:1.27.2

LABEL author="nik@chankov.net"

# Install the necessary packages
RUN apt-get update && apt-get install -y default-mysql-client
RUN apt-get update && apt-get install -y telnet
RUN apt-get update && apt install -y sqlite3
RUN apt-get update && apt-get install -y php-cli
RUN apt-get update && apt-get install -y php-curl
RUN apt-get update && apt-get install -y php-mysqli php-pdo
RUN apt-get update && apt-get install -y php*-mysql 
RUN apt-get update && apt-get install -y php*-sqlite
RUN apt-get update && apt-get install -y openssh-client
RUN apt-get update && apt-get install -y rsync

# Create the stream conf directory for nginx
RUN mkdir /etc/nginx/stram.conf.d
# Copy the initial file in the directory
COPY ./dbtrac.conf /etc/nginx/stream.conf.d/

# Update nginx configuration file
RUN echo "include /etc/nginx/stream.conf.d/*.conf;" >> /etc/nginx/nginx.conf

# create the root directory
RUN mkdir /dbtrac
# Create RW and RO files
RUN mkdir /etc/nginx/snippets
RUN touch /etc/nginx/source.servers
RUN touch /etc/nginx/replica.servers
RUN echo "server localhost:3306;" >> /etc/nginx/snippets/source.servers
RUN echo "server localhost:3306;" >> /etc/nginx/snippets/replica.servers

# Create shortcut commands
RUN ln -s /usr/local/lib/dbtrac/bin/add.sh /add
RUN ln -s /usr/local/lib/dbtrac/bin/remove.sh /remove
RUN ln -s /usr/local/lib/dbtrac/bin/change.sh /change
RUN ln -s /usr/local/lib/dbtrac/bin/monitor.sh /monitor
RUN ln -s /usr/local/lib/dbtrac/bin/status.sh /status

COPY ./dbtrac.conf /etc/nginx/stream.conf.d/
COPY ./35-dbtrac-monitor.sh /docker-entrypoint.d/