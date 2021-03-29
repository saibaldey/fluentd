# Deploy Fluentd Service into Kubernetes
Fluentd will be deployed into the K8s cluster as a Daemonset, so that it gets deployed into all the nodes as a daemon.

Once the code-base is clonned into the local system, few editing will be required based on the application/component log file path. Please search for "TOBE UPDATED" string in  the files **fluent.conf** & **daemonset.yaml**.

## ConfigMap design
fluentd-config configmap contains the fluent.conf.

## IaC code-base
[root@kube-controller]# cd fluentd-kubernetes/
[root@kube-controller fluentd-kubernetes]# ll
total 12
drwxr-xr-x. 2 root root   25 Feb  9 09:11 config
-rw-r--r--. 1 root root   79 Feb  9 09:11 configmap.sh
-rw-r--r--. 1 root root 2033 Feb  9 09:11 daemonset.yaml
-rw-r--r--. 1 root root  596 Feb  9 09:11 rbac.yaml

### Create the Configmaps
For configmaps creation we have developed a script. Just follow the below steps to execute the script "configMaps.sh"
[root@kube-controller fluentd-kubernetes]# sh ./configMaps.sh

The script should produce output as namespace logging & configmaps created sucessfully. Now lets check if those got created or not.

[root@kube-controller fluentd-kubernetes]# kubectl get configmaps -n logging
NAME                 DATA   AGE
fluentd-config       1      10s

### Deploy Fluentd component
[root@kube-controller]# kubectl apply -f fluentd-kubernetes/
daemonset.apps/fluentd configured
serviceaccount/fluentd configured
clusterrole.rbac.authorization.k8s.io/fluentd configured
clusterrolebinding.rbac.authorization.k8s.io/fluentd configured

Once the yamls are applied successfully, we should be able to see the deamonset in the "logging" namespace.

[root@kube-controller]# kubectl get all -n logging
NAME                READY   STATUS    RESTARTS   AGE
pod/fluentd-75tqs   1/1     Running   0          30s
pod/fluentd-9gnr8   1/1     Running   0          30s
pod/fluentd-gnzkv   1/1     Running   0          30s
pod/fluentd-jlh5g   1/1     Running   0          30s
pod/fluentd-km59c   1/1     Running   0          30s

NAME                     DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/fluentd   5         5         5       5            5           <none>          30s

If you get the above output & find the pods are in running state, the deployment are considered as successful.

** The no of pods should match with the no of nodes (including the master nodes) in the cluster.

## Setup Kibana Dashboard
Once the above part is done, Fluentd should start sending the logs into ES cluster (the ES cluster should have been created already the & details need to be added onto the daemonset.yaml file). Now one should move to the Kibana dashboard & start configuring the proper indexes & start viewing logs. 
