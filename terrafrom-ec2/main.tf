
provider "aws" {
  alias = "india"
  region = "ap-south-1"
}

resource "aws_instance" "jenkins-server" {
  ami = "ami-0e53db6fd757e38c7"
  instance_type = "t2.micro"
  key_name = "ec2-login"
}
