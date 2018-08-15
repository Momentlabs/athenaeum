ARG VERSION=3.6.3
FROM python:${VERSION}

WORKDIR /srv/test

# install nodejs.
RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# Get the latest jupyterhub
RUN git clone https://github.com/jupyterhub/jupyterhub

# Install dependencies
WORKDIR /srv/test/jupyterhub
RUN npm install
RUN npm install -g configurable-http-proxy
RUN pip3 install -r dev-requirements.txt -e .

ENV ASYNC_TEST_TIMEOUT=15

CMD ["pytest", "-v", "jupyterhub/tests"]
