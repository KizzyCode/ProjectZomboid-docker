FROM --platform=amd64 ubuntu:latest

# Setup packages
ENV APT_PACKAGES \
	ca-certificates steamcmd telnet
RUN echo steamcmd steam/license note "" | debconf-set-selections \
	&& echo steamcmd steam/question select "I AGREE" | debconf-set-selections
RUN dpkg --add-architecture i386 \
 	&& apt-get update \
	&& apt-get upgrade --yes \
 	&& apt-get install --yes ${APT_PACKAGES}
 
# Create and become user
RUN groupadd --gid 10000 projectzomboid \
	&& useradd --create-home --uid 10000 --gid projectzomboid projectzomboid
USER projectzomboid
WORKDIR /home/projectzomboid

# Create mountpoints to ensure appropriate permissions
RUN mkdir /home/projectzomboid/app \
	&& mkdir /home/projectzomboid/data

# Create the data mount point to ensure valid permissions and copy and execute the startup script
COPY ./files/start.sh /usr/libexec/projectzomboid-server.sh
ENTRYPOINT [ "/usr/libexec/projectzomboid-server.sh" ]
