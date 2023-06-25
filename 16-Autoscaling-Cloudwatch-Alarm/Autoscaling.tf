################# Creating Launch Configuration ##########################

resource "aws_launch_configuration" "prod_ec2_launch_configuration" {
  name                 = "Prod-Webserver"
  image_id             = var.ami
  instance_type        = var.instancetype
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
  key_name             = "my_ec2_key"                                      #file("${path.module}/ec2-sshkey.pub")
  security_groups      = ["${aws_security_group.SG-my-security-group.id}"] #["${aws_security_group.SG-my-security-group.name}"]
  user_data            = <<EOF
#! /bin/bash
sudo yum update -y
sudo amazon-linux-extras install epel -y
sudo yum-config-manager --enable epel
sudo yum install stress -y
  EOF
}

################# Creating AutoScaling Group ##########################

resource "aws_autoscaling_group" "prod_auto_scaling_group" {
  name                      = "prod_auto_scaling_group"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300 ##It is in second
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.prod_ec2_launch_configuration.name
  vpc_zone_identifier       = ["${var.subnet1}", "${var.subnet1}"]
  tag {
    key                 = "Name"
    value               = "EC2 Instance"
    propagate_at_launch = "true"
  }
}

################# Creating Scaling policy ##########################

resource "aws_autoscaling_policy" "Prod_Autoscale_up_CPU_Policy" {
  name                   = "Prod_Autoscale_up_CPU_Policy"
  autoscaling_group_name = aws_autoscaling_group.prod_auto_scaling_group.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

################# Creating scaleout policy ##########################

resource "aws_autoscaling_policy" "Prod_Autoscale_down_CPU_Policy" {
  name                   = "Prod_Autoscale_down_CPU_Policy"
  autoscaling_group_name = aws_autoscaling_group.prod_auto_scaling_group.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

################# Creating Cloudwatch Alarm ##########################

resource "aws_cloudwatch_metric_alarm" "ec2_scaleup_cpu_alarm" {
  alarm_name          = "ec2_scaleup_cpu_alarm"
  alarm_description   = "This alarm will trigger when CPU utilization woll be at 30%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120" ##It will be in second.
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.prod_auto_scaling_group.name}"
  }
  actions_enabled = "true"
  alarm_actions   = ["${aws_autoscaling_policy.Prod_Autoscale_up_CPU_Policy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ec2_scaledown_cpu_alarm" {
  alarm_name          = "ec2_scaledown_cpu_alarm"
  alarm_description   = "This alarm will trigger when CPU utilization woll be at 30%"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120" ##It will be in second.
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.prod_auto_scaling_group.name}"
  }
  actions_enabled = "true"
  alarm_actions   = ["${aws_autoscaling_policy.Prod_Autoscale_down_CPU_Policy.arn}"]
}


################# Creating SNS Topic ##########################

resource "aws_sns_topic" "aws_sns_topic_prod_autoscaling" {
  name         = "aws_sns_topic_prod_autoscaling"
  display_name = "prod_autoscaling_sns_topic"
}

################# Attach SNS Topic to Autoscaling ##########################

resource "aws_autoscaling_notification" "prod_autoscaling_notification" {
  group_names = ["${aws_autoscaling_group.prod_auto_scaling_group.name}"]
  topic_arn   = aws_sns_topic.aws_sns_topic_prod_autoscaling.arn
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"
  ]
}

