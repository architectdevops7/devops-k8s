  kubectl get ns
  kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/namespace.yaml
  kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/metallb.yaml
  kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
  kubectl get ns
  kubectl get pods,serviceaccounts,deployments,roles,rolebindings -n metallb-system
  kubectl apply -f config.yaml
  kubectl apply -f hotellb.yml
  kubectl get ns
  kubectl get pods -o wide --namespace hotel
  kubectl get ingress --namespace hotel
  kubectl get svc --namespace hotel