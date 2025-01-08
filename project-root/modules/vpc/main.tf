resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Subnet_1
resource "aws_subnet" "web_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.web_subnet_1_cidr
  availability_zone       = var.subnet_1_az
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-web_subnet_1"
  }
}

# Subnet_2
resource "aws_subnet" "web_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.web_subnet_2_cidr
  availability_zone       = var.subnet_2_az
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-web_subnet_2"
  }
}
# Private Subnet 1
resource "aws_subnet" "app_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.app_subnet_1_cidr
  availability_zone       = var.subnet_1_az
  map_public_ip_on_launch = false  # Ensures no public IP is assigned
  tags = {
    Name = "${var.vpc_name}-app_subnet_1"
  }
}

# Private Subnet 2
resource "aws_subnet" "app_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.app_subnet_2_cidr
  availability_zone       = var.subnet_2_az
  map_public_ip_on_launch = false  # Ensures no public IP is assigned
  tags = {
    Name = "${var.vpc_name}-app_subnet_2"
  }
}
# Private db Subnet 1
resource "aws_subnet" "db_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.db_subnet_1_cidr
  availability_zone       = var.subnet_1_az
  map_public_ip_on_launch = false  # Ensures no public IP is assigned
  tags = {
    Name = "${var.vpc_name}-db_subnet_1"
  }
}

# Private db Subnet 2
resource "aws_subnet" "db_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.db_subnet_2_cidr
  availability_zone       = var.subnet_1_az
  map_public_ip_on_launch = false  # Ensures no public IP is assigned
  tags = {
    Name = "${var.vpc_name}-db_subnet_2"
  }
}
# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

# NAT Gateway for Outbound Traffic
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id  # Elastic IP for NAT Gateway
  subnet_id     = aws_subnet.web_subnet_1.id  # A public subnet
  tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

# Private Route Table Routes
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Associate Private Subnet 1 with Private Route Table
resource "aws_route_table_association" "app_subnet_1_association" {
  subnet_id      = aws_subnet.app_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

# Associate Private Subnet 2 with Private Route Table
resource "aws_route_table_association" "app_subnet_2_association" {
  subnet_id      = aws_subnet.app_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}
# Associate db Subnet 1 with Private Route Table
resource "aws_route_table_association" "db_subnet_1_association" {
  subnet_id      = aws_subnet.db_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

# Associate db Subnet 2 with Private Route Table
resource "aws_route_table_association" "db_subnet_2_association" {
  subnet_id      = aws_subnet.db_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

# Database Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.vpc_name}-db-subnet-group"
  subnet_ids = [aws_subnet.db_subnet_1.id , aws_subnet.db_subnet_2.id]
  tags = {
    Name = "${var.vpc_name}-db-subnet-group"
  }
}
# Security group for EC2 (App tier)
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Security group for the EC2 app tier"
  vpc_id      = aws_vpc.main.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # You can restrict this to specific ranges if needed
  }
}

#elb security group
resource "aws_security_group" "elb_sg" {
  vpc_id = aws_vpc.main.id

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
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Routing Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc_name}-main-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "web_subnet_1" {
  subnet_id      = aws_subnet.web_subnet_1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "web_subnet_2" {
  subnet_id      = aws_subnet.web_subnet_2.id
  route_table_id = aws_route_table.main.id
}

# Security Groups
resource "aws_security_group" "web_subnet_1sg" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-web_subnet_1sg"
  }
}

resource "aws_security_group" "web_subnet_2sg" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-web_subnet_2sg"
  }
}
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main.id
egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    from_port   = 3306  # MySQL port (adjust if you're using another database)
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.app_sg.id]  # Allow traffic from EC2's app_sg
  }

  
  tags = {
    Name = "${var.vpc_name}-db_sg"
  }
}