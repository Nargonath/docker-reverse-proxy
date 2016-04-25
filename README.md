# docker-reverse-proxy
![Image of docker whale](http://www.nkode.io/img/posts/docker.png)
Dockerfile used to build an apache reverse proxy image with SSL management.

## Instructions
You need to build the image yourself and send the required build-arg : "docker build --build-arg DOMAIN_NAME=myDomain --build-arg PRIVATE_IP=myPrivateIP --build-arg PRIVATE_PORT=myPort -t nargonath/apache-reverse-proxy".

The DOMAIN_NAME variable is used for the virtualhost created by the image.
The PRIVATE_IP is the private ip given to your host machine on the docker bridge network. It is used for the container to contact the host privately.
The PRIVATE_PORT is the port of the container you wish to proxy the HTTP to on the host.

Once you have built the image, you need to run it with : "docker run -d --name myName -p 80:80 -p 443:443 nargonath/apache-reverse-proxy"

The image is present on Docker Hub as well: [https://hub.docker.com/r/nargonath/apache-reverse-proxy/](https://hub.docker.com/r/nargonath/apache-reverse-proxy/)
