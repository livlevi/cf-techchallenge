module "challenge_vpc" {
    source = "git::https://github.com/Coalfire-CF/terraform-aws-vpc-nfw.git"
    
    vpc_name = "${var.prefix}-vpc-${var.region}"
    cidr = "10.1.0.0/16"
    azs = [ "us-east-1a", "us-east-1b" ]

    subnets = [
        
        # Public Subnets
        {
            tag = "${var.prefix}-subnet1-public"
            cidr = "10.1.0.0/24"
            type = "public"
            availability_zone = "us-east-1a"
        },
        {
            tag = "${var.prefix}-subnet2-public"
            cidr = "10.1.1.0/24"
            type = "public"
            availability_zone = "us-east-1b"
        },
        # Private subnets
        {
            tag = "${var.prefix}-subnet3-private"
            cidr = "10.1.2.0/24"
            type = "private"
            availability_zone = "us-east-1a"
        },
        {
            tag = "${var.prefix}-subnet4-private"
            cidr = "10.1.4.0/24"
            type = "private"
            availability_zone = "us-east-1b"
        }

    ]

    single_nat_gateway = false
    enable_nat_gateway = true
    one_nat_gateway_per_az = true
    enable_vpn_gateway = false
    enable_dns_hostnames = true

    flow_log_destination_type = "cloud-watch-logs"
}

module "challenge_sg" {
    source = "git::https://github.com/Coalfire-CF/terraform-aws-securitygroup"
    name = "web-sg-${var.region}"
    vpc_id = module.challenge_vpc.vpc_id
    sg_name_prefix = var.prefix

    for_each = module.challenge_vpc.private_subnets_cidr_blocks
     
    ingress_rules = {
        "allow_https" = {
            ip_protocol = "tcp"
            from_port = "443"
            to_port = "443"
            cidr_ipv4 = each.value
            description = "Allow HTTPS"
        }
        "allow_ssh" = {
            ip_protocol = "tcp"
            from_port = "22"
            to_port = "2"
            cidr_ipv4 = each.value
            description = "Allow SSh"
        }
    }

    egress_rules = {
        "allow_all_egress" = {
            ip_protocol = "-1"
            cidr_ipv4 = "0.0.0.0/0"
            description = "Allow all egress"
        }
    }

}