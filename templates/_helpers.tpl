{{/*
Connection settings for AutomationOrchestrator. CloudNativePG is the default
and matches the vp-cloudnative-pg-cluster chart. An empty host, TLS mode, CA secret, or
database secret selects that chart's service and secrets.
*/}}
{{- define "ao.provider" -}}
{{- .Values.postgres.provider -}}
{{- end -}}

{{- define "ao.backendSecret" -}}
{{- if .Values.postgres.backendDatabaseSecret -}}
{{- .Values.postgres.backendDatabaseSecret -}}
{{- else if eq (include "ao.provider" .) "cloudnative" -}}
orchestrator-postgres-secret
{{- else -}}
orchestrator-pg-credentials
{{- end -}}
{{- end -}}

{{- define "ao.temporalSecret" -}}
{{- if .Values.postgres.temporalDatabaseSecret -}}
{{- .Values.postgres.temporalDatabaseSecret -}}
{{- else if eq (include "ao.provider" .) "cloudnative" -}}
temporal-postgres-secret
{{- else -}}
temporal-pg-credentials
{{- end -}}
{{- end -}}

{{- define "ao.host" -}}
{{- if .Values.postgres.host -}}
{{- .Values.postgres.host -}}
{{- else if eq (include "ao.provider" .) "cloudnative" -}}
{{- printf "%s-rw.%s.svc" .Values.postgres.clusterName .Values.namespace -}}
{{- end -}}
{{- end -}}

{{- define "ao.sslMode" -}}
{{- if .Values.postgres.sslMode -}}
{{- .Values.postgres.sslMode -}}
{{- else if eq (include "ao.provider" .) "cloudnative" -}}
verify-ca
{{- else -}}
require
{{- end -}}
{{- end -}}

{{- define "ao.caSecret" -}}
{{- if .Values.postgres.caCertSecret -}}
{{- .Values.postgres.caCertSecret -}}
{{- else if and (eq (include "ao.provider" .) "cloudnative") (or (eq (include "ao.sslMode" .) "verify-ca") (eq (include "ao.sslMode" .) "verify-full")) -}}
{{- printf "%s-ca" .Values.postgres.clusterName -}}
{{- end -}}
{{- end -}}

{{/*
OpenShift ConsoleLink href. Prefer an explicit ingress host; otherwise use the
default Route pattern name-namespace.hubClusterDomain (same style as the AAP
instance chart).
*/}}
{{- define "ao.consoleHref" -}}
{{- if .Values.ingress.host -}}
{{- printf "https://%s" .Values.ingress.host -}}
{{- else -}}
{{- printf "https://%s-%s.%s" .Values.name .Values.namespace .Values.global.hubClusterDomain -}}
{{- end -}}
{{- end -}}
