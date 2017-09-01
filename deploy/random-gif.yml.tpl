---
apiVersion: v1
kind: Service
metadata:
  annotations:
    traefik.backend.loadbalancer.sticky=true
  name: {{CI_PROJECT_NAME}}-{{ ENVIRONMENT_NAME }}
  labels:
    app: {{CI_PROJECT_NAME}}
    ref: "{{ENVIRONMENT_NAME }}"
spec:
  type: ClusterIP
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
  selector:
    app: {{CI_PROJECT_NAME}}
    ref: "{{ENVIRONMENT_NAME}}"
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: {{CI_PROJECT_NAME}}-{{ENVIRONMENT_NAME}}
  labels:
    app: {{CI_PROJECT_NAME}}
    ref: "{{ENVIRONMENT_NAME}}"
    user: "{{GITLAB_USER_ID}}"
    job_number: "{{CI_JOB_ID}}"
spec:
  replicas: {{REPLICA_COUNT|default(2)}}
  template:
    metadata:
      labels:
        app: {{CI_PROJECT_NAME}}
        ref: "{{ENVIRONMENT_NAME}}"
    spec:
{%- if IMAGE_PULL_SECRETS is defined %}
      imagePullSecrets:
        - name: {{IMAGE_PULL_SECRETS}}
{%- endif %}
      containers:
      - name: {{CI_PROJECT_NAME}}
        image: "nexus.ci.psu.edu:5000/djb44/{{CI_PROJECT_NAME}}:{{CI_COMMIT_SHA|default('develop')}}"
        ports:
        - containerPort: 8080
        livenessProbe:
          httpGet:
            path: /
            port: 8080
        readinessProbe:
          httpGet:
            path: /
            port: 8080
        resources:
          limits:
            cpu: 100m
            memory: 128Mi
          requests:
            cpu: 100m
            memory: 128Mi
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: {{CI_PROJECT_NAME}}-{{ENVIRONMENT_NAME}}
  labels:
    app: {{CI_PROJECT_NAME}}
    ref: "{{ENVIRONMENT_NAME}}"
  annotations:
      kubernetes.io/ingress.class: "traefik"
spec:
  rules:
    - host: {{CI_ENVIRONMENT_URL|replace("https://", "")|replace("http://","") }}
      http:
        paths:
          - path: /
            backend:
              serviceName: {{CI_PROJECT_NAME}}-{{ENVIRONMENT_NAME}}
              servicePort: 8080
