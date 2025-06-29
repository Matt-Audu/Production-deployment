output "private_ip" {
  value = [aws_instance.minikube.private_ip]
}

output "public_ip" {
  value = [aws_eip.eip2.public_ip]
}