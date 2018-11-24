# Google Assistant Webserver

There are a lot of things the Google Home devices can do that are just not possible to do without one. The example that led me to create this repo was playing spotify music on a chromecast. There are no API's to do this, but my google home can do it. 

This repo creates a virtual google home device inside a docker container that you can interact with via REST calls. 

## Getting started

You will need to create a new Actions on Google project [here](https://console.actions.google.com) (Just give your project a name and click ok) and then skip any additional steps until you get to the overview page. 

Once your project is created, change `overview` in the url to `deviceregistration` and follow the instructions [here](https://developers.google.com/assistant/sdk/guides/library/python/embed/register-device) to create a new device.
Be sure to download the OAuth credentials for later.

You will need to take note at this point of the following two pieces of information from the Actions on Google console: 
+ The project-id found in the URL `(.../project/[project-id]/...)`
+ The device model id you just created (it will be visible on the deviceregistration page).

On a machine with python installed, follow [these instructions](https://developers.google.com/assistant/sdk/guides/library/python/embed/install-sample#generate_credentials) to generate a credentials.json file using the OAuth credentials you created in the previous step. 

You should now have all the info you need to run the docker image

## Running the project

On a machine with docker (and docker-compose) installed, run create the following docker-compose.yaml file

``` yaml
version : '3'

services:
  google_assistant:
    container_name: gassist
    restart: unless-stopped
    image: winterscar/GoogleAssistantWebserver
    environment:
      - PROJECT_ID="<your project id here>"
      - DEVICE_MODEL_ID="<your device model id here>"
    volumes:
      - ~/googleassistant:/google-assistant
    ports:
      - "5000:5000"
    devices:
      - "/dev/snd:/dev/snd"
```

Be sure to change `PROJECT_ID` and `DEVICE_MODEL_ID` to match the values you collected earlier. You will also need to create a folder under `~/googleassistant` and add the credentials.json file generated previously.

Finally, run docker-compose up -d to start the assistant.

## Using the assistant

The webserver listens to two paths:
`0.0.0.0:5000/command` and `0.0.0.0:5000/broadcast_message`. At each of these addresses, it will pull the `message` parameter from the url and feed it into the virtual google assistant device. 

### Examples:
_turn off the lights_
`curl 0.0.0.0:5000/command?message=turn%20off%20the%20lights`

_broadcast "Hello world"_
`curl 0.0.0.0:5000/broadcast_message?message=hello%20world`

If you tried that last one, you might have noticed that nothing happened. This is because you need to make sure that your virtual google home device and any real ones you want to broadcast on have the same address. You can do this from the google home app under 

`Account > settings > Assistant tab > (under assistant devices, click your newly created device) > Device address`

## Acknowledgements

All the code for this project was written by @chocomega and @andBobsYourUncle from the Home Assistant forums. You can see the original post that inspired me to create this [here.](https://community.home-assistant.io/t/community-hass-io-add-on-google-assistant-webserver-broadcast-messages-without-interrupting-music/37274/234)
