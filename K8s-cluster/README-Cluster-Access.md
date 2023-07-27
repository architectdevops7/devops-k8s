### To access a Kubernetes cluster that is created on EC2 instances from your local machine, you'll need to perform the following steps:

### Step1: Install kubectl on your local machine:
```
Follow the official Kubernetes documentation to install kubectl for your operating system: 
https://kubernetes.io/docs/tasks/tools/install-kubectl/
```
### Step2: Configure kubectl to connect to your cluster:
```
On your local machine, copy the kubeconfig file from one of the EC2 instances where the Kubernetes cluster is running. 
The kubeconfig file is typically located at /etc/kubernetes/admin.conf or /etc/kubernetes/kubeconfig.
Use SCP or any other method to transfer the kubeconfig file to your local machine. 
Save it in a location like ~/.kube/config.
```
### Step3: Verify kubectl configuration:
```
Run kubectl config view on your local machine to check if kubectl is configured <br>
to use the correct kubeconfig file and context for your Kubernetes cluster.
```

### Step4: Access the cluster:
```
Now that your kubectl is configured, you can run any kubectl commands <br>
to interact with your Kubernetes cluster. For example:
> kubectl get nodes to view the list of nodes in your cluster.
> kubectl get pods -n <namespace> to view pods in a specific namespace.
> kubectl apply -f <filename> to deploy resources using YAML manifests.
```

### Step5: (Optional) Set up port forwarding or VPN:
```
If you need to access services running in the Kubernetes cluster from your local machine,<br>
you can set up port forwarding or use a VPN to connect securely to the cluster.
```