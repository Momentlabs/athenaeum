ARG VERSION=610bb8b938db
FROM jupyter/datascience-notebook:${VERSION}

RUN jupyter labextension install @jupyterlab/hub-extension

CMD ["jupyter", "labhub"]
