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
  access_key = "ASIASDKBNIIVJ22QKEIW"
  secret_key = "zpSnUD26UjNFWK02bcXFg7vGiyeqcRzbMuSpEa1B"
  token      = "FwoGZXIvYXdzEIz//////////wEaDF3C4wpc3mXj71Z3wiLBAa2YVPjJWzEFHAYWrwMRoiIUC3OVQairGxRmmQYS4TZrer0H5vh44MIIbfTjo3/a5dl4fo8IKnH95o2Gspx/BFCfcEfGMTYbcQYYDsX3I1sEJhTpY/r9jvI7j4V3YpKJ8IlU56DYoPkCV/PkJGICcofzkv8lCyUjRglI9tmg9vCTCNs1JTv+m6g8IRy5+bbdQ98nDGzP9pekf3YDmgUx8u6VXEFy06iM+2NQ1suYYkMih/nP1YjqP2DFAjOwdrjabuMo0ayUnQYyLT6EVefTAV4YZjobjw6SSCtuzu4zWVCr2hVE0EQaSRPsNKgrsZLeUlMxumrT5g=="
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