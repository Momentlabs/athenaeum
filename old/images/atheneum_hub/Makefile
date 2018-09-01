# Use google cloudbuild to create the image

GCP_PROJECT := momentlabs-jupyter
IMAGE := jupyterhub-k8s

# This is NOT working, and I don't know why.
# all:
# 	gcloud builds submit --config cloudbuild.yaml

# Since this is merely an image build, we can do a one liner, to incorporate testing
# it would be better to do the more full on build.

# NOTE For the moment this is not being used and the DockerHub (dh) builds are being used
# until I figure out how to get the gcr.io images loaded into kube properly. 
# (I'm pretty sure it's just image load credentials on the JH kubespawner, but ...
default:
	gcloud builds submit --tag gcr.io/$(GCP_PROJECT)/$(IMAGE):latest .

gcr-staging:
	gcloud builds submit --tag gcr.io/$(GCP_PROJECT)/$(IMAGE):staging .

gcr-production:
	gcloud builds submit --tag gcr.io/$(GCP_PROJECT)/$(IMAGE):production .


dh-build:
	docker build -t momentlabs/${IMAGE} .

dh-latest: dh-build
	docker push momentlabs/${IMAGE}

dh-dev: dh-build
	docker tag momentlabs/${IMAGE} momentlabs/${IMAGE}:56
	docker push momentlabs/${IMAGE}:56

dh-staging: dh-build
	docker tag momentlabs/${IMAGE} momentlabs/${IMAGE}:staging
	docker push momentlabs/${IMAGE}:staging

dh-production: dh-build
	docker tag momentlabs/${IMAGE} momentlabs/${IMAGE}:production
	docker push momentlabs/${IMAGE}:production
