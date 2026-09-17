resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cider

  tags = {
    Name = var.vpc_name
  }
}

# resource "aws_vpc" "vpcs" {
#   for_each = var.vpcs

#   cidr_block = each.value.cidr_block
#   tags = {
#     Name = each.value.name
#   }
# }

resource "aws_internet_gateway" "vpc_igw" {
  count = length(var.public_subnet) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}


resource "aws_subnet" "vpc_public_subnet" {
  for_each = var.public_subnet

  # vpc_id                  = aws_vpc.vpc[each.value.vpc_name].id
  vpc_id = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip

  tags = {
    Name = each.key
  }
}


resource "aws_subnet" "vpc_private_subnet" {
  for_each = var.private_subnet

  # vpc_id            = aws_vpc.vpc[each.value.vpc_name].id
  vpc_id = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.key
  }
}


resource "aws_route" "route_igw" {
  count = length(var.public_subnet) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public_route_table[0].id
  destination_cidr_block = var.allow_all_ip_cidr
  gateway_id             = aws_internet_gateway.vpc_igw[0].id
}


resource "aws_eip" "this" {
  domain     = "vpc"
  for_each   = local.nat_az
  depends_on = [aws_internet_gateway.vpc_igw]
}

resource "aws_nat_gateway" "this" {
  for_each = local.nat_az

  allocation_id = aws_eip.this[each.key].id
  subnet_id     = aws_subnet.vpc_public_subnet[each.value].id
  depends_on    = [aws_internet_gateway.vpc_igw]
  tags = {
    "Name" = "${var.vpc_name}-${each.key}-nat"
  }
}


resource "aws_route_table" "public_route_table" {
  count = length(var.public_subnet) > 0 ? 1 : 0
  # for_each = local.public_route_table_vpcs

  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}-${var.suffix_for_public_route_table}"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.vpc_public_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table[0].id
}


resource "aws_route_table" "private_nat" {
  for_each = local.nat_route_subnets
  vpc_id   = aws_vpc.vpc.id

  tags = {
    "Name" = "${each.key}-route-table"
  }
}


resource "aws_route" "private_nat" {
  for_each       = local.nat_route_subnets
  route_table_id = aws_route_table.private_nat[each.key].id

  destination_cidr_block = var.allow_all_ip_cidr
  nat_gateway_id         = aws_nat_gateway.this[each.value.availability_zone].id
}

resource "aws_route_table_association" "private_nat" {
  for_each = local.nat_route_subnets

  route_table_id = aws_route_table.private_nat[each.key].id
  subnet_id      = aws_subnet.vpc_private_subnet[each.key].id

}

resource "aws_subnet" "db_subnet" {
  for_each = var.db_subnet

  # vpc_id = aws_vpc.vpc[each.value.vpc_name].id
  # vpc_id = aws_vpc.vpcs
  vpc_id = aws_vpc.vpc.id

  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block

  tags = {
    "Name" = each.key
  }
}
