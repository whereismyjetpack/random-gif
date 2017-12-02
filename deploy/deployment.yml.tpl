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