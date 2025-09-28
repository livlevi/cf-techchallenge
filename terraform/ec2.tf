module "challenge_ec2" {
    source = "github.com/Coalfire-CF/terraform-aws-ec2"

    name = "${var.prefix}-instance-${var.region}"

    ami = var.ami_id
    ec2_instance_type = var.instance_type
    instance_count = 1

    vpc_id = module.challenge_vpc.vpc_id
    subnet_ids = values(module.challenge_vpc.public_subnets)
    associate_public_ip = true

    ebs_optimized = false

    ec2_key_pair = var.kp_name
    ebs_kms_key_arn = module.challenge_kms.kms_key_arn

    root_volume_size = 20

    ingress_rules = {
        "ssh" = {
            ip_protocol = "tcp"
            from_port = 22
            to_port = 22
            cidr_ipv4 = "0.0.0.0/0"
            description = "SSH"
        }
        
        "http" = {
            ip_protocol = "tcp"
            from_port = 80
            to_port = 80
            cidr_ipv4 = "0.0.0.0/0"
            description = "HTTP"
        }

        "https" = {
            ip_protocol = "tcp"
            from_port = 443
            to_port = 443
            cidr_ipv4 = "0.0.0.0/0"
            description = "HTTPS"
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

    depends_on = [ module.challenge_kms ]
}