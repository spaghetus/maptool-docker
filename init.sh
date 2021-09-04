#!/bin/bash
service ssh restart
xpra start --start-new-commands=yes \
	--udp-auth=allow \
	--daemon=no \
	--encoding=h264 \
	--start=/opt/maptool/bin/MapTool
