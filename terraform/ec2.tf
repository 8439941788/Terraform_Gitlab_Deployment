###########################################################
# AWS EC2
###########################################################

# resource "aws_eip" "eip" {
#     instance      = aws_instance.ec2_instance.id
#     vpc           = true
# }

resource "aws_instance" "ec2_instance" {
  ami = var.ec2_ami
  # count = var.az_count
  subnet_id = aws_subnet.public[0].id
  # subnet_id              = aws_subnet.private[count.index].id
  instance_type          = var.ec2_instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_role.id
  vpc_security_group_ids = [aws_security_group.services.id]
  key_name               = var.ec2_instance_ssh_Key
  ebs_optimized          = "false"
  source_dest_check      = "false"
  user_data              = data.template_file.user_data.rendered
  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.root_volume_size
    delete_on_termination = "true"
  }



  lifecycle {
    ignore_changes = [ami, user_data, subnet_id, key_name, ebs_optimized, private_ip]
  }

}

data "template_file" "user_data" {
  template = file("user_data.tpl")
  vars = {
    password     = var.db_password
    DatabaseName = var.db_name
  }
}

# resource "aws_key_pair" "key" {
#   key_name   = var.ec2_instance_ssh_Key
#   public_key = tls_private_key.rsa.public_key_openssh
# }

# resource "tls_private_key" "rsa" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "local_file" "key" {
#   content  = tls_private_key.rsa.private_key_pem
#   filename = var.ec2_instance_ssh_Key
# }

