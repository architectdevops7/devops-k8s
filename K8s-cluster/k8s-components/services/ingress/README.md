
### Deploy Nginx Ingress Controller

Demo: Ingress controller & rules
```
• 3VMs K8s Cluster + 1 VM for Reverse Proxy
• Deploy Ingress controller
• Deploy pods
• Deploy services
• Deploy Ingress rules
• Service1 & Service2 are two application files
```
```
microservices-project/
|-- service1/
|   |-- package.json
|   |-- index.js
|-- service2/
|   |-- package.json
|   |-- index.js
|-- k8s/
|   |-- nginx-ingress-controller.yaml
|   |-- service1-deployment.yaml
|   |-- service1-service.yaml
|   |-- service2-deployment.yaml
|   |-- service2-service.yaml
```

