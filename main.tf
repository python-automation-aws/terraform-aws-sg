 resource "aws_instance" "app" {
  ami              =  "ami-00f9f4069d04c0c6e"
  instance_type     = "t2.micro"
  vpc_security_group_ids =    [var.sg_pub]   
   subnet_id   = var.subnet_id_pub
   key_name = "prod"
  tags = {
    Name = "myec2"
  }
  provisioner "remote-exec" {
     inline = [
       "sudo amazon-linux-extras install -y nginx1.12",
       "sudo systemctl start nginx"
     ]

   connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./ec2/prod.pem")  # var.prv_key
     host = self.public_ip
   }
   }
}
variable "sg_pub"{
    
}
variable "subnet_id_pub"{

}

resource "aws_eip" "my_eip" {
  #   depends_on= [var.route_table_associate] #aws_route_table_association.pub]
  # instance = var.nat_id
  vpc      = true
}
output  "eip_output" {
    value = aws_eip.my_eip.id
}



resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = var.subnet_id_pub

   tags = {
    Name = "gw_NAT"
  }
}

output "nat_output"{
  value = aws_nat_gateway.nat_gateway.id
}
