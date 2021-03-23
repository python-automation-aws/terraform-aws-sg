resource "aws_security_group" "testing_web" {
  name        = "Testing_prod"
  description = "Allow inbound traffic"
  vpc_id      = var.myvpc_id

  ingress {
    description = "HTTP"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
          }
  ingress {
    description = "SSH"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
          }
  ingress {
     description = "ICMP"
     from_port         = -1
     to_port           = -1
     protocol          = "icmp"
     cidr_blocks       = ["0.0.0.0/0"]  
        }
  egress {
    description = "outbound"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
          }
  

  tags = {
    Name = "mysg_pub"
  }
}

output "sg_ouput_pub"{
    value = aws_security_group.testing_web.id
}




resource "aws_security_group" "testing_db" {
  name        = "Testing_db"
  description = "Allow inbound traffic"
  vpc_id      = var.myvpc_id

  ingress {
  description = "Redshift"
     from_port         = 5439
  to_port           = 5439
   protocol          = "tcp"
    cidr_blocks       = [var.subnet_cidr_db]
          }
  ingress {
     description = "ICMP"
     from_port         = -1
     to_port           = -1
     protocol          = "icmp"
     cidr_blocks       = [var.subnet_cidr_db]  
        }
  ingress {
    description = "SSH"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = [var.subnet_cidr_db]
          }

  egress {
    description = "outbound"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
          }

  tags = {
    Name = "mysg_db"
  }
}

variable "subnet_cidr_db"{

}

variable "myvpc_id"{    
}

output "sg_ouput_db"{
    value = aws_security_group.testing_db.id
}



# open the port for ssh, icmp (0-65535), mysql, redshift ,(public subnet cidr), for private sg
# open the port for ssh , http  in public sg