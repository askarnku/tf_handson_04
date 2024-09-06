# create vpc:
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "vpc"
  }

}

data "aws_availability_zones" "azs" {
  state = "available"
}

# create 2 public subnets:
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.0/26"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.azs.names[0]

  tags = {
    Name = "public_1a"
  }

}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.64/26"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.azs.names[1]

  tags = {
    Name = "public_1b"
  }

}

# create 2 private subnets:
resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.128/26"
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.azs.names[0]

  tags = {
    Name = "private_1a"
  }

}

resource "aws_subnet" "private_1b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.192/26"
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.azs.names[1]

  tags = {
    Name = "private_1b"
  }

}

# create igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "igw"
  }
}

# create eip
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "igw"
  }

}

# create nat gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name = "nat_gw"
  }
}

# create rtb for 2 public subnets
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rtb"
  }
}

# create private route table for 2 private subnets
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private_rtb"
  }
}

#create route table associations for 2 public subnets
resource "aws_route_table_association" "pubic_assn_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "pubic_assn1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public_rtb.id
}

# create route table associations for 2 private subnets
resource "aws_route_table_association" "private_assn_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_rtb.id
}

resource "aws_route_table_association" "private_assn_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.private_rtb.id
}

# Create security group for public instances
# get the ami for linux 2023
data "aws_ami" "al2023" {
  most_recent = true

  owners = ["amazon"] # Canonical
  filter {
    name   = "name"
    values = ["al2023-*-kernel-6.1-x86_64"]
  }
}

# get the security key name
data "aws_key_pair" "ssh_key" {
  key_name = "id_ed25519"
}

# create security group
resource "aws_security_group" "allow_ssh_http" {
  vpc_id = aws_vpc.main_vpc.id
  name   = "allow_ssh_http"

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "handson_tf_04"
  }
}

# create webserver subnet 1a
resource "aws_instance" "web_server_1a" {
  ami                    = "ami-0182f373e66f89c85"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_1a.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name               = data.aws_key_pair.ssh_key.key_name
  user_data              = filebase64("script.sh")
  tags = {
    Name = "public_server_1a"
  }
}

# create web server subnet 1b
resource "aws_instance" "web_server_1b" {
  ami                    = "ami-0182f373e66f89c85"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_1b.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name               = data.aws_key_pair.ssh_key.key_name
  user_data              = filebase64("script.sh")
  tags = {
    Name = "public_server_1b"
  }
}




