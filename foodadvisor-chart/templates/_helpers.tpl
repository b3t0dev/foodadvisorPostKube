{{/*
Expand the name of the chart.
*/}}
{{- define "foodadvisor-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "foodadvisor-chart.fullname" -}}
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
{{- define "foodadvisor-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "foodadvisor-chart.labels" -}}
helm.sh/chart: {{ include "foodadvisor-chart.chart" . }}
{{ include "foodadvisor-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "foodadvisor-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "foodadvisor-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use for backend or frontend
*/}}
{{- define "foodadvisor-chart.serviceAccountName" -}}
{{- if .backend }}
  {{- if $.Values.backend.serviceAccount.create }}
    {{- default (include "foodadvisor-chart.fullname" $) $.Values.backend.serviceAccount.name }}
  {{- else }}
    {{- default "default" $.Values.backend.serviceAccount.name }}
  {{- end }}
{{- else if .frontend }}
  {{- if $.Values.frontend.serviceAccount.create }}
    {{- default (include "foodadvisor-chart.fullname" $) $.Values.frontend.serviceAccount.name }}
  {{- else }}
    {{- default "default" $.Values.frontend.serviceAccount.name }}
  {{- end }}
{{- end }}
{{- end }}