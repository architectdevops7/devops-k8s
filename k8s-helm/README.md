### Installation of Helm

### Prerequisites:
```
A Kubernetes cluster: Helm is used to manage Kubernetes applications, so you should have a running Kubernetes cluster.
Command-line tools: You'll need the kubectl command-line tool to interact with your Kubernetes cluster.
```

### Install Helm:
```
On Linux/Unix:

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh
```

### Create a New Helm Chart:
```
mkdir nginx-chart
cd nginx-chart
helm create nginx-app

root@k8s-master-1:/opt# tree nginx-chart/
nginx-chart/
└── nginx-app
    ├── Chart.yaml
    ├── charts
    ├── templates
    │   ├── NOTES.txt
    │   ├── _helpers.tpl
    │   ├── deployment.yaml
    │   ├── hpa.yaml
    │   ├── ingress.yaml
    │   ├── service.yaml
    │   ├── serviceaccount.yaml
    │   └── tests
    │       └── test-connection.yaml
    └── values.yaml

4 directories, 10 files
```
