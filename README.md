## 👋 Welcome to valkey 🚀  

valkey README  
  
  
## Install my system scripts  

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/systemmgr/installer/raw/main/install.sh")"
 sudo systemmgr --config && sudo systemmgr install scripts  
```
  
## Automatic install/update  
  
```shell
dockermgr update valkey
```
  
## Install and run container
  
```shell
dockerHome="/srv/$USER/docker/casjaysdevdocker/valkey/valkey/latest/rootfs"
mkdir -p "/srv/$USER/docker/valkey/rootfs"
git clone "https://github.com/dockermgr/valkey" "$HOME/.local/share/CasjaysDev/dockermgr/valkey"
cp -Rfva "$HOME/.local/share/CasjaysDev/dockermgr/valkey/rootfs/." "$dockerHome/"
docker run -d \
--restart always \
--privileged \
--name casjaysdevdocker-valkey-latest \
--hostname valkey \
-e TZ=${TIMEZONE:-America/New_York} \
-v "$dockerHome/data:/data:z" \
-v "$dockerHome/config:/config:z" \
-p 80:80 \
casjaysdevdocker/valkey:latest
```
  
## via docker-compose  
  
```yaml
version: "2"
services:
  ProjectName:
    image: casjaysdevdocker/valkey
    container_name: casjaysdevdocker-valkey
    environment:
      - TZ=America/New_York
      - HOSTNAME=valkey
    volumes:
      - "/srv/$USER/docker/casjaysdevdocker/valkey/valkey/latest/rootfs/data:/data:z"
      - "/srv/$USER/docker/casjaysdevdocker/valkey/valkey/latest/rootfs/config:/config:z"
    ports:
      - 80:80
    restart: always
```
  
## Get source files  
  
```shell
dockermgr download src casjaysdevdocker/valkey
```
  
OR
  
```shell
git clone "https://github.com/casjaysdevdocker/valkey" "$HOME/Projects/github/casjaysdevdocker/valkey"
```
  
## Build container  
  
```shell
cd "$HOME/Projects/github/casjaysdevdocker/valkey"
buildx 
```
  
## Authors  
  
🤖 casjay: [Github](https://github.com/casjay) 🤖  
⛵ casjaysdevdocker: [Github](https://github.com/casjaysdevdocker) [Docker](https://hub.docker.com/u/casjaysdevdocker) ⛵  
