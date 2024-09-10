variable "server_port" { 
    description = "The intended server port for HTTP requests"
    default = 80
  }

variable "ssh_port" {
  description = "for SSH into the server"
  default = 22
}

variable "jenkins_port" {
  description = "for jenkin"
  default = 8080
}
