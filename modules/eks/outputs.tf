output "name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "certificate_authority" {
  value = aws_eks_cluster.eks_cluster.certificate_authority
}

output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}
