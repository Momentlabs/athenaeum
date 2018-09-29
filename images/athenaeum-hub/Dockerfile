ARG VERSION=0.9.1
FROM jupyterhub/jupyterhub:${VERSION}
# FROM momentlabs/jupyterhub-k8s-basis

# Configuration installation
ARG CONFIG_PATH=/srv

# Install from the rquirements file
# Use --no-cache?
ADD requirements.txt ${CONFIG_PATH}/requirements.txt
RUN pip install -r ${CONFIG_PATH}/requirements.txt

# Install the local version of Oauthenticator
# USER root
# RUN pip install "oauthenticator>=0.8.1.dev-jdr0" --extra-index-url https://pypi.fury.io/yBaYGxYxSuitsF7y7ppn/momentlabs/
# TODO: Add a release identifier to this.
RUN pip install git+https://github.com/Momentlabs/oauthenticator.git

# This is sometimes useful for debug.
# RUN pip install git+https://github.com/Momentlabs/kubespawner.git@dev-90

# Testing user
# Geocos stops this from asking for finger informaiton.
ARG TEST_USER=jdr
RUN adduser \
    --home /home/${TEST_USER} \
    --force-badname \
    --disabled-password \
    --gecos "test user" \
    ${TEST_USER}

# USER ${NB_USER}
ADD jupyterhub_config.py ${CONFIG_PATH}/jupyterhub_config.py

ENTRYPOINT ["jupyterhub"] 
CMD ["--debug", "--config", "/srv/jupyterhub_config.py"]