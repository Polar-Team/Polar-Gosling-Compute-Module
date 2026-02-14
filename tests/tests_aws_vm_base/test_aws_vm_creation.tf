data "aws_subnet" "test_subnet" {
  filter {
    name   = "tag:Name"
    values = ["test-subnet"]
  }
}

data "aws_security_group" "test_sg" {
  filter {
    name   = "tag:Name"
    values = ["test-security-group"]
  }
}

module "aws_test_vm" {
  source        = "../../"
  aws_vm_create = true

  availability_zone      = "us-east-1b"
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnet.test_subnet.id
  vpc_security_group_ids = [data.aws_security_group.test_sg.id]

  associate_public_ip_address = true

  root_block_device = [
    {
      volume_size = 20
      volume_type = "gp3"
    }
  ]

  additional_labels = {
    environment = "test"
    purpose     = "opentofu-aws-vm-test"
  }
}
