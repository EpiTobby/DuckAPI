variable "key_name" {
  default = ""
}

variable "amazon_ami" {
  default = "ami-0cc814d99c59f3789"
}

variable "database_url" {
  default = "mongodb://localhost:27017/"
}

variable "frontend_url" {
  default = "http://localhost:3000"
}