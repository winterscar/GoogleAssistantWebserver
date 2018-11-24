FROM ubuntu:bionic


# Common directory
VOLUME /google-assistant
ADD hotword_webserver.py /server/

# Set locales
ENV \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8

# Install Google Asisstant SDK and Dependencies
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
    python3-dev python3-venv portaudio19-dev libffi-dev libssl-dev libmpg123-dev
RUN python3 -m venv env
RUN env/bin/python -m pip install --upgrade pip setuptools wheel
#RUN source env/bin/activate
RUN /env/bin/python -m pip install --upgrade google-assistant-library
RUN /env/bin/python -m pip install --upgrade google-assistant-sdk[samples]

# Install flask for the WebServer
RUN /env/bin/python -m pip install --upgrade flask flask-restful

# Run the web server
CMD . /env/bin/activate &&\
    /env/bin/python /server/hotword_webserver.py\
     --credentials /google-assistant/credentials.json\
     --device-config /google-assistant/device_config_library.json\
     --project-id $PROJECT_ID\
     --device-model-id $DEVICE_MODEL_ID\
