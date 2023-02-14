data "aws_ami" "ubuntu_imge" {
  filter {
    name  = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners      = ["099720109477"]
  most_recent = true
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_security_group" "pair5sg" {
  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    description = "Created from terraform"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.myip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "pair5-tf-ec2" {
  for_each               = data.aws_subnet_ids.default_subnet.ids
  ami                    = data.aws_ami.ubuntu_imge.id
  instance_type          = "t3.micro"
  key_name               = "sowmya-key-pair"
  vpc_security_group_ids = [aws_security_group.pair5sg.id]
  monitoring             = true

  root_block_device {
    volume_size           = var.EC2_ROOT_VOLUME_SIZE
    volume_type           = var.EC2_ROOT_VOLUME_TYPE
    delete_on_termination = true
  }
}
