# Use google cloudbuild to create the image

GCP_PROJECT := momentlabs-jupyter
SHORT_SHA := "NO_SHA"
REPO_NAME := "jdr-local/datascience-notebook-py2"
BRANCH_NAME := $(shell git rev-parse --abbrev-ref HEAD)


default: 
	gcloud builds submit --timeout=1200 --substitutions REPO_NAME=${REPO_NAME},BRANCH_NAME=${BRANCH_NAME},SHORT_SHA=${SHORT_SHA},_DOCKERFILE=. --config cloudbuild.yaml
