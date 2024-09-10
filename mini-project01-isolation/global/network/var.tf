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

variable "data_private_cidrs" {
  description = "(Required)  used as an iterator to create multiple resources or attach attributes to resources in the data subnet for the data layer"

  type = list(string)
  default = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zone" {
  description = "Iterator to places subnets in different availablity zones to enable high availabilty of resources"

  type = list(any)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
}
