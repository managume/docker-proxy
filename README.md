# Proxy reverso para entorno Docker

English README [here](README.en.md)

## Configurar servicio Nginx-Proxy

Verificar que en el ```docker-compose.yml``` tenemos definidas las relaciones de los puertos que usaremos en nuestro entorno Docker.

```yml
ports:
      - "80:80"
      - "3306:3306"
      - "443:443"
      - "8080:8080"
```
## Levantar/Tumbar entorno Docker con Nginx-Proxy

* Editar en la máquina anfitrión el archivo ```/etc/hosts``` añadiendo los VIRTUAL_HOST definidos en los servicios de nuestros proyectos
  * Un ejemplo: ```0.0.0.0      www.blog.local```
* Levantar el docker proxy ejecutando ```sh proxy-start.sh```.
  * Este script crea una red con el nombre ```nginx-proxy``` y levanta un servicio de ```nginx-proxy```
* Tumbar el docker proxy ejecutando ```sh proxy-stop.sh```.

## Configuración de los proyecto para utilizar el Docker Proxy

Para que nuestros proyectos utilicen el nginx-proxy tienen que tener la siguiente configuración:

* Añadir en cada definición de servicios que se quieran detectar con el nginx-proxy las variables de entorno:

```yml
environment:
    VIRTUAL_HOST: www.blog.local
    VIRUTAL_PORT: 80
```
* Añadir la definición de la red a cada servicio.

```yml
networks:
    - nginx-proxy
```

* Si un servicio utiliza alias para la comunicación interna entra contenedores, tendremos que definir la red tal que así.

```yml
networks:
    nginx-proxy:
        aliases:
            - www.blog.local
```

* Añadir la red nginx-proxy al entorno Docker de cada proyecto

```yml
networks:
    nginx-proxy:
    external:
        name: nginx-proxy
```
* Verificar que VirtualHost que utiliza el servidor Apache de cada proyecto utiliza la misma URL que la definida en la variable VIRTUAL_HOST


## Ejemplo de archivo docker-compose.yml optimizado para el uso del nginx-proxy

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