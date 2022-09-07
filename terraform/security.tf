
/**************************************************************
 * # TRAFFIC TO THE ec2 CLUSTER SHOULD ONLY COME FROM THE ALB *
 **************************************************************/
resource "aws_security_group" "services" {
  name        = "ec2-security-group-${var.enviroment}"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port_one
    to_port     = var.app_port_one
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = var.port_three
    to_port     = var.port_three
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port_two
    to_port     = var.app_port_two
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2-security-group-${var.enviroment}"
  }
}
