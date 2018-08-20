ARG VERSION=0.9.1
FROM jupyterhub/jupyterhub:${VERSION}
# FROM momentlabs/jupyterhub-k8s-basis

# Configuration installation
ARG INSTALL_PATH=/srv/jupyterhub

# Install from the rquirements file
# Use --no-cache?
ADD requirements.txt $}/requirements.txt
pip3 install -r ${INTSALL_PATH}/requirements.txt

# Install the local version of Oauthenticator
# USER root
# RUN pip install "oauthenticator>=0.8.1.dev-jdr0" --extra-index-url https://pypi.fury.io/yBaYGxYxSuitsF7y7ppn/momentlabs/

# USER ${NB_USER}

ADD jupyterhub_config.py ${INSTALL_PATH}/jupyterhub_config.py

ENTRYPOINT ["jupyterhub"] 
CMD ["--debug", "--config", "/srv/jupyterhub/jupyterhub_config.py"]