#output "max" {
#  value = "${max(var.max)}"
#}
#
#output "min" {
#  value = "${min(var.min)}"
#}

output "join" {
  value = "${join("--->" ,var.join)}"
}

output "upper" {
  value = "${upper(var.upper)}"
}

output "lower" {
  value = "${lower(var.lower)}"
}

output "title" {
  value = "${title(var.title)}"
}