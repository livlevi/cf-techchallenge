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

resource "aws_security_group" "lt_security_group" {
    name = "allow_ssh_https_sg"

    vpc_id = module.challenge_vpc.vpc_id

}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {

    for_each = module.challenge_vpc.private_subnets_cidr_blocks

    security_group_id = aws_security_group.lt_security_group.id
    cidr_ipv4 = each.value
    from_port = 443
    ip_protocol = "tcp"
    to_port = 443

    tags = {
        Name = "sg-for-subnet-${each.value}"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {

    for_each = module.challenge_vpc.private_subnets_cidr_blocks

    security_group_id = aws_security_group.lt_security_group.id
    cidr_ipv4 = each.value
    from_port = 22
    ip_protocol = "tcp"
    to_port = 22

    tags = {
        Name = "sg-for-subnet-${each.value}"
    }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
    security_group_id = aws_security_group.lt_security_group.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_security_group" "public_security_group" {
    name = "allow_http_public_sg"

    vpc_id = module.challenge_vpc.vpc_id

}

resource "aws_vpc_security_group_ingress_rule" "allow_http_public" {

    for_each = module.challenge_vpc.public_subnets_cidr_blocks

    security_group_id = aws_security_group.public_security_group.id
    cidr_ipv4 = each.value
    from_port = 80
    ip_protocol = "tcp"
    to_port = 80

    tags = {
        Name = "sg-for-subnet-${each.value}"
    }
}

# resource "aws_vpc_security_group_ingress_rule" "allow_ssh_public" {
# 
#     for_each = module.challenge_vpc.public_subnets_cidr_blocks
# 
#     security_group_id = aws_security_group.public_security_group.id
#     cidr_ipv4 = each.value
#     from_port = 22
#     ip_protocol = "tcp"
#     to_port = 22
# 
#     tags = {
#         Name = "sg-for-subnet-${each.value}"
#     }
# }

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_public" {
    security_group_id = aws_security_group.public_security_group.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}