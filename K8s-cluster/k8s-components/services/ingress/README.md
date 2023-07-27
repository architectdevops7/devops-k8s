
### Deploy Nginx Ingress Controller
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller- 0.32.0/deploy/static/provider/baremetal/deploy.yaml
```

Demo: Ingress controller & rules
```
• 2VMs K8s Cluster 
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

