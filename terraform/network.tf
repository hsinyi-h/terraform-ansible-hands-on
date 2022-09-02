#---------------------------------------------------
# Using Terraoform VPC module to create a simple VPC
#---------------------------------------------------

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-1a"]
  public_subnets  = ["10.0.1.0/24"]
  private_subnets = ["10.0.10.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
  }
}
