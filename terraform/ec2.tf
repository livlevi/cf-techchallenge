module "challenge_ec2" {
    source = "github.com/Coalfire-CF/terraform-aws-ec2"

    name = "${var.prefix}-instance-${var.region}"

    ami = var.ami_id
    ec2_instance_type = var.instance_type
    instance_count = 2

    vpc_id = module.challenge_vpc.vpc_id
    subnet_ids = values(module.challenge_vpc.public_subnets)
    associate_public_ip = true

    ebs_optimized = false

    ec2_key_pair = var.kp_name
    # ebs_kms_key_arn = module.challenge_kms.kms_key_arn

    root_volume_size = 20

    ingress_rules = {
        "ssh" = {
            ip_protocol = "tcp"
            from_port = 22
            to_port = 22
            cidr_ipv4 = "0.0.0.0/0"
            description = "SSH"
        }
    }

    egress_rules = {
        "allow_all_egress" = {
            ip_protocol = "-1"
            cidr_ipv4 = "0.0.0.0/0"
            description = "Allow all egress"
        }
    }

    global_tags = {}

}