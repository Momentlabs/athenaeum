# Use google cloudbuild to create the image

GCP_PROJECT := momentlabs-jupyter
SHORT_SHA := "NO_SHA"
IMAGE := athenaeum-hub
REPO_NAME := "jdr-local/athenaeum"
BRANCH_NAME := $(shell git rev-parse --abbrev-ref HEAD)


default: 
	gcloud builds submit --substitutions REPO_NAME=${REPO_NAME},BRANCH_NAME=${BRANCH},SHORT_SHA=${SHORT_SHA},_IMAGE=${IMAGE},_DOCKERFILE=. --config cloudbuild.yaml

# 	gcloud builds submit --tag gcr.io/$(GCP_PROJECT)/$(IMAGE):latest .

# gcr-staging:
# 	gcloud builds submit --tag gcr.io/$(GCP_PROJECT)/$(IMAGE):staging .

# gcr-production:
# 	gcloud builds submit --tag gcr.io/$(GCP_PROJECT)/$(IMAGE):production .


# dh-production: dh-build
# 	docker tag momentlabs/${IMAGE} momentlabs/${IMAGE}:production
# 	docker push momentlabs/${IMAGE}:production
