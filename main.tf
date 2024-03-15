provider "aws" {
  region = "eu-west-1"
}
resource "aws_vpc" "test-main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "test-main"
  }
}

resource "aws_subnet" "cassandra_subnet_A" {
  cidr_block = "172.20.1.0/24"
  vpc_id     = aws_vpc.test-main.id
  tags = {
    Name = "Subnet A"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.test-main.id
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow all TCP traffic from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
resource "aws_instance" "ec2-main" {
  ami                         = "ami-0cf57bb5d0dedcb6c"
  instance_type               = "c4.2xlarge"
  subnet_id                   = aws_subnet.cassandra_subnet_A.id
  key_name                    = "Test-key"
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  tags = {
    Name                = "ec2-main"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.test-main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.test-main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "route_table_A" {
  subnet_id      = aws_subnet.cassandra_subnet_A.id
  route_table_id = aws_route_table.example_route_table.id
}


resource "aws_ebs_volume" "ebsVolume" {
  availability_zone = "eu-west-1a"
  size              = 50
  encrypted         = true
  tags = {
    name = "EBS_VOLUME_A"
  }
}

resource "aws_volume_attachment" "mountEbsVolume" {
  device_name = "/dev/sdh"
  instance_id = aws_instance.ec2-main.id
  volume_id   = aws_ebs_volume.ebsVolume.id
}
