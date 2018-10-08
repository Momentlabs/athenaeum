# Use google cloudbuild to create the image

GCP_PROJECT := momentlabs-jupyter
GS_HELM_REPO_BUCKET_HEAD := gs://momentlabs-helm
BRANCH_NAME=staging

default: 
	gcloud builds submit --substitutions _GS_HELM_REPO_BUCKET_HEAD=${GS_HELM_REPO_BUCKET_HEAD},BRANCH_NAME=${BRANCH_NAME} --config cloudbuild.yaml

# 	gcloud builds submit --tag gcr.io/$(GCP_PROJECT)/$(IMAGE):latest .

# gcr-staging:
# 	gcloud builds submit --tag gcr.io/$(GCP_PROJECT)/$(IMAGE):staging .

# gcr-production:
# 	gcloud builds submit --tag gcr.io/$(GCP_PROJECT)/$(IMAGE):production .

