apiVersion: apps/v1
kind: Deployment
metadata:
  name: chat-app-deployment
  namespace: default
spec:
  replicas: 1 
  selector:
    matchLabels:
      app: chat-app
  template:
    metadata:
      labels:
        app: chat-app
    spec:
      containers:
      - name: chat-app
        image: ${ecr_url} 
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
