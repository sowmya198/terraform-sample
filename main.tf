data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet" "my_subnet" {
  vpc_id            = data.aws_vpc.default_vpc.id
  availability_zone = "ap-southeast-1a"
}
data "aws_subnet" "my_subnet_2" {
  vpc_id            = data.aws_vpc.default_vpc.id
  availability_zone = "ap-southeast-1b"
}

data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
}

data "aws_ami" "ubuntu" {

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  owners      = ["099720109477"]
  most_recent = true
}

resource "aws_launch_configuration" "launch_conf" {
  name          = "sowmya-launch-config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "my_asg" {
  name                 = "sowmya-asg"
  launch_configuration = aws_launch_configuration.launch_conf.name
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  vpc_zone_identifier = [data.aws_subnet.my_subnet.id,data.aws_subnet.my_subnet_2.id]
  lifecycle {
    create_before_destroy = true
  }
}

