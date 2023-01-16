variable "key_name" {
  default = ""
}

variable "amazon_ami" {
  default = "ami-0cc814d99c59f3789"
}

variable "backend-vpc-cidr-block" {
  default = ["0.0.0.0/0"]
}