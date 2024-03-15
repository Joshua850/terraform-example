variable "VPC_ID" {
  description = "vpc id"
}
variable "IG" {
  description = "Internet gateway"
}

variable "SG" {
  description = "Security Group"
}

variable "VPC_SUBNET" {
  description = "Subnet"
}
variable "EC2_SG" {
  description = "EC2 SG"
}
variable "ELB_SG" {
  description = "ELB SG"
}

variable "DOMAIN_HOSTED_ZONE_ID" {
  description = "DOMAIN_HOSTED_ZONE_ID"
}
