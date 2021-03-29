## Creating a dedicated namespace logging for the fluentd service
kubectl create namespace logging

## Creating the configmap for the fluentd pods
kubectl create configmap fluentd-config --from-file=config --namespace logging
