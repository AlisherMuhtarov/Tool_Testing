variable "instance_type" {
    type = string
    description = "This is an instance type for EC2 instances"
    default = "t2.micro"
}

variable "env" {
    type = string
    description = "This is an instance type for EC2 instances"
    default = "dev"
}

variable "ports" {
    type = list(string)
    description = "This is an instance type for EC2 instances"
    default = [ "0", "-1", "22", "80", "443", "3306" ]
}

variable "protocol" {
    type = list(string)
    description = "These are the protocals"
    default = [ "-1", "tcp" ]

}
variable "cidrs" {
    type = list(string)
    description = "List of cidrs"
    default = [ "0.0.0.0/0", "98.227.136.153/32" ] 
}
