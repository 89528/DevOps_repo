resource "aws_vpc" "my_vpc_prod" {

  assign_generated_ipv6_cidr_block = false
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  cidr_block                       = "172.12.0.0/16"
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = {
    Name        = "mini-prod"
    Provisioner = "Terrafrom"
  }

}
data "aws_availability_zones" "az" {}

resource "aws_subnet" "public-web-a" {
  vpc_id                  = "${aws_vpc.my_vpc_prod.id}"
  cidr_block              = "${cidrsubnet(172.24.0.0/16, 4, 0)}"
  availability_zone       = "${data.aws_availability_zones.az.names[0]}"
  map_public_ip_on_launch = true

  tags = {
    Name        = "mini-prod-public-web-a"
    Provisioner = "Terrafrom"
  }
}
resource "aws_subnet" "public-web-b" {
  vpc_id                  = "${aws_vpc.my_vpc_prod.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 4, 12)}"
  availability_zone       = "${data.aws_availability_zones.az.names[1]}"
  map_public_ip_on_launch = true

  tags = {
    Name        = "mini-prod-public-web-b"
    Provisioner = "Terrafrom"
  }
}
resource "aws_subnet" "public-web-a2" {
  vpc_id                  = "${aws_vpc.my_vpc_prod.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 4, 1)}"
  availability_zone       = "${data.aws_availability_zones.az.names[0]}"
  map_public_ip_on_launch = true

  tags = {
    Name        = "mini-prod-public-web-a2"
    Provisioner = "Terrafrom"
  }
}
resource "aws_subnet" "private-server-a" {
  vpc_id                  = "${aws_vpc.my_vpc_prod.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 4, 3)}"
  availability_zone       = "${data.aws_availability_zones.az.names[0]}"
  map_public_ip_on_launch = false

  tags = {
    Name        = "mini-prod-private-server-a"
    Provisioner = "Terrafrom"
  }
}

resource "aws_subnet" "private-database-a" {
  vpc_id                  = "${aws_vpc.my_vpc_prod.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 4, 6)}"
  availability_zone       = "${data.aws_availability_zones.az.names[0]}"
  map_public_ip_on_launch = false

  tags = {
    Name                           = "mini-prod-private-database-a"
    Provisioner                    = "Terrafrom"
  }
}
resource "aws_subnet" "private-database-b" {
  vpc_id                  = "${aws_vpc.my_vpc_prod.id}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, 4, 8)}"
  availability_zone       = "${data.aws_availability_zones.az.names[1]}"
  map_public_ip_on_launch = false

  tags = {
    Name                           = "mini-prod-private-database-b"
    Provisioner                    = "Terrafrom"
    }
}
##IGW subnet for all public traffic
resource "aws_internet_gateway" "vpc-gw" {
  vpc_id = "${aws_vpc.my_vpc_prod.id}"

  tags = {
    Name        = "mini-prod-igw"
    Provisioner = "Terrafrom"
  }
}
resource "aws_eip" "nat-eip-server-a" {
  vpc = true
}
##NAT gateway server a
resource "aws_nat_gateway" "natgateway-prod" {
  allocation_id = "${aws_eip.nat-eip-server-a.id}"
  subnet_id     = "${aws_subnet.public-web-a.id}"
  tags = {
    Name        = "mini-prod-natgateway"
    Provisioner = "Terrafrom"
  }
}
resource "aws_route_table" "public-web" {
  vpc_id = "${mini-prod_vpc_prod.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc-gw.id}"
  }
  tags = {
    Name        = "${var.vpc_name}-rt-public-web"
    Provisioner = "Terrafrom"
  }
}
resource "aws_route_table" "public-web2" {
  vpc_id = "${aws_vpc.my_vpc_prod.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc-gw.id}"
  }
  tags = {
    Name        = "mini-prod-rt-public-web2"
    Provisioner = "Terrafrom"
  }
}
resource "aws_route_table" "rt-private" {
  vpc_id = "${aws_vpc.my_vpc_prod.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.natgateway-prod.id}"
  }

  tags = {
    Name        = "mini-prod-rt-private"
    Provisioner = "Terrafrom"
  }
}
##public Subnet association with public routing table
resource "aws_route_table_association" "subnet-rt-web-a" {
  subnet_id      = "${aws_subnet.public-web-a.id}"
  route_table_id = "${aws_route_table.public-web.id}"
}
resource "aws_route_table_association" "subnet-rt-web-a2" {
  subnet_id      = "${aws_subnet.public-web-a2.id}"
  route_table_id = "${aws_route_table.public-web2.id}"
}

##Private subnet association with private routing tables
resource "aws_route_table_association" "subnet-rt-server-a" {
  subnet_id      = "${aws_subnet.private-server-a.id}"
  route_table_id = "${aws_route_table.rt-private.id}"
}
##Private subnet association with private routing tables
resource "aws_route_table_association" "private-database-a" {
  subnet_id      = "${aws_subnet.private-database-a.id}"
  route_table_id = "${aws_route_table.rt-private.id}"
}
resource "aws_route_table_association" "private-database-b" {
  subnet_id      = "${aws_subnet.private-database-b.id}"
  route_table_id = "${aws_route_table.rt-private.id}"
}

resource "aws_security_group" "ec2-sg" {
  vpc_id      = "${aws_vpc.my_vpc_prod.id}"
  name        = "${var.vpc_name}-web-sg"
  description = "web-EC2-security-group"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "mini-prod-web-sg"
    Provisioner = "Terrafrom"
  }
}

resource "aws_security_group" "ec2-app-sg" {
  vpc_id      = "${aws_vpc.my_vpc_prod.id}"
  name        = "mini-prod-sg"
  description = "apps-EC2-security-group"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.24.0.0/16"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.24.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "mini-prod-apps-sg"
    Provisioner = "Terrafrom"
  }
}
resource "aws_security_group" "ec2-db-sg" {
  vpc_id      = "${aws_my_vpc_prod.id}"
  name        = "mini-prod-db-sg"
  description = "appslb-EC2-security-group"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["172.24.0.0/16"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.24.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "mini-prod-db-sg"
    Provisioner = "Terrafrom"
  }
}

locals {
  description = "Private zone for ${var.route_name}"
}
resource "aws_route53_zone" "main" {
  name = "${var.route_name}"

  vpc {
    vpc_id = "${aws_vpc.my_vpc_prod.id}"
  }

  comment = "${local.description}"

  tags = {
    "Name"      = "${var.route_name}"
    Provisioner = "Terrafrom"
  }
}


# resource "aws_route53_zone" "prod" {
#   name = "${var.route_name_prod}"
#
#   vpc {
#     vpc_id = "${aws_vpc.my_vpc_prod.id}"
#   }
#   comment = "${var.route_name_prod}"
#   tags = {
#     "Name"      = "${var.route_name_prod}"
#     Provisioner = "Terrafrom"
#   }
# }

resource "aws_default_network_acl" "mini-prod" {
  default_network_acl_id = aws_vpc.my_vpc_prod.default_network_acl_id


  ingress {
    protocol   = -1
    rule_no    = 150
    action     = "allow"
    cidr_block = aws_vpc.my_vpc_prod.cidr_block
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = -1
    rule_no    = 250
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  subnet_ids = [aws_subnet.public-web-a.id, aws_subnet.public-web-a2.id, aws_subnet.private-server-a.id, aws_subnet.private-database-a.id]
  tags = {
    Name        = "${var.vpc_name}-nacl"
    Provisioner = "Terrafrom"
  }
}
