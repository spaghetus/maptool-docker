FROM ubuntu:focal

# Set the desired version of MapTool
ARG VERSION=1.9.3

# Install some dependencies
RUN apt-get update && \
	apt-get install -y wget gnupg && \
	rm -rf /var/lib/apt/lists

# Download the MapTool package and the xpra package repository.
RUN wget -q https://xpra.org/gpg.asc && \
	apt-key add gpg.asc && \
	echo "deb https://xpra.org/ focal main" > /etc/apt/sources.list.d/xpra.list && \
	wget -q https://github.com/RPTools/maptool/releases/download/$VERSION/maptool_$VERSION-amd64.deb && \
	rm -rf /var/lib/apt/lists

# Work around issues with xdg-desktop-menu
COPY xdg-desktop-menu /usr/bin/xdg-desktop-menu
RUN mkdir /usr/share/desktop-directories

# Install maptool and xpra
RUN apt-get update && \
	apt-get install -y --no-install-recommends --no-install-suggests xpra ./maptool*.deb && \
	rm -rf /var/lib/apt/lists

# Install codecs
RUN apt-get update && \
	apt-get install -y ubuntu-restricted-extras ffmpeg && \
	rm -rf /var/lib/apt/lists

# Install ssh server
RUN apt-get update && \
	apt-get install -y openssh-server && \
	rm -rf /var/lib/apt/lists

# Set the password
RUN echo 'root:password-gaming' | chpasswd

# Create necessary dirs and variables
RUN mkdir /tmp/maptool
ENV XDG_RUNTIME_DIR=/tmp/maptool

# Allow root SSH
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Install the startup script
COPY init.sh /usr/bin/init-mt
CMD init-mt