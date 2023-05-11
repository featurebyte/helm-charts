{{/*
Expand the name of the chart.
*/}}
{{- define "featurebyte-oss.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "featurebyte-oss.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "featurebyte-oss.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "featurebyte-oss.labels" -}}
helm.sh/chart: {{ include "featurebyte-oss.chart" . }}
{{ include "featurebyte-oss.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "featurebyte-oss.labels.minio" -}}
{{ include "featurebyte-oss.labels" . }}
{{ include "featurebyte-oss.selectorLabels.minio" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "featurebyte-oss.selectorLabels" -}}
app.kubernetes.io/name: {{ include "featurebyte-oss.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "featurebyte-oss.selectorLabels.minio" -}}
{{ include "featurebyte-oss.selectorLabels" . }}
app.kubernetes.io/component: minio
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "featurebyte-oss.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "featurebyte-oss.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
