variable "prefix" {
    type = string
    description = "unique string to add to resources"
}

variable "ami_id" {
    type = string
}

variable "kp_name" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "region" {
    type = string
}

variable "role_name" {
    type = string
}

variable "policy_name" {
    type = string
}

variable "instance_profile" {
    type = string
}

# variable "vpc_name" {
#     type = string
# }