{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "eva.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "eva.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eva.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "eva.labels" -}}
helm.sh/chart: {{ include "eva.chart" . }}
{{ include "eva.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "eva.selectorLabels" -}}
app.kubernetes.io/name: {{ include "eva.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Selector labels for the frontend component
*/}}
{{- define "eva.frontend.selectorLabels" -}}
app.kubernetes.io/component: frontend
app.kubernetes.io/part-of: eva-gallery
{{- end -}}

{{/*
Selector labels for the backend component
*/}}
{{- define "eva.backend.selectorLabels" -}}
app.kubernetes.io/component: backend
app.kubernetes.io/part-of: eva-gallery
{{- end -}}

{{/*
Selector labels for the nft component
*/}}
{{- define "eva.nft.selectorLabels" -}}
app.kubernetes.io/component: nft
app.kubernetes.io/part-of: eva-gallery
{{- end -}}

{{/*
Selector labels for the AI component
*/}}
{{- define "eva.ai.selectorLabels" -}}
app.kubernetes.io/component: ai
app.kubernetes.io/part-of: eva-gallery
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "eva.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "eva.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "eva.postgresql.fullname" -}}
{{- if .Values.postgresql.fullnameOverride -}}
{{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{ printf "%s-%s" .Release.Name "postgresql"}}
{{- end -}}
{{- end -}}

{{/*
Set postgres host
*/}}
{{- define "eva.postgresql.host" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "eva.postgresql.fullname" . -}}
{{- else -}}
{{- .Values.postgresql.postgresqlHost | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secret
*/}}
{{- define "eva.postgresql.secret" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "eva.postgresql.fullname" . -}}
{{- else -}}
{{- template "eva.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secretKey
*/}}
{{- define "eva.postgresql.secretKey" -}}
{{- if .Values.postgresql.enabled -}}
"postgresql-password"
{{- else -}}
{{- default "postgresql-password" .Values.postgresql.existingSecretKey | quote -}}
{{- end -}}
{{- end -}}
