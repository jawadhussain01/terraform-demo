provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "demoSG" {
  name        = "allow_http"
  description = "Allow inbound traffic to ingress"
  ingress {
    description = "Allow nginx"
    from_port   = 0
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    name = "allow_ssh"
    description = "allow ssh"
    from_port = 0
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_nginx"
  }
}

resource "aws_instance" "demoEC2" {
  ami           = "ami-06ca3ca175f37dd66"
  instance_type = "t2.micro"
  aws_key       = "terraform-windows-key"
  vpc_security_group_ids = [aws_security_group.demoSG.id]
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file("./terraform-key-windows.pem")
    }
    inline = ["sudo yum install -y nginx",
      "sudo systemctl restart nginx"
    ]
  }
}

