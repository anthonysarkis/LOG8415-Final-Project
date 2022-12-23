terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


provider "aws" {
  region     = "us-east-1"
  access_key = "ASIASDKBNIIVMAPZ3254"
  secret_key = "fXHBc0B07Cp1NUiWoiBiWgzRN1fbWfdQVQ8AOp5X"
  token      = "FwoGZXIvYXdzEJz//////////wEaDKFy2cdJHrRgv4vDIiLBAV/uXfgMNM9FNYjuUqZv1FykQA/8p0Li3eVCDiWbce+eRhO6gg1l5HqrcX7TQnuMrOskO9kUETMSJ5GOtjOQ5kxPsfLs5v4XjYQCXt6VKEv8lOPXIYSpFa8SAmHTD7JvbNu+1BAkN3Ww4S2OO52hxbdsyBBKPGjGiHHDAXpNbA97pkRlbIYaDWbnuGkWv6PLH5QDaMg6jmBT0dXPaUnnF9lht1nHujW0CPVomPZR348r5D63ARxhyIqix6HEwYgl3gMos+iXnQYyLXeB8ToRmBY7S5x4lox8fuzD1pA2vhuzfAGoxZYAMDVJuZSfgmSUlM3fCcIMaA=="
}


resource "aws_security_group" "security_gp" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "stand-alone-instance" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  user_data              = file("userdata.sh")
  key_name               = "vockey"
  tags = {
    Name = "Standalone"
  }
}

resource "aws_instance" "cluster-master-instance" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  key_name               = "vockey"
  tags = {
    Name = "Master"
  }
}

resource "aws_instance" "cluster-slave-instance-1" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  key_name               = "vockey"
  tags = {
    Name = "Slave1"
  }
}

resource "aws_instance" "cluster-slave-instance-2" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  key_name               = "vockey"
  tags = {
    Name = "Slave2"
  }
}

resource "aws_instance" "cluster-slave-instance-3" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  key_name               = "vockey"
  tags = {
    Name = "Slave3"
  }
}

resource "aws_instance" "proxy-instance" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  key_name               = "vockey"
  tags = {
    Name = "Proxy"
  }
}