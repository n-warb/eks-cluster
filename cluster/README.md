#Cluster module

This module generates an EKS cluster with associated worker nodes.
Importantly, because the cluster is not generated by AWS but is hand constructed, the worker
nodes do not appear in the "managed list" of worker nodes.

###Arguments
| Variables | Description |
|:-------|:--------|
| keypair_name | The keypair name that will be associated with the generated key
|vpc_id| The vpc to construct the cluster in
|accessing_computer_ip|Restricts access to the management cluster to the ip address given here
|aws_region|The region to construct the cluster in
|application_subnets|The associated subnet to use for cluster construction
|app_subnet_id0|application subnet [0] - used for node creation
|app_subnet_id1|application subnet [1] - used for node creation


###Outputs

| Variables | Description |
|:-------|:--------|
eks_kubeconfig|The associated .kube output - can be annotated in ~/.kube/config or this can be automatically updated by running ```aws eks --region eu-west-1 update-kubeconfig --name cluster_name``` 

