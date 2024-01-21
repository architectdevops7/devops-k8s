# RBAC

```
Kubernetes Role - A set of permissions for a namespace
Kubernetes ClusterRole - A set of permissions for an entire cluster
Kubernetes RBAC RoleBinding - A binding between one Role and one or more Users or Groups
Kubernetes RBAC ClusterRoleBinding - A binding between one ClusterRole and one or more Users or Groups
```


1. kubectl edit configmap/aws-auth -n kube-system (add mapUsers secttion)
```
  mapUsers: |
    - userarn: arn:aws:iam::<AWS ACCOUNT NO>:user/<username>
      username: <username>
```

2. Check the access from below commands.
```
kubectl get pods #This will be denied.
kubectl get pods -n simpletest #This works
kubectl get deployments -n simpletest #This works
kubectl delete deployment/nginx -n simpletest #This will be denied.
```

# EKS RBAC Integration with IAM

### AWS EKS uses a specific ConfigMap named aws-auth to manage the AWS Roles and AWS Users who are allowed to connect and manage the cluster (or namespace).