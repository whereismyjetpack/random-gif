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
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: {{CI_PROJECT_NAME}}-{{CI_COMMIT_REF_SLUG}}
  labels:
    app: {{CI_PROJECT_NAME}}
    ref: "{{CI_COMMIT_REF_SLUG}}"
    user: "{{GITLAB_USER_ID}}"
    job_number: "{{CI_JOB_ID}}"
spec:
  replicas: {{REPLICA_COUNT|default(2)}}
  template:
    metadata:
      labels:
        app: {{CI_PROJECT_NAME}}
        ref: "{{CI_COMMIT_REF_SLUG}}"
    spec:
{%- if IMAGE_PULL_SECRETS is defined %}
      imagePullSecrets:
        - name: {{IMAGE_PULL_SECRETS}}
{%- endif %}
      containers:
      - name: {{CI_PROJECT_NAME}}
        imagePullPolicy: Always
        image: "{{DOCKER_REGISTRY}}/{{REGISTRY_NAMESPACE}}/{{CI_PROJECT_NAME}}:{{CI_COMMIT_REF_SLUG}}"
        env:
        - name: CI_COMMIT_SHA
          value: "{{ CI_COMMIT_SHA }}"
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
  name: {{CI_PROJECT_NAME}}-{{CI_COMMIT_REF_SLUG}}
  labels:
    app: {{CI_PROJECT_NAME}}
    ref: "{{CI_COMMIT_REF_SLUG}}"
  annotations:
      kubernetes.io/ingress.class: "traefik"
spec:
  rules:
    - host: {{CI_ENVIRONMENT_URL|replace("https://", "")|replace("http://","") }}
      http:
        paths:
          - path: /
            backend:
              serviceName: {{CI_PROJECT_NAME}}-{{CI_COMMIT_REF_SLUG}}
              servicePort: 8080
