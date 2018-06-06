FROM momentlabs/jupyterhub-k8s-basis

# Install the local version of Oauthenticator
USER root
RUN pip install "oauthenticator>=0.8.1.dev-jdr0" --extra-index-url https://pypi.fury.io/yBaYGxYxSuitsF7y7ppn/momentlabs/

USER ${NB_USER}
