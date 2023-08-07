### To test the scaling, you can generate load on the WordPress deployment. There are various ways to generate load, such as using tools like Apache Benchmark (ab) or Siege. For example, you can use ab to send multiple requests to your WordPress service:

```
sudo apt update
sudo apt install apache2-utils
```

```
ab -n 1000 -c 50 http://<your-wordpress-service-ip>:<portnumber>/  # Replace <your-wordpress-service-ip> with the actual IP
```


### To install metrics-server

### Download the metrics-server
```
curl -LO https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

or

curl https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml
```

### Modify Metrics Server Yaml File
```
vi components.yaml

Find the args section under the container section, add the following line:
- --kubelet-insecure-tls

Under the spec section, add following parameter
hostNetwork: true
```

### Deploy Metrics Server
```
kubectl apply -f components.yaml
```