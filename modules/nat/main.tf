resource "aws_eip" "eip-nat-a" {
  domain = "vpc"

  tags = {
    Name = "eip-nat-a"
  }
}

resource "aws_eip" "eip-nat-b" {
  domain = "vpc"

  tags = {
    Name = "eip-nat-b"
  }
}

// nat gatway for public subnet pub-sub-1a
resource "aws_nat_gateway" "nat-a" {
  allocation_id = aws_eip.eip-nat-a.id
  subnet_id     = aws_subnet.pub_sub_1a.id

  tags = {
    Name = "nat-a"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.igw_id]
}

resource "aws_nat_gateway" "nat-b" {
  allocation_id = aws_eip.eip-nat-b.id
  subnet_id     = aws_subnet.pub_sub_2b.id

  tags = {
    Name = "nat-a"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.igw_id]
}

resource "aws_route_table" "pri-rt-a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nat-a.id
  }

  tags = {
    Name = "Pri-rt-a"
  }
}

resource "aws_route_table_association" "pri-sub-3a-with-Pri-rt-a" {
  subnet_id      = aws_subnet.pub_sub_3a.id
  route_table_id = aws_route_table.pri-rt-a.id
}

resource "aws_route_table_association" "pri-sub-4b-with-Pri-rt-b" {
  subnet_id      = aws_subnet.pub_sub_4b.id
  route_table_id = aws_route_table.pri-rt-a.id
}

resource "aws_route_table" "pri-rt-b" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nat-b.id
  }

  tags = {
    Name = "Pri-rt-b"
  }
}

resource "aws_route_table_association" "pri-sub-5a-with-Pri-rt-b" {
  subnet_id      = aws_subnet.pub_sub_5a.id
  route_table_id = aws_route_table.pri-rt-b.id
}

resource "aws_route_table_association" "pri-sub-6b-with-Pri-rt-b" {
  subnet_id      = aws_subnet.pub_sub_6b.id
  route_table_id = aws_route_table.pri-rt-b.id
}
