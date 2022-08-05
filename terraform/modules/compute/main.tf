data "aws_subnet" "this" {
  vpc_id = var.vpc_id

  tags = {
    Tier = "Public"
    Name = "Main Subnet"
  }
}

#Get AMI ID
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  owners = ["amazon", "self", "aws-marketplace"]
}

resource "aws_instance" "ansible_host" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnet.this.id
  security_groups             = [var.security_group_id]
  iam_instance_profile        = var.aws_instance_profile
  user_data                   = file("${path.module}/installansible.sh")
  key_name                    = var.ssh_key

  tags = {
    Name = "Ansible"
  }
}

resource "aws_instance" "telegraaf_host" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnet.this.id
  security_groups             = [var.security_group_id]
  iam_instance_profile        = var.aws_instance_profile
  key_name                    = var.ssh_key

  tags = {
    Name = "telegraaf"
  }
}

