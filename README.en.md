# Reverse proxy for Docker

## Config Nginx-Proxy service

Verify all ports definitions you are going to use are in the ```docker-compose.yml```.

```yml
ports:
      - "80:80"
      - "3306:3306"
      - "443:443"
      - "8080:8080"
```
## Up/Down Nginx-Proxy docker compose

* Edit host machine ```/etc/hosts``` file adding all VIRTUAL_HOST defined in each service of your docker compose files.
  * An example: ```0.0.0.0      www.blog.local```
* Up Nginx-Proxy executing ```sh proxy-start.sh```.
  * That script will create a docker network called ```nginx-proxy``` and build the ```nginx-proxy``` service.
* Down Nginx-Proxy with ```sh proxy-stop.sh```.

## Config projects to use nginx-proxy

All docker compose projects use nginx-proxy have to follow next steps:

* Add nginx-proxy env variables to each service:

```yml
environment:
    VIRTUAL_HOST: www.blog.local
    VIRUTAL_PORT: 80
```
* Add nginx-proxy network definition to each service:

```yml
networks:
    - nginx-proxy
```

* If you want to use aliases to internal communication between containers add this instead previous one:

```yml
networks:
    nginx-proxy:
        aliases:
            - www.blog.local
```

* Add nginx-proxy network definition to global configuration.

```yml
networks:
    nginx-proxy:
    external:
        name: nginx-proxy
```
* Verify your Apache virtual host use same URL you declared in VIRTUAL_HOST variable.


## An example of an optimized docker-compose.yml for nginx-proxy use.

```yml

version: '3'

services:
    db:
        container_name: database
        image: mysql:5.6
        environment:
            MYSQL_ROOT_PASSWORD: root
            VIRTUAL_HOST: db.blog.local
            VIRTUAL_PORT: 3306
        networks:
            nginx-proxy:
                aliases: db.blog.local
    wordpress:
        container_name: wordpress
        image: wordpress:latest
        environment:
            VIRTUAL_HOST: www.blog.local
            VIRUTAL_PORT: 80
        networks:
            - nginx-proxy
networks:
    nginx-proxy:
        external:
            name: nginx-proxy
```
