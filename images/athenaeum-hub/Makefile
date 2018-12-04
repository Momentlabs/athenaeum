# Use google cloudbuild to create the image

GCP_PROJECT := momentlabs-jupyter
COMMIT_SHA := $(shell git describe --always --dirty --abbrev=40)
SHORT_SHA := $(shell git describe --always --dirty)
REPO_NAME := "jdr-local/athenaeum"
BRANCH_NAME := $(shell git rev-parse --abbrev-ref HEAD)
TAG_NAME := $(shell git describe --always --dirty --tags)


default: 
	gcloud builds submit --substitutions TAG_NAME=${TAG_NAME},COMMIT_SHA=${COMMIT_SHA},REPO_NAME=${REPO_NAME},BRANCH_NAME=${BRANCH_NAME},SHORT_SHA=${SHORT_SHA},_DOCKERFILE=. --config cloudbuild.yaml

# 	gcloud builds submit --tag gcr.io/$(GCP_PROJECT)/$(IMAGE):latest .

# gcr-staging:
# 	gcloud builds submit --tag gcr.io/$(GCP_PROJECT)/$(IMAGE):staging .

# gcr-production:
# 	gcloud builds submit --tag gcr.io/$(GCP_PROJECT)/$(IMAGE):production .


# dh-production: dh-build
# 	docker tag momentlabs/${IMAGE} momentlabs/${IMAGE}:production
# 	docker push momentlabs/${IMAGE}:production
