output "usersage1" {
  value = "My name is ${var.username1} and my age is ${lookup(var.usersage,"${var.username1}")}"
}

output "usersage2" {
    value = "My name is ${var.username2} and my age is ${lookup(var.usersage,"${var.username2}")}"
}


output "username-list-output-1" {
  value = "My name is ${var.username_list[0]} and my age is ${lookup(var.usersage,"${var.username_list[0]}")}"
}

output "username-list-output-2" {
  value = "My name is ${var.username_list[1]} and my age is ${lookup(var.usersage,"${var.username_list[1]}")}"
}