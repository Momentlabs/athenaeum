FROM jupyterhub/jupyterhub
# FROM ubuntu:17.10

# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
#       git \
#       python3 \
#       python3-dev \
#       python3-pip \
#       python3-setuptools \
#       libcurl4-openssl-dev \
#       libssl-dev \
#       build-essential \
#       && \
#     apt-get purge && apt-get clean

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      file \
      vim

ARG NB_USER=jovyan
ARG NB_UID=1000
ARG HOME=/home/jovyan

ENV LANG C.UTF-8

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    --home ${HOME} \
    --force-badname \
    ${NB_USER}

ARG JUPYTERHUB_VERSION=0.8.*

# ADD requirements.txt /tmp/requirements.txt
# RUN pip3 install --no-cache-dir \
#          jupyterhub==${JUPYTERHUB_VERSION} \
#          -r /tmp/requirements.txt

# The base jupyterhub image uses conda for install. 
# pip rather than pip3 is what works here.
ADD requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir \
         -r /tmp/requirements.txt

# Install the local version of Oauthenticator
RUN pip install "oauthenticator>=0.8.1.dev-jdr0" --extra-index-url https://pypi.fury.io/yBaYGxYxSuitsF7y7ppn/momentlabs/

ADD jupyterhub_config.py /srv/jupyterhub_config.py

# ADD z2jh.py /usr/local/lib/python3.6/dist-packages/z2jh.py
ADD z2jh.py /opt/conda/lib/python3.5/site-packages/z2jh.py
ADD cull_idle_servers.py /usr/local/bin/cull_idle_servers.py
# ADD cull_idle_servers.py /opt/conda/bin/cull_idle_servers.py

WORKDIR /srv/jupyterhub
ADD start.sh /srv/jupyterhub/start.sh
RUN chmod a+twx ./start.sh

# So we can actually write a db file here
RUN chown ${NB_USER}:${NB_USER} /srv/jupyterhub

# JupyterHub API port
EXPOSE 8081

USER ${NB_USER}
# CMD ["jupyterhub", "--config", "/srv/jupyterhub_config.py"]
# Bogus I know.
ENV CMD jupyterhub --config "/srv/jupyterhub_config.py"
CMD ./start.sh