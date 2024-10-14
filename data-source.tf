data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["main-vpc"]  # Replace with your VPC name
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Type"
    values = ["public"]  # Ensure these subnets are public
  }
}
