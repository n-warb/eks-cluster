# eks-cluster
Code for creating an AWS EKS cluster, the node groups are not managed by AWS and, therefore will not 
appear in the EKS console view. The code allows the setting of bootstrap parameters.

## Instructions for use:
1. Clone the repository:
    ```git clone git@github.com:n-warb/eks-cluster.git```
1. Verify that you are using aws-cli version 2.0.12 +
    ```
    $ aws --version 
    aws-cli/2.0.12 Python/3.7.4 Darwin/19.4.0 botocore/2.0.0dev16   
    ```
1. Modify the state_config.tf to point to a state file location you wish to use
    ```yaml 
    terraform {
      backend "s3" {
        region = "eu-west-1"
        bucket = "tfstatenigel" 
        key = "eks-cluster.tfstate"
        encrypt = "false"
      }
    }
    ```
1. Run the plan:
    ```yaml
    terraform init
    ```
1. Run apply and verify that you are happy with what is being constructed
    ```yaml
    terraform apply
    ```
   The code applies an authorisation config map to the cluster and performs these instructions programmatically: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
   If all is well you will see the following output:
    ```yaml
    Outputs:
    
    eks_kubeconfig = 
    
    apiVersion: v1
    clusters:
    - cluster:
        server: 
        certificate-authority-data: 
      name: kubernetes
    contexts:
    - context:
        cluster: kubernetes
        user: aws
      name: aws
    current-context: aws
    kind: Config
    preferences: {}
    users:
    - name: aws
      user:
        exec:
          apiVersion: client.authentication.k8s.io/v1alpha1
          command: aws-iam-authenticator
          args:
            - "token"
            - "-i"
            - "example"
    ```

    You can use this information to update you ```~/.kube/config``` file or alternatively you can use: 
    ```shell script
    aws eks --region eu-west-1 update-kubeconfig --name infrastructure-cluster
    ```
   If you see an authorisation error, this will be because the command: 
   ```shell script
   "sh", "-c", "aws-iam-authenticator token -i ${var.eks_cluster-name} | jq -r -c .status"
   ```
   has failed to execute - correct the permissions or run the authorisation by hand by following these
   instructions: https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html
   Verify that your nodes are operational by running the command:
   ```shell script
   kubectl get nodes --all-namespaces --watch
   ```
   You should see your nodes go into a ready state
   





