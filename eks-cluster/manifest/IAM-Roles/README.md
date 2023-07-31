### Attach the below policy to the Role with trsuted entities as EC2
```
IAMLimited4EKS	Customer managed	
AmazonEC2FullAccess	AWS managed	
AmazonEKSClusterPolicy	AWS maneged
AmazonEKS_CNI_Policy	AWS managed	
AmazonEKSServicePolicy	AWS managed	
AmazonEKSWorkerNodePolicy	AWS managed	
AWSCloudFormationFullAccess	AWS managed	
AmazonEKSVPCResourceController AWS managed	
```
### Trusted Entity
```
 {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```