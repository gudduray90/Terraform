variable "username" {
  type = string
}

variable "age" {
  type = number
}

output "username-age" {
  value = "Myname is ${var.username} and my age is ${var.age}"
}

## We can run this file wuth the below command on terminal
## terraform plan --var-file=custome_vars_file.tfvars