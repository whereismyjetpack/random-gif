---
apiVersion: v1
kind: Service
metadata:
  annotations:
{%- if TRAEFIK_STICKY_SESSIONS is defined %}
    traefik.backend.loadbalancer.sticky: "true"
{%- endif %}
  name: {{CI_PROJECT_NAME}}-{{ CI_COMMIT_REF_SLUG }}
  labels:
    app: {{CI_PROJECT_NAME}}
    ref: "{{CI_COMMIT_REF_SLUG }}"
spec:
  type: ClusterIP
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
  selector:
    app: {{CI_PROJECT_NAME}}
    ref: "{{CI_COMMIT_REF_SLUG}}"
