resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.my-first-eks-cluster.name
  node_group_name = "eks-first-node"
  node_role_arn   = aws_iam_role.eks_service_role.arn
  subnet_ids      = ["subnet-02533c76d57cd76e2", "subnet-0305a16a53f3c4218"]

  
  scaling_config {
    # Example: Create EKS Node Group with 2 instances to start
    desired_size = 1
    max_size     = 1
    min_size     = 1
    # ... other configurations ...
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}