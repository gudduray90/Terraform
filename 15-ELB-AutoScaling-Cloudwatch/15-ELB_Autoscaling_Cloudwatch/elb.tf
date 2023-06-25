resource "aws_elb" "my-elb" {
  name            = "my-elb"
  subnets         = ["${var.subnet1}", "${var.subnet1}"]
  security_groups = ["${aws_security_group.elb_security_group.id}"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "Http:80/"
    interval            = 30
  }
  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400
  tags = {
    Name = "my-elb"
  }
}