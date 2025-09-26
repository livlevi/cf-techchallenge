module "challenge_vpc" {
    source = "git::https://github.com/Coalfire-CF/terraform-aws-vpc-nfw.git"
    name = "cf-challenge-vpc"
    cidr = "10.1.0.0/16"
    azs = [ "us-east-1a", "us-east-1b" ]

    subnets = [
        
        # Public Subnets
        {
            tag = "subnet01-public"
            cidr = "10.1.0.0/24"
            type = "public"
            availability_zone = "us-east-1a"
        },
        {
            tag = "subnet02-public"
            cidr = "10.1.1.0/24"
            type = "public"
            availability_zone = "us-east-1b"
        },
        # Private subnets
        {
            tag = "subnet03-private"
            cidr = "10.1.2.0/24"
            type = "private"
            availability_zone = "us-east-1a"
        },
        {
            tag = "subnet04-private"
            cidr = "10.1.4.0/24"
            type = "private"
            availability_zone = "us-east-1b"
        }

    ]

    single_nat_gateway = false
    enable_nat_gateway = true
    one_nat_gateway_per_az = true
    enable_vpn_gateway = false
    enable_dns_hostname = true
}