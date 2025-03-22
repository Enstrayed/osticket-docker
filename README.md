# osTicket AIO Docker Container
Serves [osTicket](https://osticket.com/) using Caddy, php-fpm and MySQL in one container. It uses Alpine as its base and utilizes Busybox for daemon management. 

## Setup
Caddy is configured to serve the osTicket root on port 8080 and all persistent data (osTicket's configuration, plugin folder, and MySQL's data directory) is stored at `/data`. If the container is not started with a volume at `/data` it will break. 

Once the container is running, accessing it from wherever should take you through the osTicket installer. **When prompted for database information, use the following:**
* Host: `localhost` (Should be the default)
* Prefix: (Leave unchanged)
* Database: `osticket`
* Username: `root`
* Password: `securepassword` 

## Networking
The included compose file puts the container in a network called `caddy` as its expected a reverse proxy will handle HTTPS. Once the container is up you should simply be able to add
```
https://helpdesk.yourdomain.com {
    reverse_proxy * osticket:8080
}
```
to your primary Caddyfile and be set. If you want the container's Caddy to handle everything directly for some reason, you'll need to change the following:
1. Change line 5 in `Caddyfile` to your domain instead of :8080.
3. Change line 25 in `Dockerfile` to `EXPOSE 80 443`.
3. Change `docker-compose.yml` to expose ports `80` and `443` on the container.

## Security Considerations
This container is essentially a walled garden, the idea is that you shouldn't have to expose/access anything other than port 8080. Thus the extremely insecure credentials and permissions inside the container are theoretically irrelevant as they wouldn't be accessed by anything outside the container. However, this is still a really bad idea and it would be a much better idea to actually try and least-privilege the processes running inside the container (especially php). 

## License
I don't think there's much copyright vested in me since this repository is basically just configuration files, but for good measure the files in this repository are licensed under the MIT License.