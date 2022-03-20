# Docker Container - Domain Router
This docker container allows specifying the forwarding of domains to other domains (e.g. to have a static route between hosts, or to easily include sub-domains).

# Configuration options
## Environment Variables
The following environmental variables can be used for configuration:

 - `VAR`  
    Description for var  
    Accepted options

## Volume Mounts
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