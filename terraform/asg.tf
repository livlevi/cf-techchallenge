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

resource "aws_autoscaling_group" "cftc_asg" {
    availability_zones = module.challenge_vpc.private_availability_zones
    desired_capacity = 2
    max_size = 5
    min_size = 2

    launch_template {
      id = aws_launch_template.asg_lt.id
      version = aws_launch_template.asg_lt.latest_version
    }

}