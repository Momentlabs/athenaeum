{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "athenaeum.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "athenaeum.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- /*
     athenaeum.chart
     Defines chart name and with version.
*/}}
{{- define "athenaeum.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /*
     athenaeum.component
     Component is a short name used to identify Kubernbetes resources related to 
     the a partcular architectural role (e.g. Hub, Proxy etc.)

     This is using the file system to help (thanks again, Zero-To-Jupyterhub).
*/}}
{{- define "athenaeum.component" -}}
{{- $file := .Template.Name | base | trimSuffix ".yaml" -}}
{{- $parent := .Template.Name | dir | base | trimPrefix "templates" -}}
{{- $component := printf "%s" $parent | trunc 63 -}}
component: {{ $component }}
{{- end -}}

{{- define "athenaeum.common_labels" -}}
app: {{ .Chart.Name }}
release: {{ .Release.Name }}
chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
heritage: {{ .Release.Service }}
{{- end -}}

{{- /*
     athenaeum.labels
     Defines a set of default labels: (app, chart, heritage, component, release).
     TODO: Consider how to handle heritage.
*/}}
{{- define "athenaeum.labels" -}}
{{ include "athenaeum.common_labels" . }}
{{ include "athenaeum.component" . }}
{{- end -}}

{{- /* 
     athenaeum.service.selector
     Defines the labels we use to select a service, making allowance
     for the hub to be the deployment/pod that also contains the proxy.
     Note: the line with the if does NOT want an initial white space remocal from the
     previous values.
*/}}
{{- define "athenaeum.service.selector" -}}
{{ include "athenaeum.common_labels" . }}
{{ if .Values.proxy.hub_should_start -}}
component: "hub"
{{- else -}}
{{ include "athenaeum.component" . -}}
{{- end -}}
{{- end -}}

{{- /*
     athenaem.podCullerSelector
     Defines the component label for the pod-culler
     Essentially this means
              component=singleuser-server
     Note: this is used in an ENV variable in the pod-culler
     Note: It sure looks like KubeSpawner sets the value of
           component to "singleuser-server"
           Thus: "component=singleuser-server"

           z2jh also sets heritage and app to jupyterhub.
*/}}
{{- define "athenaeum.podCullerSelector" -}}
{{ printf "%s" "component=singleuser-server" }}
{{- end -}}

{{- /* 
     athenaeum.default.name_preamble
*/}}
{{- define "athenaeum.default.name_preamble" -}}
{{ printf "%s-%s" .Chart.Name .Release.Name }}
{{- end -}}

{{- /* 
     athenaeum.hub.service.name
     Compute the name of the service. If it is defined in Values then use that,
     otherwise compute using the release and chartname.
     
*/}}
{{- define "athenaeum.hub.service.name" -}}
{{- if .Values.hub.service.name -}}
{{ .Values.hub.service.name }}
{{- else -}}
{{ printf "%s-%s-hub" .Chart.Name .Release.Name }}
{{- end -}}
{{- end -}}

{{- /* 
     athenaeum.proxy.service.name
     Compute the name of the service. If it iπs defined in Values then use that,
     otherwise compute using the release and chartname.
     TODO: Clean these service names up to a single body of code with config.
*/}}
{{- define "athenaeum.proxy.service.name" -}}
{{- if .Values.proxy.service.name -}}
{{ .Values.proxy.service.name }}
{{- else -}}
{{ printf "%s-%s-proxy" .Chart.Name .Release.Name }}
{{- end -}}
{{- end -}}

{{- /* 
     athenaeum.proxy.api.service.name
     Compute the name of the service. If it iπs defined in Values then use that,
     otherwise compute using the release and chartname.
     
*/}}
{{- define "athenaeum.proxy.api.service.name" -}}
{{- if .Values.proxy.service.name -}}
{{ .Values.proxy.service.name }}
{{- else -}}
{{ printf "%s-%s-proxy-api" .Chart.Name .Release.Name }}
{{- end -}}
{{- end -}}

{{- /*
    athenaeum.hub.bind_url
    This is the address for the hub to bind to.
    It should be the all addreses 0.0.0.0 and the target port the
    service references for the container port.
*/}}
{{- define "athenaeum.hub.bind_url" -}}
{{ default (printf "http://0.0.0.0:%.0f" .Values.hub.service.targetPort) .Values.hub.bind_url }}
{{- end -}}

{{- /*
    athenaeum.hub.service.env_url
    Compute the URL for finding the HUB using Kubernetes service discovery environment
    variables. The resulting URL looks something like:
        http://$(ATHENAEUM_HUB_SERVICE_HOST):$(ATHENAEUM_HUB_SERVICE_PORT)

    When the hub service is created Kubernetes will create environment
    variables, <service-name>_SERVICE_HOST and <service-name>_SERVICE_PORT. These are used
    for service discovery.
    This should be used by the proxy service to locate the hub.
*/}}
{{- define "athenaeum.hub.service.env_url" -}}
{{- $service := include "athenaeum.hub.service.name" . | replace "-" "_"  | upper -}}
{{- $host := printf "%s_SERVICE_HOST" $service -}}
{{- $port := printf "%s_SERVICE_PORT" $service -}}
{{ printf "$(%s):$(%s)" $host $port }}
{{- end -}}

{{- /*
    athenaeum.hub.auth.auth0.oauth_callback_url 
    This is the where the hub gets called back to from Auth0 on authentication
    It's constructed with some additional decoration around the base URL for the site.
*/}}      
{{- define "athenaeum.hub.auth.auth0.oauth_callback_url" -}}
{{ default (printf "https://%s/hub/oauth_callback" .Values.proxy.hostname) .Values.hub.auth.auth0.oauth_callback_url }}
{{- end -}}

{{- /*
    athenaeum.hub.auth.auth0.cient_redirect_base_url
    This is used for redirets like /logout and provided to Auth0 for redirection to.
    It's the site URL.
*/}}
{{- define "athenaeum.hub.auth.auth0.client_redirect_base_url" -}}
{{ default (printf "https://%s" .Values.proxy.hostname) .Values.hub.auth.auth0.client_redirect_bae_url }}
{{- end -}}


{{- /*
     athenaeum.proxy.tls.secret_name
     Compute the value of the secret where the TLS key/cert will be stored.
*/}}
{{- define "athenaeum.proxy.tls.secret_name" }}
{{- if .Values.proxy.tls.secretName -}}
{{ .Values.proxy.tls.secretName }}
{{- else -}}
{{ printf "%s-tls" (include "athenaeum.default.name_preamble" .) }}
{{- end -}}
{{- end -}}