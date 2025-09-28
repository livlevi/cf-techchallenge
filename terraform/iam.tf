resource "aws_iam_role" "ec2_s3_role" {
    name = "${var.prefix}-${var.role_name}"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ]
    })
}

resource "aws_iam_policy" "ec2_s3_policy" {
    name = "${var.prefix}-${var.policy_name}"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "s3:GetObject",
                    "s3:PutObject",
                    "s3:ListBucket",
                    "s3:DeleteObject",
                    "s3:GetObjectVersion"
                ]
                Resource = [
                    "${aws_s3_bucket.images_bucket.arn}",
                    "${aws_s3_bucket.logs_bucket.arn}"
                ]
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_attach" {
    role = aws_iam_role.ec2_s3_role.name
    policy_arn = aws_iam_policy.ec2_s3_policy.arn
    
}

resource "aws_iam_instance_profile" "ec2_s3_instance_attach" {
    name = "${var.prefix}-${var.instance_profile}"
    role = aws_iam_role.ec2_s3_role.name
}