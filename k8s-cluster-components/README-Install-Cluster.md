# K8s multinode cluster on AWS EC2

### Prerequisites for Kubeadm Kubernetes cluster setup.
```
1. Minimum two Ubuntu nodes [One master and one worker node]. You can have more worker nodes as per your requirement.
2. The master node should have a minimum of 2 vCPU and 2GB RAM.
3. For the worker nodes, a minimum of 1vCPU and 2 GB RAM is recommended.

Note: Make sure the Node IP range and pod IP range don’t overlap.
```

### K8s Cluster Setup Using Kubeadm
```
1. Ensure iptables and swap are configured as expected
2. Install container runtime (CRI, CNI plugin, CRICTL) on all nodes- We will be using cri-o.
3. Install Kubeadm, Kubelet, and kubectl on all the nodes.
4. Initialize the K8s master node to provision control-plane
5. Save the node join command with the token.
6. Install the Calico network plugin.
7. Join the worker node to the master node (control plane) using the join command.
8. Validate all cluster components and nodes.
9. Deploy a sample app and validate the app
```

### Note:
```
1. Step1 to Step3 execute on all the nodes
2. Step4, Step6, Step8 and Step9 execute only on Master nodes
3. Step7 execute only on worker nodes
```

# Ensure iptables and swap are configured as expected

### Enable iptables bridged traffic on all Nodes
```
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter
```
### sysctl params required by setup, params persist across reboots
```
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
```

### Apply sysctl params without reboot
```
sudo sysctl --system
```

### Disable swap on all the Nodes
```
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

# Install container runtime (CRI, CNI plugin, CRICTL) on all nodes- We will be using cri-o.

### Connect to the Docker repository to install CRI runtime
```
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
echo | sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates containerd.io
```

### Configure containerd
```
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd
```

### Install the CNI plugin
```
CNI_PLUGIN_VERSION="v1.3.0"
CNI_PLUGIN_TAR="cni-plugins-linux-amd64-$CNI_PLUGIN_VERSION.tgz" # change arch if not on amd64
CNI_PLUGIN_INSTALL_DIR="/opt/cni/bin"

curl -LO "https://github.com/containernetworking/plugins/releases/download/$CNI_PLUGIN_VERSION/$CNI_PLUGIN_TAR"
sudo mkdir -p "$CNI_PLUGIN_INSTALL_DIR"
sudo tar -xf "$CNI_PLUGIN_TAR" -C "$CNI_PLUGIN_INSTALL_DIR"
rm "$CNI_PLUGIN_TAR"
```

### Install the crictl
```
VERSION="v1.26.0" # check latest version in /releases page
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz

cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
debug: false
pull-image-on-create: false
EOF
```

# Install Kubeadm, Kubelet, and kubectl on all the nodes.

### Add the official Kubernetes key
```
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://dl.k8s.io/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
```

### Install Kubernetes components
```
KUBERNETES_VERSION="1.26.3-00"

sudo apt-get install -y kubelet="$KUBERNETES_VERSION" kubectl="$KUBERNETES_VERSION" kubeadm="$KUBERNETES_VERSION"
sudo apt-get update -y
sudo apt-get install -y jq
sudo apt-mark hold kubelet kubeadm kubectl
```

# Initialize the K8s master node to provision control-plane
### Store the public ip in kubelet
```
local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"
cat > /etc/default/kubelet << EOF
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
EOF
```
### If you're using public ip to provision control-plane
```
NODENAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"

sudo kubeadm init --control-plane-endpoint="<public-ip>" --apiserver-cert-extra-sans="<public-ip>" --pod-network-cidr="$POD_CIDR" --node-name "$NODENAME" --ignore-preflight-errors Swap
```
### If you're using private ip to provision control-plane
```
NODENAME=$(hostname -s)
POD_CIDR="192.168.0.0/16"

sudo kubeadm init --apiserver-advertise-address="<private-ip>" --apiserver-cert-extra-sans="<private-ip>" --pod-network-cidr="$POD_CIDR" --node-name "$NODENAME" --ignore-preflight-errors Swap
```

### Configure kubeconfig
```
mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

```

# Save the node join command with the token (Generated from above command)
```
kubeadm join 54.224.162.201:6443 --token tldgae.47x5qoxkzlc6uae1 --discovery-token-ca-cert-hash #####
```
### In case if you forget the token to save, execute below command on master node
```
kubeadm token create --print-join-command
```

# Install the Calico network plugin.
```
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml -O

kubectl apply -f calico.yaml
```

# Join the worker node to the master node (control plane) using the join command.
```
Execute the kubeadm join command which is generated from initializing the cluster
```


# Validate all cluster components and nodes.
### On master node
```
kubectl get nodes
kubectl top pod -n kube-system
```

# Relable the worker node.
### On master node
```
kubectl label <hostname-workernode>  node-role.kubernetes.io/worker=worker
```

# Deploy a sample app and validate the app
### Create deployment file to deploy the image with replicas

```
# vi deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2 
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

### Create service file to expose the container
```
vi service.yaml

apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector: 
    app: nginx
  type: NodePort  
  ports:
    - port: 80
      targetPort: 80
      nodePort: 32000
```

### Verify the pods and access the service
```
kubectl get pods
kubectl get svc
```
### Access the worker node ip in the browser with port exposed.







