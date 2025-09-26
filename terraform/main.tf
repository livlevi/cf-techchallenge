resource "aws_instance" "test_instance" {
    ami = "ami-0fd3ac4abb734302a"
    instance_type = "t2.nano"
    tags = {
        Name = "test_instance02"
    }
}