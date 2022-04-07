
BookStoreAPI
==

### .Net API example

This project is an API project and use a depedency Data Layer to store data

#### Run local with docker
1. Build 

    `docker build -t congdang/bookstoreapi .`

2. Run

    `docker run -p 2001:80 congdang/bookstoreapi` 

3. Run on browser

    `http://localhost:2001/api/books`

4. Push to Docker hub

    `docker login` and `docker push congdang/bookstoreapi:latest`

#### Deploy to Azure Container Instances

1. Create Container Instances on Azure Portal

2. Config to deploy the image from Docker Hub to Container Instances

#### Deploy to Azure Kubenetes By Using Azure CLI

1. Create a resource Group

    `az group create --name myResourceGroup --location eastus`

2. Create AKS cluster

    `az aks create --resource-group myResourceGroup --name myAKSCluster --node-count 1 --enable-addons monitoring --generate-ssh-keys`

3. Connect to the cluster

    - Install `kubectl`
    `az aks install-cli`

    - Get credentials
    `az aks get-credentials --resource-group myResourceGroup --name myAKSCluster`

    - Verify Connection
    `kubectl get nodes`

4. Deploy the App

    `kubectl apply -f ./k8s/deploy-k8s.yaml`

5. Test the application

    `kubectl get service bookstoreapi --watch`

    You will see the public IP of LoadBalancer like below

    ```
    bookstoreapoi   LoadBalancer   10.0.37.27   52.179.23.131   80:30572/TCP   2m
    ```
6. Run API on browser 

    `http://loadblancer-ip/api/books`

#### Deploy to Azure Kubenetes By Using Terraform

1. Move to azure-terraform folder

    `cd azure-terraform`

2. Login to Azure to get subscription ID

    `az login`

3. Create Azure Service Principal to give Terraform access to provision resources in Azure

    `az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<Your Subscription ID>"`

    Once the service principal is created, we see appId and password as outputs in the command line. Use these in the terraform.tfvars file to declare variables, as discussed in the previous subsection, so that Terraform can authenticate and authorize Azure deployments.

4. Init Terraform
    `terraform init`

5. Create execution plan
    `terraform plan`

6. Apply the plan to start creating resource on Azure
    `terraform apply`

    Once the deployment is complete, Apply Complete will appear in the command line and output variables -- which we mentioned in the outputs.tf file
    
7. Deploy the app to K8s cluster

    a. Get Kube config
        `az aks get-credentials --resource-group demo-aks-terraform-rg  --name demo-aks-cluster`
    b. Deploy the app
        `kubectl apply -f ../k8s/deploy-k8s.yml`
    c. Test the application
        `kubectl get service bookstoreapi --watch`
        You will see the public IP of LoadBalancer like below

        
        bookstoreapoi   LoadBalancer   10.0.37.27   52.179.23.131   80:30572/TCP   2m
        
    d. Run API on browser 

        `http://loadblancer-ip/api/books`

8. Clean
    `terraform destroy`
#### References

1. [Containerize a .NET Core API and run it on Azure container instance](https://www.youtube.com/watch?v=PMY4vYIqU6I)

2. [Deploy an Azure Kubernetes Service cluster using the Azure CLI](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough#create-aks-cluster?ocid=AID754288&wt.mc_id=azfr-c9-cxa&wt.mc_id=CFID0517)

3. [Build ASP.NET Core applications deployed as Linux containers into an AKS/Kubernetes orchestrator](https://docs.microsoft.com/en-us/dotnet/architecture/containerized-lifecycle/design-develop-containerized-apps/build-aspnet-core-applications-linux-containers-aks-kubernetes)

4. [Use Kubernetes and Terraform together for cluster management](https://www.techtarget.com/searchitoperations/tutorial/Use-Kubernetes-and-Terraform-together-for-cluster-management)