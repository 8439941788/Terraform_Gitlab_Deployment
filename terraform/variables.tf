/******************
 * # VARIABLES.TF *
 ******************/

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "ap-south-1"
}

variable "access_key" {
  type    = string
  default = "AKIAX6FHPREAKVSTXUUI"
}

variable "secret_key" {
  type    = string
  default = "j88ffxUA9ulSWCPF2Sudaw8Z6h2d0Fgv0DxBNHDo"
}

variable "enviroment" {
  type    = string
  default = "dev"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}


/**********************
 * #WILL GET FROM IAM *
 **********************/
variable "ec2_task_execution_role_arn" {
  description = "ec2 task execution role for ec2 and secret manager"
  default     = "arn:aws:iam::389602459887:role/ec2TaskExecutionRole"
}

/**********************
 * #ec2-EC2 *
 **********************/
variable "ec2_ami" {
  description = "ec2 ec2 ami"
  default     = "ami-006d3995d3a6b963b"
}

variable "availability_zones" {
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "ec2_instance_type" {
  description = "ec2_ec2_instance_type"
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "root_volume_size"
  default     = "30"
}


/***********************
 * #KEYCLOAK VARIABLES *
 ***********************/

variable "app_port_one" {
  type        = number
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "app_port_two" {
  type        = number
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 443
}

variable "port_three" {
  type        = number
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 22
}

variable "ec2_instance_ssh_Key" {
  description = "ec2_instance_ssh_Key"
  default     = "vishnu"
}

variable "db_name" {
  description = "db name"
  default     = "vishnuskumar"
}

variable "db_password" {
  description = "db password"
  default     = "Git@123$"
}