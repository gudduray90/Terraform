### In this, we will try to read variable value from environment variable. 
### export TF_VAR_variablename=variablevalue
### run above command on terminal

variable "username" {
  type = string
}

output "username" {
  value = "Hello, ${var.username}"
}