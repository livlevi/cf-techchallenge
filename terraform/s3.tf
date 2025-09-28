resource "random_id" "suffix_hash" {
    byte_length = 6
}

resource "aws_s3_bucket" "images_bucket" {
    bucket = "${var.prefix}-images-${random_id.suffix.hex}"
}

resource "aws_s3_object" "images_bucket_object" {
    bucket = aws_s3_bucket.images_bucket.id
    key = "Memes"
}

resource "aws_s3_bucket_lifecycle_configuration" "images_transition" {
    bucket = aws_s3_bucket.images_bucket.id

    rule {
        id = "move objects older than 90 days to glacier"

        filter {
            prefix = "Memes/"
        }

        status = "Enabled"

        transition {
            days = 90
            storage_class = "GLACIER"
        }
    }
 
}

resource "aws_s3_bucket" "logs_bucket" {
    bucket = "${var.prefix}-logs-${random_id.suffix.hex}"
}

resource "aws_s3_object" "logs_bucket_object" {
    bucket = aws_s3_bucket.logs_bucket.id
    key = "Active folder"
}

resource "aws_s3_object" "logs_bucket_object" {
    bucket = aws_s3_bucket.logs_bucket.id
    key = "Inactive folder"
}

resource "aws_s3_bucket_lifecycle_configuration" "logs_active_transition" {
    bucket = aws_s3_bucket.logs_bucket.id

    rule {
        id = "move objects older than 90 days to glacier"

        filter {
            prefix = "Active folder/"
        }

        status = "Enabled"

        transition {
            days = 90
            storage_class = "GLACIER"
        }
    }
 
}

resource "aws_s3_bucket_lifecycle_configuration" "logs_active_transition" {
    bucket = aws_s3_bucket.logs_bucket.id

    rule {
        id = "move objects older than 90 days to glacier"

        filter {
            prefix = "Inactive folder/"
        }

        status = "Enabled"

        expiration {
            days = 90
        }
    }
 
}