resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.eks_name}-vpc"
  }
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "${var.eks_name}-igw"
  }
}

resource "aws_subnet" "eks_subnet_private" {
  count                   = var.private_subnet_count
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.eks_name}-subnet-${count.index}"
  }
}


resource "aws_eip" "nat_eip" {
  count  = length(aws_subnet.eks_subnet_private)
  domain = "vpc"
  tags = {
    Name = "${var.eks_name}-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(aws_subnet.eks_subnet_private)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.eks_subnet_private[count.index].id
  tags = {
    Name = "${var.eks_name}-nat-gateway-${count.index}"
  }

  depends_on = [
    aws_internet_gateway.eks_igw
  ]
}

resource "aws_route_table" "eks_route_table" {
  count = length(aws_subnet.eks_subnet_private)

  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.eks_name}-route-table-${count.index}"
  }
}

resource "aws_route" "eks_routes" {
  count                  = length(aws_subnet.eks_subnet_private)
  route_table_id         = aws_route_table.eks_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
}


resource "aws_route_table_association" "eks_route_table_association" {
  count          = length(aws_subnet.eks_subnet_private)
  subnet_id      = aws_subnet.eks_subnet_private[count.index].id
  route_table_id = aws_route_table.eks_route_table[count.index].id
}
