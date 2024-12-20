{{/*
Connector Configuration
*/}}

{{/*
Renders the global.connectorRegistry secret name
*/}}
{{- define "airbyte.connector.secretName" }}
{{- if .Values.global.connectorRegistry.secretName }}
  {{- .Values.global.connectorRegistry.secretName | quote }}
{{- else }}
  {{- .Release.Name }}-airbyte-secrets
{{- end }}
{{- end }}

{{/*
Renders the global.connectorRegistry.seedProvider value
*/}}
{{- define "airbyte.connector.seedProvider" }}
{{- .Values.global.connectorRegistry.seedProvider  }}
{{- end }}

{{/*
Renders the CONNECTORY_REGISTRY_SEED_PROVIDER environment variable
*/}}
{{- define "airbyte.connector.seedProvider.env" }}
- name: CONNECTORY_REGISTRY_SEED_PROVIDER
  valueFrom:
    configMapKeyRef:
      name: {{ .Release.Name }}-airbyte-env
      key: CONNECTORY_REGISTRY_SEED_PROVIDER
{{- end }}

{{/*
Renders the global.connectorRegistry.enterpriseSourceStubsUrl value
*/}}
{{- define "airbyte.connector.enterpriseSourceStubsUrl" }}
{{- .Values.global.connectorRegistry.enterpriseSourceStubsUrl | default "https://connectors.airbyte.com/files/resources/connector_stubs/v0/connector_stubs.json" }}
{{- end }}

{{/*
Renders the ENTERPRISE_SOURCE_STUBS_URL environment variable
*/}}
{{- define "airbyte.connector.enterpriseSourceStubsUrl.env" }}
- name: ENTERPRISE_SOURCE_STUBS_URL
  valueFrom:
    configMapKeyRef:
      name: {{ .Release.Name }}-airbyte-env
      key: ENTERPRISE_SOURCE_STUBS_URL
{{- end }}

{{/*
Renders the set of all connector environment variables
*/}}
{{- define "airbyte.connector.envs" }}
{{- include "airbyte.connector.seedProvider.env" . }}
{{- include "airbyte.connector.enterpriseSourceStubsUrl.env" . }}
{{- end }}

{{/*
Renders the set of all connector config map variables
*/}}
{{- define "airbyte.connector.configVars" }}
CONNECTORY_REGISTRY_SEED_PROVIDER: {{ include "airbyte.connector.seedProvider" . | quote }}
ENTERPRISE_SOURCE_STUBS_URL: {{ include "airbyte.connector.enterpriseSourceStubsUrl" . | quote }}
{{- end }}

{{/*
Renders the set of all connector secrets
*/}}
{{- define "airbyte.connector.secrets" }}
{{- end }}

