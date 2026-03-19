provider "aws" {
  region = "ap-southeast-1"
}
 
data "aws_ami" "windows_2022" {
  most_recent = true
 
  owners = ["amazon"]
 
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}
 
resource "aws_instance" "win_vm" {
  ami           = data.aws_ami.windows_2022.id
  instance_type = "t3.micro"
 
  tags = {
    Name = "prashant-win-aws"
  }
}
