### Steps to create EKS cluster
```
Create IAM role for EKS cluster
Create Dedicated VPC for EKS cluster
Create EKS cluster
Install and setup IAM authenticator and kubectl utility
Create IAM role for EKS Worker Nodes
Create Worker nodes
Deploying demo application 
```

### Note: Do all the kubectl operations from ec2 instance (that should be launched in same VPC of EKS cluster)

### Install and setup IAM authenticator
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install unzip
unzip awscliv2.zip
sudo ./aws/install
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
```

### Install IAM authenticator in ubuntu
```
curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
aws-iam-authenticator help
https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
```

### Install kubectl in ubuntu
```
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.1/2023-04-19/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
kubectl version --short --client
https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
```

### Update kubeconfig to access the cluster
```
aws eks --region us-east-1 update-kubeconfig --name cluster01
export KUBECONFIG=~/.kube/config
```

### To provision cluster via ekscli
### To create an EKS cluster, you require a launch pad, for today we shall be using an Amazon Linux 2 EC2 server as our eks launchpad.

```
Step1: Install kubectl in ubuntu

Step2: Install the eksctl

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
export PATH=$PATH:/usr/local/bin
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
eksctl version

Step3: Create an IAM Role for EC2
EC2, CloudFormation, EKS -> Full Access
IAM limited access

Attach the role to EC2 instance
```

### Execute the below command from launcpad ec2 instance
```
eksctl create cluster --name cluster02 --region us-east-1 \
  --nodegroup-name eks-cluster-ng --node-type t2.micro --nodes 2 --nodes-min 1 --nodes-max 5 --ssh-access --ssh-public-key k8s.pem --node-volume-size 20 \
  --managed
```

### Execute the cluster.yaml from manifest folder to create cluster along with nodegroups
```
eksctl create cluster -f ekscluster.yaml --dry-run
eksctl create cluster -f ekscluster.yaml
```

### Cleanup the eks cluster
```
eksctl delete cluster <your-cluster-name>
```

### Create the EKS cluster
```
In the first script (create-eks-cluster.yaml), we have only specified the basic cluster configuration, including the cluster name, region, and version. The subnets for the VPC are defined as well.
```
```
eksctl create cluster -f create-eks-cluster.yaml
```

### Create the EKS node group
```
In the second script (create-node-group.yaml), we have removed the cluster's metadata and retained only the managed node group configuration. This includes details about the node group like the name, instance type, desired capacity, volume size, subnets, and IAM policies attached to the nodes.
```
```
eksctl create nodegroup -f create-node-group.yaml
```