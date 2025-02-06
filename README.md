[![Docker Pulls](https://img.shields.io/docker/pulls/norsknoobing/psgallery-module-downloads?style=flat-square&logo=docker)](https://hub.docker.com/r/norsknoobing/psgallery-module-downloads) [![GitHub repo](https://img.shields.io/badge/GitHub%20repo-gray?style=flat-square&logo=github)](https://github.com/NorskNoobing/psgallery-module-downloads)


# Prerequisites
* An InfluxDB install.

# Dependencies
1. Create a new InfluxDB bucket.
2. Create an api token in InfluxDB with `WRITE` access to your newly made bucket.

# Setup and installation
You can run the image either by using `docker run` or `docker compose`.
## Docker compose
1. Put this inside the `docker-compose.yml` file.
```yml
version: '3'
services:
  psgallery-module-downloads:
    container_name: psgallery-module-downloads
    image: norsknoobing/psgallery-module-downloads:latest
    environment:
      - PSGALLERY_PROFILE_NAME=
      - INFLUX_HOST=
      - INFLUX_BUCKET=
      - INFLUX_ORG=
      - INFLUX_TOKEN=
```
2. Add all your ENV_VARS values after each equals sign.
3. Run the container by using `docker compose up -d` in the directory where your `docker-compose.yml` file is located.
# Environmental variables
|Variable|Description|Required|
|---|---|:-:|
|PSGALLERY_PROFILE_NAME|The username of your PSGallery profile.|✔|
|INFLUX_HOST|The hostname of your InfluxDB installation, including the port if applicable. I.e. `192.168.86.10:8086`, `https://influxdb.example.com`, or `http://influxdb:8086`. It's important that you add the protocol when using a hostname, like in the last example.|✔|
|INFLUX_BUCKET|The name of the InfluxDB bucket that the script should use.|✔|
|INFLUX_ORG|The name or ID of your InfluxDB org.|✔|
|INFLUX_TOKEN|An InfluxDB API token that has `WRITE` access to the bucket that you specified.|✔|
