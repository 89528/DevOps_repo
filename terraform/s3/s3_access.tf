provider "aws" {
  region  = "ap-south-1"
  profile = "myaccount"
}
variable "vpc_id" {
  default = "vpc-0cc73f4510730wx3"
}
variable "dns_zone_id" {
  default = "Z08640813BTP1I80YCH04"
}

variable "bucket_name" {
  type    = list(string)
  default = ["apk-config", "assets", "assets-sources", "assets-dev", "dev", "elasticbeanstalk"]
}
