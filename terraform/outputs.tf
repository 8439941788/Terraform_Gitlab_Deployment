
# /****************
#  * # OUTPUTS.TF *
#  ****************/
output "load_balancer_dns" {
  description = "ec2 ip"
  value       = aws_instance.ec2_instance.public_ip
}


# output "db_instance_address" {
#   description = "The address of the RDS instance"
#   value       = aws_db_instance.mydb1.address
# }

# output "db_instance_endpoint" {
#   description = "The connection endpoint"
#   value       = aws_db_instance.mydb1.endpoint
# }


# output "repo-url" {
#   value = aws_ecr_repository.ecr.repository_url
# }


