output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.cicd_server.public_ip
}

output "app_url" {
  description = "URL to access your app"
  value       = "http://${aws_instance.cicd_server.public_ip}:5000"
}

output "ssh_command" {
  description = "Command to SSH into your server"
  value       = "ssh -i ~/Desktop/cicd-key.pem ubuntu@${aws_instance.cicd_server.public_ip}"
}