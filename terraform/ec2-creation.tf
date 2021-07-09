provider "aws" {
    region="ap-south-1"
    access_key="Your_access_keys"
    secret_key="Your_Secret_keys"
}
#Create aws instance
resource "aws_instance" "test"{
    ami="ami-011c99152163a87ae"
    instance_type="t2.micro"
    key_name="test"
    security_groups=["my-sg"]
    availability_zone="ap-south-1a"
    count=2

}
