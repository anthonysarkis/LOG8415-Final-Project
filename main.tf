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
  access_key = "ASIASDKBNIIVGHSVYIVG"
  secret_key = "B9+O/Byhjjs71qhP7wBLX+Uk1voppHb/dEV0UqUw"
  token      = "FwoGZXIvYXdzEEcaDIGrpUSsquEZCPlEJSLBAU8ygm09+7CIhvqVnHxp+AXBWdneyJ1U13Om5J1iLttkuinAsyF4wKlmJFv70IVnDpdbvDiYvSBkZ833CD5cBPElDE/wnUICjIxxW2DRQV3QC6UEqDRwYJOnERWcWH0fggOanTC74a8whzs0IfQ1ng4aXkApo4YlTdckCgk5t9+lRWPv90ZxjWxX/vzvW0fR6Gi16CSSBNH8PcFysAlJMcio5UcVDEXbCMrHUuPqLnqTMorOFJtLjYmrarl9veldpLIoitKUnAYyLbKBRJDkJBZl1H1vrozoBpiUTECgEOwHKrjR4ZISjbUTFhXLI7gd4IenoSYSEg=="
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
  tags = {
    Name = "Standalone"
  }
}

resource "aws_instance" "cluster-master-instance" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  tags = {
    Name = "Master"
  }
}

resource "aws_instance" "cluster-slave-instance-1" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  tags = {
    Name = "Slave1"
  }
}

resource "aws_instance" "cluster-slave-instance-2" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  tags = {
    Name = "Slave2"
  }
}

resource "aws_instance" "cluster-slave-instance-3" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  tags = {
    Name = "Slave3"
  }
}