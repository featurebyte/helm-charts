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
Base labels
*/}}
{{- define "featurebyte-oss.selectorLabels" -}}
app.kubernetes.io/name: {{ include "featurebyte-oss.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "featurebyte-oss.labels" -}}
helm.sh/chart: {{ include "featurebyte-oss.chart" . }}
{{ include "featurebyte-oss.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common labels
*/}}
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
{{- define "featurebyte-oss.selectorLabels.api" -}}
app.kubernetes.io/component: api
{{- end }}

{{- define "featurebyte-oss.selectorLabels.minio" -}}
app.kubernetes.io/component: minio
{{- end }}

{{- define "featurebyte-oss.selectorLabels.mongodb" -}}
app.kubernetes.io/component: mongodb
{{- end }}

{{- define "featurebyte-oss.selectorLabels.redis" -}}
app.kubernetes.io/component: redis
{{- end }}

{{- define "featurebyte-oss.selectorLabels.worker.io" -}}
app.kubernetes.io/component: worker.io
{{- end }}

{{- define "featurebyte-oss.selectorLabels.worker.cpu" -}}
app.kubernetes.io/component: worker.cpu
{{- end }}

{{- define "featurebyte-oss.selectorLabels.scheduler" -}}
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


{{/*
Generated Envs
*/}}
{{- define "featurebyte-oss.env.secrets" -}}
{{- if and .Values.encryption_secret  (ne .Values.encryption_secret "") -}}
{{- /*# Ignores the environment variable if not set*/}}
{{- /*# WARNING: Please set the CONFIG_PASSWORD_SECRET*/}}
- name: CONFIG_PASSWORD_SECRET
  value: {{ .Values.encryption_secret | b64enc }}
{{- end }}
{{- if and .Values.jwt_secret (ne .Values.jwt_secret "") -}}
{{- /*# Ignores the environment variable if not set*/}}
{{- /*# WARNING: Please set the CONFIG_JWT_SECRET*/}}
- name: CONFIG_JWT_SECRET
  value: {{ .Values.jwt_secret | b64enc }}
{{- end }}
{{- end }}

{{- define "featurebyte-oss.env.mongodb" -}}
{{- if eq .Values.mongodb.provider "communityOperator" -}}
{{- /*# This is a full mongodb connection string*/ -}}
{{- /*# The referenced secret is generated by the mongodb operator*/ -}}
- name: MONGODB_URI
  valueFrom:
    secretKeyRef:
      name: {{ include "featurebyte-oss.fullname" . }}-mongodb-admin-featurebyte
      key: connectionString.standard
{{- else if eq .Values.mongodb.provider "external" -}}
- name: MONGODB_URI
  valueFrom:
    secretKeyRef:
      name: {{ include "featurebyte-oss.fullname" . }}-mongodb-external
      key: connectionString.standard
{{- end -}}
{{- end }}

{{- define "featurebyte-oss.env.redis" -}}
{{- if eq .Values.redis.provider "standalone" -}}
- name: REDIS_URI
  value: "redis://{{ include "featurebyte-oss.fullname" . }}-redis:6379"
{{- else if eq .Values.redis.provider "external" -}}
- name: REDIS_URI
  value: {{ .Values.redis.external.connectionStr }}
{{- end -}}
{{- end -}}


{{- define "featurebyte-oss.env.s3" -}}
{{- if eq .Values.s3.provider "minio" -}}
- name: STORAGE_TYPE
  value: s3
- name: S3_URL
  value: "http://{{ include "featurebyte-oss.fullname" . }}-minio:9000"
- name: S3_REGION_NAME
  value: ""
- name: S3_ACCESS_KEY_ID
  value: {{ .Values.s3.minio.rootUser }}
- name: S3_SECRET_ACCESS_KEY
  value: {{ .Values.s3.minio.rootPassword }}
- name: S3_BUCKET_NAME
  value: {{ .Values.s3.minio.bucketName }}
{{- else if eq .Values.s3.provider "external" -}}
- name: STORAGE_TYPE
  value: s3
- name: S3_URL
  value: {{ .Values.s3.external.url }}
- name: S3_REGION_NAME
  value: {{ .Values.s3.external.region }}
- name: S3_ACCESS_KEY_ID
  value: {{ .Values.s3.external.accessKey }}
- name: S3_SECRET_ACCESS_KEY
  value: {{ .Values.s3.external.secretKey }}
- name: S3_BUCKET_NAME
  value: {{ .Values.s3.external.bucketName }}
{{- end -}}
{{- end -}}

{{- define "featurebyte-oss.env.s3minio" -}}
- name: MINIO_ROOT_USER
  value: {{ .Values.s3.minio.rootUser }}
- name: MINIO_ROOT_PASSWORD
  value: {{ .Values.s3.minio.rootPassword }}
- name: MINIO_BUCKET_NAME
  value: {{ .Values.s3.minio.bucketName }}
{{- end -}}

{{/*
Enable only if krb is enabled
*/}}
{{- define "featurebyte-oss.env.keberos" -}}
- name: KRB5_REALM
  value: {{ .Values.featurebyte.kerberos.realm }}
- name: KRB5_KDC
  value: {{ .Values.featurebyte.kerberos.kdc }}
{{- end -}}
