variable "eks_name" {
  description = "Name of the cluster"
  type        = string
  nullable    = false
  validation {
    condition     = can(regex("^[0-9A-Za-z][A-Za-z0-9-_]*$", var.eks_name))
    error_message = "Must only contain alphanumeric characters, dashes and underscores"
  }
}

variable "kubernetes_version" {
  description = "Kubernetes version to use, for example 1.30"
  type        = string
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnet_count" {
  description = "Number of Private Subnets to create"
  type        = number
  default     = 2
}

variable "instance_types" {
  description = "List of instance types associated with the EKS Node Group."
  default     = ["t2.micro"]
}

variable "scaling_config" {
  description = "Configuration block with scaling settings"
  type        = map(string)
  default     = {}
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group"
  type        = string
  default     = "ON_DEMAND"
}

variable "taints" {
  description = "The Kubernetes taints to be applied to the nodes in the node group"
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = []
}

variable "labels" {
  description = "Key-value map of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument"
  type        = map(string)
  default     = {}
}