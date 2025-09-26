resource "aws_instance" "test_instance" {
    ami = "ami-08982f1c5bf93d976"
    instance_type = "t2.nano"
    tags = {
        Name = "test_instance02"
    }
}