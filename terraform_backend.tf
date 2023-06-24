
provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }
  backend "s3" {
    bucket = "dynomo-s3-bucket"
    key = "env/dev/tf-remote-backend.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-s3-app-lock"
    encrypt = true
  }
}

locals {
  mytag = "clarusway-local-name"
}

data "aws_ami" "tf-3" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

variable "ec2_type" {
  default = "t2.micro"
}

resource "aws_instance" "tf-ec2-3" {
    ami           = data.aws_ami.tf-3.id
    instance_type = var.ec2_type
    key_name      = "firstpemkey"
    tags = {
      Name = "${local.mytag}-this is from my-ami"
    }
}

resource "aws_s3_bucket" "mybucket-example" {
  bucket = "kodal-versioning"
}