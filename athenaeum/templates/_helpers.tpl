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
*/}}
{{- define "athenaeum.labels" -}}
{{ include "athenaeum.common_labels" . }}
{{ include "athenaeum.component" . }}
{{- end -}}

{{- /* 
     athenaeum.service.selector
     Defines the labels we use to select a service, making allowance
     for the hub to be the deployment/pod that also contains the proxy.
     Note: the line with the if does NOT want an initial white space from the
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
     
*/}}
{{- define "athenaeum.proxy.service.name" -}}
{{- if .Values.proxy.service.name -}}
{{ .Values.proxy.service.name }}
{{- else -}}
{{ printf "%s-%s-proxy" .Chart.Name .Release.Name }}
{{- end -}}
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