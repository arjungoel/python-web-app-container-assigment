**DOCUMENTATION**:

This README is creating a python simple login page, containerize it, pull the image into cluster and provision the cloud infrastructure using Terraform.

Steps executed:
1. Create virtual enviroment.
- To install virtual environment: `pip install virtualenv`
- create the virtual environment: `virtualenv venv`. Here `venv` is the name of virtual environment.
- activate the virtual enviroment using activate file. In Windows it is under cd venv/Scripts, whereas in Linux it is under cd src/
- install flask using `pip install flask`.
- install the requirements.txt file in venv using `pip freeze > requirements.txt`

2. Created a login page using python flask. It has username and password fields.
a. The driver code is in the file `app.py`
b. It contains the HTML code for `creating ATC_USERNAME` and `ATC_PASSWORD` Fields. If the username is `ATC` and password is `americantechnologyconsulting` you will be able to login successfully else you will get an access denied error.
c. By default `GET` request is used but when the response is send `POST` will be generated.
d. command to run the flask app if using Windows Powershell:
`set FLASK_APP=app`
`python app.py`
The application will run on port 80.

3. Dockerized the app:
a. Create the Dockefile.
b. create the ecr repository `aws ecr create-repository --repository-name atc-web-app --region us-east-1`
c. authenticate using login password for ecr.
After this password will be generated. Now use this command `aws ecr get-login` and paste the password generated.Retrieve an authentication token and authenticate your Docker client to your registry. `aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 022997318112.dkr.ecr.us-east-1.amazonaws.com`
d. Build the container image and tag it `docker build -t atc-web-app:latest . `
`docker tag atc-web-app:latest 022997318112.dkr.ecr.us-east-1.amazonaws.com/atc-web-app:latest`
The images are MUTUABLE by default but you can change it to IMMUTABLE.
e. Run the docker image `docker run --name atc-web-app:latest -p 80:80 atc-web-app:latest`
f. push the docker image to ecr `docker push 022997318112.dkr.ecr.us-east-1.amazonaws.com/atc-web-app:latest`

4. Writing the IaC (Terraform Code) to provision cloud infrastructure. The code is written to deploy eks cluster, eks managed node group and the roles required for both as a pre-requisite.
- for creating EKS cluster, the service role is needed for EKS which should have `sts:AssumeRole` for Service `eks.amazonaws.com`. The two AWS managed policies should be attached to this role. These are 
`AmazonEKSClusterPolicy` and `AmazonEKSVPCResourceController`.
- for creating EKS self managed group, use the service role and add `sts:AssumeRole` access with `ec2.amazonaws.com`. There should be three AWS managed policies that should be attached to this role. These are `AmazonEKSWorkerNodePolicy`, `AmazonEC2ContainerRegistryReadOnly` and `AmazonEKS_CNI_Policy`.

AmazonEKS_CNI_Policy --> This policy provides the Amazon VPC CNI Plugin (amazon-vpc-cni-k8s) the permissions it requires to modify the IP address configuration on your EKS worker nodes. This permission set allows the CNI to list, describe, and modify Elastic Network Interfaces on your behalf.

Amazon EKS nodes run in your AWS account and connect to the control plane of your cluster through the cluster API server endpoint. You deploy one or more nodes into a node group. A node group is one or more Amazon EC2 instances that are deployed in an Amazon EC2 Auto Scaling group.

There should be a VPC which can have public and private subnets depending you want to keep your pods internally or expose them publicly.

**To pull the ecr image into eks using K8s Deployment and Service**:

You can use your Amazon ECR images with Amazon EKS, but you need to satisfy the following prerequisites.

The Amazon EKS worker node IAM role (NodeInstanceRole) that you use with your worker nodes must possess the following IAM policy permissions for Amazon ECR.

`
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
}
`
**To expose the Kubernetes services running on my Amazon EKS cluster**:
Install `kubectl` or `eksctl` (for EKS) on the desktop in order to create deployments and services.

To expose the Kubernetes services running on your cluster, create a sample application. Then, apply the ClusterIP, NodePort, and LoadBalancer Kubernetes ServiceTypes to your sample application.

ClusterIP exposes the service on a cluster's internal IP address.
NodePort exposes the service on each node’s IP address at a static port.
LoadBalancer exposes the service externally using a load balancer. Generally for Cloud.

**Note**: Amazon EKS supports the Network Load Balancer and the Classic Load Balancer for pods running on Amazon Elastic Compute Cloud (Amazon EC2) instance worker nodes. Amazon EKS provides this support by using the LoadBalancer. You can load balance network traffic to a Network Load Balancer (instance or IP targets) or a Classic Load Balancer (instance target only)

Commands used:
1. kubectl apply -f .\eks-deployment.yml
2. kubectl get deployment
3. kubectl get pods 
4. Run `kubectl config get-contexts` if eks cluster is not added, run the command:
`aws eks --region us-east-1 update-kubeconfig --name <eks-cluster-name>`
You can also run this command: `kubectl config current-context`
5. kubectl apply -f .\eks-service.yml
6. kubectl get services
Now copy the the external-ip of th service type which is `LoadBalancer` in this case. The simplest way to ping the IP is copy it in a browser (Google Chrome) in my case.

Useful links:
- https://aws.amazon.com/premiumsupport/knowledge-center/eks-cluster-connection/#:~:text=After%20you%20create%20your%20Amazon,using%20the%20kubectl%20command%20line

- https://docs.aws.amazon.com/eks/latest/userguide/eks-networking.html

- https://docs.aws.amazon.com/eks/latest/userguide/network-load-balancing.html