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

 - `/opt/domain-router/domains.env`  
    This file will be written by the container, in order to provide the correct `nginx-proxy` and `acme-companion` environmental variables, in order to respond to the defined domains. This file needs to be created before starting the server (otherwise a folder is created).  
    This file needs to be included in the `docker run --env-file` command, or `docker-compose.yml` (see below).

# docker-compose example
Usage with [`nginx-proxy`](https://github.com/nginx-proxy/nginx-proxy) and [`acme-companion`](https://github.com/nginx-proxy/acme-companion) inside of predefined `steilerGroup` network.

After altering the router definitions, two `up` commands are required, because the environment variables are updated and only reloaded if docker-compose updates the container. Therefore using the following should work well:
```
docker-compose up && docker-compose up -d
```

```
version: '2'
services:
  router:
    image: steilerdev/domain-router:latest
    container_name: domain-router
    restart: no
    env_file:
      - ./volumes/domains.env
    environment:
      ROUTER_johndoe: "johndoe.net;www.johndoe.net => https://github.com/johndoe"
      ROUTER_janedoe: "janedoe.net => https://github.com/janedoe"
    volumes:
      - /opt/docker/domain-router/volumes/domains.env:/opt/domain-router/domains.env
networks:
  default:
    external:
      name: steilerGroup
```