# Coalfire Technical Challenge
#### by Liv Levi

## Description

This repo will create an Application Load Balancer and a jump server along with all necessary resources to support the Load Balancer. The ALB listens on port 80, and forwards to an Auto Scaling Group that listens on port 443.

*All required documentiation is included within this README file.

## Solution Diagram:

![Solution Diagram](/images/cftc-diagram.drawio.png)

## Prerequisites:
Environment variables for the AWS access / secret access keys were added along with the name of the bucket that holds terraform state. There is also a tfvars file included, I kept the variable name standard to make it easier to adjust.

## Steps
I've outlined the steps used to create the solution, this is a high level document.

<ol>
    <li>Created repo</li>
    <li>Configure AWS Credentials</li>
    <li>Added environment variables</li>
    <li>Create Actions Workflow to deploy to AWS on push</li>
    <li>Manually create S3 bucket for Terraform State Files</li>
    <li>Setup Terraform providers</li>
    <li>Test pipeline with AWS instance</li>
    <li>Create Actions Workflow (manual) to destroy resources</li>
    <li>Add VPC config using Coalfire VPC module</li>
    <li>Manually created EC2 Key Pair</li>
    <li>Create EC2 instance using Coalfire EC2 module</li>
    <li>Restructure TF files to use variables</li>
    <li>Add S3 Buckets</li>
    <li>Add IAM roles to allow EC2 access to these buckets</li>
    <li>Create EC2 Instance Profile</li>
    <li>Create Launch Template Config</li>
    <li>Allow HTTPS access on instances created via Launch Template</li>
    <li>Create Auto Scaling Group</li>
    <li>Create placement group</li>
    <li>Create Target Group</li>
    <li>Create ALB Listener</li>
    <li>Create Application Load Balancer</li>
    <li>Test access to website via ALB DNS name</li>
</ol>


## Sources:

Coalfire Modules:
https://github.com/orgs/Coalfire-CF/repositories?type=public&q=terraform-aws

tf plan reference:
https://developer.hashicorp.com/terraform/cli/commands/plan

GitHub Actions Workflow Reference:
https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax

ASG Refresher:
https://docs.aws.amazon.com/autoscaling/ec2/userguide/create-your-first-auto-scaling-group.html
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group

S3 Lifecyle Rules:
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration

Security groups:
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group

Application Load Balancer:
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#availability_zone_distribution-1
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
ChatGPT was used to determine if there were any items missing in my configuration (turns out, I forgot the target group), the following was used to corroborate the that the information was correct:
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group

IAM Role:
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

S3:
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

Userdata:
https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/deploying_different_types_of_servers/setting-apache-http-server_deploying-different-types-of-servers
https://www.geeksforgeeks.org/techtips/install-apache-web-server-in-linux/


Troubleshooting:
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table.html

Google was also used, but not all links were helpful.

## Screenshots
![Screenshots](/images/ssh_screenshot.png)
![Corroboration](/images/ssh_corrob.png)

## Notes
I was unable to use the Coalfire Security Group Module as it doesn't export the outputs very well, and I didn't have the time to troubleshoot it. I used the standard Terraform module.

There are ways to improve the security for this solution for example, adding granularity to the Security Groups by only allowing access via certain IP address. However, that wasn't required in the assignment.

## Testing

My testing mainly consisted of verifying that the resources were created with the correct configuration. I tested the ability to SSH from the public subnet into the private subnet. Also, in order to verify that the subnets had access to S3, I used the aws s3 cp command. Lastly, I attempted to access the website via the ALB DNS hostname.

Thank you!