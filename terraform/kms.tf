module "challenge_kms" {
    source = "git::https://github.com/Coalfire-CF/terraform-aws-kms.git"

    resource_prefix = "cf"
    kms_key_resource_type = "ec2-kms"

    
}