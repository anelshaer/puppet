FROM centos:7
MAINTAINER Ahmed Elshaer

# Create FleetDM group and user
RUN addgroup -S fleet && adduser -S fleet -G fleet
RUN mkdir /fleet/ && cd /fleet/
ADD https://github.com/fleetdm/fleet/releases/download/3.8.0/fleet.zip .
RUN unzip fleet.zip && mv linux/fleet* /usr/bin/ && cd ~ && rm -rf /fleet/

USER fleet
CMD ["fleet", "serve"]
