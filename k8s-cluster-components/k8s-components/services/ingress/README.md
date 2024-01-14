### Install the Ingress Controller
```
https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/
```

### Deploy Nginx Ingress Controller
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/baremetal/deploy.yaml
```
```
helm upgrade --install ingress-nginx  ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace
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
|   |-- service1-deployment.yaml
|   |-- service1-service.yaml
|-- service2/
|   |-- package.json
|   |-- index.js
|   |-- service2-deployment.yaml
|   |-- service2-service.yaml
|-- k8s/
|   |-- nginx-ingress-controller.yaml
```

### Nginx Ingress Controller
```
https://github.com/nginxinc/kubernetes-ingress
```

