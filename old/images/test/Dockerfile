ARG VERSION=3.6.3
FROM python:${VERSION}

WORKDIR /srv/test

# install nodejs.
RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# Get the latest jupyterhub
ARG JUPYTERHUB_RELEASE_TAG=0.9.1
RUN git clone https://github.com/jupyterhub/jupyterhub --branch ${JUPYTERHUB_RELEASE_TAG}

# Install dependencies
ARG RUNDIR=/srv/test/jupyterhub
WORKDIR ${RUNDIR}
RUN npm install
RUN npm install -g configurable-http-proxy
RUN pip3 install -r dev-requirements.txt -e .


#
# Configure for testing
#

# create a system user for runnig the tests. 
# Don't run as root, as running a single-user-notebook root fails by-default.
ARG TEST_USER=test_user
RUN adduser --system --home ${RUNDIR} ${TEST_USER}

# Prepare file permissions
RUN chown ${TEST_USER} ${RUNDIR}

# time our for async
ENV ASYNC_TEST_TIMEOUT=15
# We need a directory that is under this USER can modify.
ENV JUPYTER_RUNTIME_DIR=${RUNDIR}

# Run as the test user.
USER ${TEST_USER}

CMD ["pytest", "-v", "jupyterhub/tests"]
