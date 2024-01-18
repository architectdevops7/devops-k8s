## Method-1

Deploy the Amazon EBS CSI driver:

1. Download an example IAM policy with permissions that allow your worker nodes to create and modify Amazon EBS volumes:
```
curl -o example-iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/v0.9.0/docs/example-iam-policy.json
```

3. Create an IAM policy named Amazon_EBS_CSI_Driver:
```
aws iam create-policy --policy-name AmazonEKS_EBS_CSI_Driver_Policy --policy-document file://example-iam-policy.json
```

5. View your cluster’s OIDC provider URL:
```
aws eks describe-cluster --name your_cluster_name --query "cluster.identity.oidc.issuer" --output text
```

7. Create the following IAM trust policy file:
```
cat <<EOF > trust-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::YOUR_AWS_ACCOUNT_ID:oidc-provider/oidc.eks.YOUR_AWS_REGION.amazonaws.com/id/<XXXXXXXXXX45D83924220DC4815XXXXX>"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.YOUR_AWS_REGION.amazonaws.com/id/<XXXXXXXXXX45D83924220DC4815XXXXX>:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }
  ]
}
EOF
```

Replace YOUR_AWS_ACCOUNT_ID with your account ID. 
Replace YOUR_AWS_REGION with your AWS Region. 
Replace XXXXXXXXXX45D83924220DC4815XXXXX with the value returned in step 3.

5. Create an IAM role:
```
aws iam create-role \
  --role-name AmazonEKS_EBS_CSI_DriverRole \
  --assume-role-policy-document file://"trust-policy.json"
```

6. Attach your new IAM policy to the role:
```
aws iam attach-role-policy \
--policy-arn arn:aws:iam::176768607918:policy/AmazonEKS_EBS_CSI_Driver_Policy \
--role-name AmazonEKS_EBS_CSI_DriverRole
```
Note: The policy ARN can be found in the output from step 2 above.

7. To deploy the Amazon EBS CSI driver, run one of the following commands based on your Region:
```
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"
```

9. Annotate the ebs-csi-controller-sa Kubernetes service account with the Amazon Resource Name (ARN) of the IAM role that you created earlier:
```
kubectl annotate serviceaccount ebs-csi-controller-sa \
  -n kube-system \
  eks.amazonaws.com/role-arn=arn:aws:iam::176768607918:role/AmazonEKS_EBS_CSI_DriverRole
```
Note: Replace YOUR_AWS_ACCOUNT_ID with your account ID.

9. Delete the driver pods:
```
kubectl delete pods \
  -n kube-system \
  -l=app=ebs-csi-controller
```

Test the Amazon EBS CSI driver:
1. Clone the aws-ebs-csi-driver repository from AWS GitHub:
```
git clone https://github.com/kubernetes-sigs/aws-ebs-csi-driver.git
```

3. Change your working directory to the folder that contains the Amazon EBS driver test files:
```
cd aws-ebs-csi-driver/examples/kubernetes/dynamic-provisioning/
```

5. Create the Kubernetes resources required for testing:
```
kubectl apply -f manifests/
```

By this we will get one pod.yaml,storageclass.yaml and claim.yaml file 
and from this execution a storage class, persistent volume claim(PVC) and a pod will get create.
```
kubectl describe storageclass ebs-sc
kubectl get pods
kubectl get pv,pvc
kubectl exec -it app -- cat /data/out.txt
```

## Method-1

1.Install kubectl:
```
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```

```
sudo yum install -y kubectl
```

2. Install eksctl:
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
```

```
sudo mv /tmp/eksctl /usr/local/bin
```

3. Install and configure OIDC
```
eksctl utils associate-iam-oidc-provider --cluster "cluster-name" --approve
```

4. Install CSI driver
```
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster "cluster-name" \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-only \
  --role-name AmazonEKS_EBS_CSI_DriverRole
```

5. Addon to cluster
```
eksctl create addon --name aws-ebs-csi-driver --cluster "cluster-name" --service-account-role-arn arn:aws:iam::401231317770:role/AmazonEKS_EBS_CSI_DriverRole --force
```

6. Deploy the manifest

storageclass.yaml
```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
reclaimPolicy: Retain
allowVolumeExpansion: true
mountOptions:
  - debug
volumeBindingMode: Immediate
```

pvc.yaml
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-claim
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ebs-sc
  resources:
    requests:
      storage: 4Gi
```

pod.yaml
```
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  containers:
  - name: app
    image: centos
    command: ["/bin/sh"]
    args: ["-c", "while true; do echo $(date -u) >> /data/out.txt; sleep 5; done"]
    volumeMounts:
    - name: persistent-storage
      mountPath: /data
  volumes:
  - name: persistent-storage
    persistentVolumeClaim:
      claimName: ebs-claim
```