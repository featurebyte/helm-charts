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

{{- define "featurebyte-oss.labels.api" -}}
{{ include "featurebyte-oss.labels" . }}
{{ include "featurebyte-oss.selectorLabels.api" . }}
{{- end }}

{{- define "featurebyte-oss.labels.minio" -}}
{{ include "featurebyte-oss.labels" . }}
{{ include "featurebyte-oss.selectorLabels.minio" . }}
{{- end }}

{{- define "featurebyte-oss.labels.mongodb" -}}
{{ include "featurebyte-oss.labels" . }}
{{ include "featurebyte-oss.selectorLabels.mongodb" . }}
{{- end }}

{{- define "featurebyte-oss.labels.redis" -}}
{{ include "featurebyte-oss.labels" . }}
{{ include "featurebyte-oss.selectorLabels.redis" . }}
{{- end }}

{{- define "featurebyte-oss.labels.worker.io" -}}
{{ include "featurebyte-oss.labels" . }}
{{ include "featurebyte-oss.selectorLabels.worker.io" . }}
{{- end }}

{{- define "featurebyte-oss.labels.worker.cpu" -}}
{{ include "featurebyte-oss.labels" . }}
{{ include "featurebyte-oss.selectorLabels.worker.cpu" . }}
{{- end }}

{{- define "featurebyte-oss.labels.scheduler" -}}
{{ include "featurebyte-oss.labels" . }}
{{ include "featurebyte-oss.selectorLabels.scheduler" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "featurebyte-oss.selectorLabels" -}}
app.kubernetes.io/name: {{ include "featurebyte-oss.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "featurebyte-oss.selectorLabels.api" -}}
{{ include "featurebyte-oss.selectorLabels" . }}
app.kubernetes.io/component: api
{{- end }}

{{- define "featurebyte-oss.selectorLabels.minio" -}}
{{ include "featurebyte-oss.selectorLabels" . }}
app.kubernetes.io/component: minio
{{- end }}

{{- define "featurebyte-oss.selectorLabels.mongodb" -}}
{{ include "featurebyte-oss.selectorLabels" . }}
app.kubernetes.io/component: mongodb
{{- end }}

{{- define "featurebyte-oss.selectorLabels.redis" -}}
{{ include "featurebyte-oss.selectorLabels" . }}
app.kubernetes.io/component: redis
{{- end }}

{{- define "featurebyte-oss.selectorLabels.worker.io" -}}
{{ include "featurebyte-oss.selectorLabels" . }}
app.kubernetes.io/component: worker.io
{{- end }}

{{- define "featurebyte-oss.selectorLabels.worker.cpu" -}}
{{ include "featurebyte-oss.selectorLabels" . }}
app.kubernetes.io/component: worker.cpu
{{- end }}

{{- define "featurebyte-oss.selectorLabels.scheduler" -}}
{{ include "featurebyte-oss.selectorLabels" . }}
app.kubernetes.io/component: scheduler
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

{{/*
Pod Affinity | Tolerations | Selectors
*/}}
{{- define "featurebyte-oss.podAffinity.api" -}}
{{- with .Values.featurebyte.api.nodeSelector }}
nodeSelector:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.featurebyte.api.affinity }}
affinity:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.featurebyte.api.tolerations }}
tolerations:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{- define "featurebyte-oss.podAffinity.worker" -}}
{{- with .Values.featurebyte.worker.nodeSelector }}
nodeSelector:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.featurebyte.worker.affinity }}
affinity:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.featurebyte.worker.tolerations }}
tolerations:
{{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}