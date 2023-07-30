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

Install and setup IAM authenticator
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
```
eksctl create cluster --name cluster02 --region us-east-1 \
  --nodegroup-name eks-cluster-ng --node-type t2.micro --nodes 2 --nodes-min 1 --nodes-max 5 --ssh-access --ssh-public-key k8s.pem --node-volume-size 20 \
  --managed
```