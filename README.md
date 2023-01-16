# Docker Container - Domain Router
This docker container allows specifying the forwarding of domains to other domains (e.g. to have a static route between hosts, or to easily include sub-domains). This container is compatible with [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy) architecture.

# Configuration options
## Environment Variables
The following environmental variables can be used for configuration:

 - `ROUTER_<name>`  
    The router definition needs have a unique name and its value needs to follow the following syntax:   
    `<source-domain>(,<source-domain>...) => <URL>`, e.g.: `ROUTER_doe="doe.net,john.doe.net => https://github.com/jdoe/"`
 - `VIRTUAL_HOST` & `LETSENCRYPT_HOST`
    In order to use [`nginx-proxy`](https://github.com/nginx-proxy/nginx-proxy) and [`acme-companion`](https://github.com/nginx-proxy/acme-companion), those need to contain the sources of the previously defined routers. A warning will be printed, if the source is missing. Additionally this string will be printed to the log upon startup.

# docker-compose example
Usage with [`nginx-proxy`](https://github.com/nginx-proxy/nginx-proxy) and [`acme-companion`](https://github.com/nginx-proxy/acme-companion) inside of predefined `steilerGroup` network.

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
      ROUTER_johndoe: "johndoe.net,www.johndoe.net => https://github.com/johndoe"
      ROUTER_janedoe: "janedoe.net => https://github.com/janedoe"
      VIRTUAL_HOST: "johndoe.net,www.johndoe.net,janedoe.net"
      LETSENCRYPT_HOST: "johndoe.net,www.johndoe.net,janedoe.net"
networks:
  default:
    external:
      name: steilerGroup
```