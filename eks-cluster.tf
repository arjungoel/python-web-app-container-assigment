resource "aws_eks_cluster" "my-first-eks-cluster" {
  name     = "eks-test-cluster"
  role_arn = aws_iam_role.eks_service_role.arn

  vpc_config {
    #  subnet_ids = [[aws_subnet.private_subnet[*].id, aws_subnet.public_subnet[*].id]]
    subnet_ids = ["subnet-0b71466d7f346d3d2", "subnet-0b96901ba41c53663"]
  }

  version = "1.21"

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.my-first-eks-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.my-first-eks-cluster.certificate_authority[0].data
}