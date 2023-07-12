provider "aws" {
  region = "us-east-1"
  access_key = "AKIA3W24C6AWTFQOJWWL"
  secret_key = "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"
}
resource "aws_instance" "demoEC2" {
  ami = "ami-06ca3ca175f37dd66"
  instance_type = "t2.micro"
}
