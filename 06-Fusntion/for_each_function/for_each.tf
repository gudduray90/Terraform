variable "my_list" {
  default = [ "Zero", "First", "Third" ]
}

resource "null_resource" "default" {
  for_each = toset(var.my_list)
  triggers = {
    list_index = each.key
    list_value = each.value
  }
}