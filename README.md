# Phonebell

Phonebell is a simple service that subscribes to the Nest Device access on google cloud to recieve door bell messages and send them to the old timey phone in my house.

The service works in two parts. The first part will keep the authentication key alive by hitting the device list end point every 30 mintues keeping the token active and the accoutn active. The second service subscribes to the Gcloud pub/sub service to recieve events then toggle some GPIO on a RPi which will turn the ringer on and off.

## Usage

Project lives on GCloud: 

## Starting Docker Container

To run the door bell simply run the command `listen`. This will load a docker container and connect to the pub/sub service.  If it's on a RPi it will also fire GPIO.

Getting a token at the outset requires Authorization (see more in the Authorization), but you can start the process here:
```
service/gcloud-authorize.sh authorize
```

Refreshing tokens can be run in a loop with:
```
service/gcloud-authorize.sh refresh-loop
```

## Authorization

To get everything up and running you need to enable device access from the Device Access Console the setup the project.

- [Console](https://console.nest.google.com/device-access)
- [Token Generation](https://developers.google.com/nest/device-access/authorize)


## Libraries

The project uses the Google Device Access API:

- https://developers.google.com/nest/device-access/api/libraries#python


