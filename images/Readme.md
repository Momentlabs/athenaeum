# Building Images with Cloudbuild

The source of truth for this information is in [Building Images](https://github.com/Momentlabs/athenaeum/wiki/Operations#building-an-image) and [Monitoring Builds](https://github.com/Momentlabs/athenaeum/wiki/Operations#monitoring-builds). Please refer to these.

This directory hosts Docker image definitions. Images are built with cloudbuild and there is a mekfile to allow you to do this easily. These are the steps required to create a new image and integrate it into the build environment.

1. Create a directory for the Image in this build directory.
2. Copy the template files into that directory: Makefile.template -> new-image/Makefile,  cloudbuild.yaml.template -> new-image/cloudbuild.yaml
3. Edit cloudbuild.yaml's subsitution variables: 
  * _DOCKERFILE gets the directory where the dockerifle is loaded relative to the git repo root. e.g. images/new-image
  * _IMAGE is the name of the new image. e.g. new-image
4. Edit the makefile to include a repo name for the local case. e.g. jdr-local/athenaeum. This is merely for reporting.
5. Create your Dockerfile

Now you can type
```
make
```
and cloudbuild should do its work.
