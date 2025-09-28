resource "aws_launch_template" "asg_lt" {
    name_prefix = "${var.prefix}-lt-${var.region}-"
    description = "Launch template, RedHat, t2.micro w/20GB storage"

    image_id = var.ami_id
    instance_type = var.instance_type
    key_name = var.kp_name


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

    vpc_security_group_ids = []

}