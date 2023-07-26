provider "aws" {
  region = "us-east-1"
}

variable "instance_name" {
  type    = string
  default = "k8s-instance"
}

variable "ami_id" {
  type    = string
  default = "ami-053b0d53c279acc90"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "key_name" {
  type    = string
  default = "nvirginia"
}

variable "security_group_ids" {
  type    = list(string)
  default = ["sg-01ce819e8d65269f0"]
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-03c1e3efc05a20333", "subnet-0a1698f89d640a509"]
}

variable "inbound_from_port" {
  type    = list(string)
  default = ["80", "80", "80"]
}

variable "inbound_to_port" {
  type    = list(string)
  default = ["80", "80", "80"]
}

variable "inbound_protocol" {
  type    = list(string)
  default = ["TCP", "TCP", "TCP"]
}

variable "inbound_cidr" {
  type    = list(string)
  default = ["172.31.0.0/20", "172.31.80.0/20"]
}

variable "outbound_from_port" {
  type    = list(string)
  default = ["32768", "32768", "32768"]
}

variable "outbound_to_port" {
  type    = list(string)
  default = ["61000", "61000", "61000"]
}

variable "outbound_protocol" {
  type    = list(string)
  default = ["TCP", "TCP", "TCP"]
}

variable "outbound_cidr" {
  type    = list(string)
  default = ["172.31.0.0/20", "172.31.80.0/20"]
}

