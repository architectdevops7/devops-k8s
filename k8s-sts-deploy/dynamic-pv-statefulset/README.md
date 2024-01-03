### Steps to deploy Statefulset along with configmaps and secrets
```
1. Create a Secret
kubectl apply -f mysql-secret.yaml
kubectl get secrets

2. Create a MySQL StatefulSet Application
kubectl get pv
kubectl get pvc
kubectl apply -f mysql-pvc-deploy.yaml

3. Create a Service for the StatefulSet Application
kubectl apply -f mysql-service.yaml

4. Create a Client for MySQL
kubectl apply -f mysql-client.yaml
kubectl exec --stdin --tty mysql-client -- sh (get inside the client)
apk add mysql-client (install the mysql client tool)

5. Access the MySQL Application Using the MySQL Client
kubectl exec -it mysql-client /bin/sh
mysql -u root -p -h host-server-name

The syntax of the MySQL server in the Kubernetes cluster is given below:
stateful_name-ordinal_number.mysql.default.svc.cluster.local

mysql -u root -p -h mysql-set-0.mysql.default.svc.cluster.local

6. Create the Database
create database erp;
exit;
```

