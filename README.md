# Docker Container - Domain Router
This docker container allows specifying the forwarding of domains to other domains (e.g. to have a static route between hosts, or to easily include sub-domains).

# Configuration options
## Environment Variables
The following environmental variables can be used for configuration:

 - `ROUTER_<name>`  
    The router definition needs have a unique name and its value needs to follow the following syntax:   
    `<source-domain>(;<source-domain>...) => <URL>`, e.g.: `ROUTER_doe="doe.net;john.doe.net => https://github.com/jdoe/"`

## Volume Mounts
The following mount, in combination with referencing the environmental file is essential in order to spin the container up
The following paths are recommended for persisting state and/or accessing configurations

 - `/some-path/` 
    Description on usage

# docker-compose example
Usage with `nginx-proxy` inside of predefined `steilerGroup` network.

```
version: '2'
services:
  <service-name>:
    image: steilerdev/<pkg-name>:latest
    container_name: <docker-name>
    restart: unless-stopped
    hostname: "<hostname>"
    environment:
      VAR: "value"
    volumes:
      - /<some-host-path>:/<some-docker-path>
networks:
  default:
    external:
      name: steilerGroup
```