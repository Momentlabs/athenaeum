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

# Trigger Definitions

Trigger definitions are not supported by glcoud yet. You _can_ go to the console and create trigger definitions, but this is cumbersome at best.

It turns out, the google cloud api and the pytyhon client support trigger definitions. The only thing that you can't do is add a new github repo, as this requires an authentication process that is not yet automated - it probably won't be for some time.

Enter, cloudbuild.py. I wrote this explicitly for the purpose of automating trigger definition creation. It currently has to commands: list and create. I expect I'll have to add delete soon enough. It works by using a json definition of the trigger you want to create. I've got it reading a file now, I suppose I could add the command line equivelant if you want to put the file inline (you can accomplish this with: `echo <json-string> | cloudbuild create` if you really need to)

There is a tempalte for a cloudbuild trigger file def in the directory where this read me is. So to add auto build to an image, you copy the template to the image directory just as you did above, call it, say, trigger_def.json. Then you can say:

```bash
cloudbuild create trigger_def.json
```

It will prompt you for a project name. If you want to include the project name on the command line then:

```bash
cloudbuild --project momentlabs-jupyter create trigger_def.json
```

will work. Also

```bash
cloudbuild --help
cloudbuild create --help
```

are useful too.

> However, you need gcloud credentials specified for this to work. You can see [here](https://developers.google.com/api-client-library/python/samples/samples) how to download credential files. Download it to a file called, say, account.json. Then you must set the environment variable: GOOGLE_APPLICATION_CREDENTIALS to point to that file eg. 
```export GOOGLE_APPLICATION_CREDENTIALS="account.json```

> Also important! This command is **NOT** idempotent. Each time you do this you _will_ create a new trigger. So I guess I better add delete.








