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

{{- /*
     athenaeum.labels
     Defines a set of default labels: (app, chart, heritage, component, release ).
*/}}
{{- define "athenaeum.labels" -}}
{{- /*
{{- $file := .Template.Name | base | trimSuffix ".yaml" -}}
{{- $parent := .Template.Name | dir | trimPrefix "templates" -}}
{{- $component := printf "%s-%s" $parent $file | trunc 63 -}}
*/}}
app: {{ .Chart.Name }}
release: {{ .Release.Name }}
{{ include "athenaeum.component" . }}
chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
heritage: {{ .Release.Service }}
{{- end -}}


