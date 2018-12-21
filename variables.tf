variable "token" {
  description = " Linode API token"
}

variable "key" {
  description = "Public SSH Key's path."
}

variable "image" {
  description = "Image to use for Linode instance"
  default = "linode/debian9"
}

variable "label" {
  description = "Label to use for Linode instance"
  default = "default-linode"
}

variable "region" {
  description = "Your Linode's region"
  default = "us-east"
}

variable "type" {
  description = "Your Linode's size"
  default = "g6-standard-1"
}

variable "key_label" {
  description = "new ssh key label"
}

variable "root_pass" {
  description = "Your Linode's Root Password"
}

