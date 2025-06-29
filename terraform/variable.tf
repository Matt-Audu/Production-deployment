variable "aws_region" {
  default = "us-east-1"
}

variable "server_names" {
  type    = list(string)
  default = ["minikube"]
}

variable "ingress" {
  description = "Accessible ports for the server"
  type        = list(number)
  default     = [22, 80, 443, 8000]

}

variable "egress" {
  description = "The SSH port to use for the server"
  type        = list(number)
  default     = [22, 80, 443, 8000]
}