module "challenge_ec2" {
    source = "github.com/Coalfire-CF/terraform-aws-ec2"

    name = "cf-ec2instance"

    ami = ""
    ec2_instance_type = "t2.micro"
    instance_count = 1

    vpc_id = module.challenge_vpc.vpc_id
    subnet_ids = module.challenge_vpc.private_subnets["-subnet02-public-us-east-1b"]

    ec2_key_pair = module.challenge_kms.kms_key_id
    ebs_kms_key_arn = module.challenge_kms.kms_key_arn

    root_volume_size = 50

    ingress_rules = {
        "ssh" = {
            ip_protocol = "tcp"
            from_port = "22"
            to_port = "22"
            cidr_ipv4 = "0.0.0.0/0"
            description = "SSH"
        }
    }

    egress_rules = {
        "allow_all_egress" = {
            ip_protocol = "-1"
            from_port = "0"
            to_port = "0"
            cidr_ipv4 = "0.0.0.0/0"
            description = "Allow all egress"
        }
    }

    global_tags = {}
}