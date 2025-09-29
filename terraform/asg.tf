resource "aws_launch_template" "asg_lt" {
    name_prefix = "${var.prefix}-lt-${var.region}-"
    description = "Launch template, RedHat, t2.micro w/20GB storage"

    image_id = var.ami_id
    instance_type = var.instance_type
    key_name = var.kp_name

    vpc_security_group_ids = [aws_security_group.lt_security_group.id]

    block_device_mappings {
      device_name = "/dev/sda1"
      ebs {
        volume_size = 20
      }
    }

    iam_instance_profile {
      name = aws_iam_instance_profile.ec2_s3_instance_attach.name
    }

    instance_initiated_shutdown_behavior = "terminate"

    user_data = filebase64("${path.module}/scripts/apache_install.sh")

}

resource "aws_placement_group" "asg_pg" {
    name = "${var.prefix}-pg-${var.region}"
    strategy = "spread"
}

resource "aws_lb_target_group" "albtg" {
    name = "${var.prefix}-albtg-${var.region}"
    port = 443
    protocol = "HTTPS"
    vpc_id = module.challenge_vpc.vpc_id

}

resource "aws_autoscaling_group" "cftc_asg" {
    name = "${var.prefix}-cftc-asg-${var.region}"
    desired_capacity = 2
    max_size = 5
    min_size = 2
    health_check_grace_period = 300
    health_check_type = "ELB"
    force_delete = true
    placement_group = aws_placement_group.asg_pg.id
    vpc_zone_identifier = values(module.challenge_vpc.private_subnets)
    target_group_arns = [aws_lb_target_group.albtg.arn]

    availability_zone_distribution {
      capacity_distribution_strategy = "balanced-only"
    }
    launch_template {
      id = aws_launch_template.asg_lt.id
      version = aws_launch_template.asg_lt.latest_version
    }

}

resource "aws_lb" "alb" {
    name = "${var.prefix}-cftc-alb-${var.region}"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.lt_security_group.id]
    subnets = values(module.challenge_vpc.public_subnets)
}