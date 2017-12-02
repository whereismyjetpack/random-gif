---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: {{CI_PROJECT_NAME}}-{{CI_COMMIT_REF_SLUG}}
  labels:
    app: {{CI_PROJECT_NAME}}
    ref: "{{CI_COMMIT_REF_SLUG}}"
  annotations:
      kubernetes.io/ingress.class: "traefik"
spec:
  rules:
{%- if VANITY_DOMAIN is defined %}
    - host: {{VANITY_DOMAIN}}
      http:
        paths:
          - path: /
            backend:
              serviceName: {{CI_PROJECT_NAME}}-{{CI_COMMIT_REF_SLUG}}
              servicePort: 8080
{%- endif %}
    - host: {{CI_ENVIRONMENT_URL|replace("https://", "")|replace("http://","") }}
      http:
        paths:
          - path: /
            backend:
              serviceName: {{CI_PROJECT_NAME}}-{{CI_COMMIT_REF_SLUG}}
              servicePort: 8080