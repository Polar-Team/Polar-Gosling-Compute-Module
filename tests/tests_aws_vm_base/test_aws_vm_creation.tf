data "aws_subnet" "test_subnet" {
  filter {
    name   = "tag:Name"
    values = ["test-subnet"]
  }
}

data "aws_vpc" "test_vpc" {
  id = data.aws_subnet.test_subnet.vpc_id
}

resource "aws_security_group" "test_sg" {
  name        = "gosling-test-sg-${random_string.sg_suffix.result}"
  description = "Security group for Gosling compute module test"
  vpc_id      = data.aws_vpc.test_vpc.id

  ingress {
    description = "Allow SSH from VPC CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.test_vpc.cidr_block]
  }

  egress {
    description = "Allow HTTPS outbound to VPC CIDR"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.test_vpc.cidr_block]
  }

  tags = {
    Name = "gosling-test-sg-${random_string.sg_suffix.result}"
  }
}

resource "random_string" "sg_suffix" {
  length  = 8
  special = false
  lower   = true
  upper   = false
}

locals {
  labels = merge({
    created_at = formatdate("DD-MM-YYYY-hh-mm", timestamp()),
    owner      = "polar-team"
    group      = "application"
    },
    {
      environment = "test"
      purpose     = "opentofu-aws-vm-test"
    }
  )
}

module "aws_test_vm" {
  source        = "../../modules/aws"
  aws_vm_create = true
  labels        = local.labels

  availability_zone      = "us-east-1b"
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnet.test_subnet.id
  vpc_security_group_ids = [aws_security_group.test_sg.id]

  associate_public_ip_address = true

  root_block_device = [
    {
      volume_size = 20
      volume_type = "gp3"
    }
  ]
}
