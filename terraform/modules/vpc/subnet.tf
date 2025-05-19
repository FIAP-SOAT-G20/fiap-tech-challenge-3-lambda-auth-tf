data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "fastfood_vpc_subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.fastfood_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.fastfood_vpc.cidr_block, 8, count.index * 2 + 1)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
}