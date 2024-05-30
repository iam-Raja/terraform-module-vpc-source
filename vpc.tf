resource "aws_vpc" "main" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  enable_dns_hostnames = var.dns-hs
  tags = merge (
        var.vpc_tags ,
        var.common_tags,
        {
            Name=local.resource_name
        }
    )
}

##### IGW ########

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge (
        var.igw_tags,
        var.common_tags,
        {
            Name=local.resource_name
        }
    )
}

#### 

resource "aws_subnet" "public" {
  count=length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  cidr_block = var.public_subnet_cidrs[count.index]

  tags = merge (
        var.public_subnet_cidrs_tags ,
        var.common_tags,
        {
            Name="${local.resource_name}-public-${local.az_names[count.index]}"
        }
    )
}

#### private ##########

resource "aws_subnet" "private" {
  count=length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  availability_zone = local.az_names[count.index]
  # map_public_ip_on_launch = true `            not required as this private
  cidr_block = var.private_subnet_cidrs[count.index]

  tags = merge (
        var.private_subnet_cidrs_tags ,
        var.common_tags,
        {
            Name="${local.resource_name}-private-${local.az_names[count.index]}"
        }
    )
}

##### database #######

resource "aws_subnet" "database" {
  count=length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  availability_zone = local.az_names[count.index]
  # map_public_ip_on_launch = true not required as this private
  cidr_block = var.database_subnet_cidrs[count.index]

  tags = merge (
        var.database_subnet_cidrs_tags ,
        var.common_tags,
        {
            Name="${local.resource_name}-database-${local.az_names[count.index]}"
        }
    )
}

resource "aws_db_subnet_group" "default" {
  name       = "${local.resource_name}"
  subnet_ids = aws_subnet.database[*].id

  tags = merge (
        var.db_subnet_grops_tags ,
        var.common_tags,
        {
            Name="${local.resource_name}"
        }
    )
}

#### E_IP  ########

resource "aws_eip" "E_IP" {
  domain   = "vpc"
    tags = merge (
        var.igw_tags,
        var.common_tags,
        {
            Name=local.resource_name
        }
    )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.E_IP.id
  subnet_id     = aws_subnet.public[0].id  #this lauch in first public subnet

   tags = merge (
        var.nat_gw_tags ,
        var.common_tags,
        {
            Name=local.resource_name
        }
    )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}


### route- public ####

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge (
        var.public_route_tags ,
        var.common_tags ,
        {
            Name="${local.resource_name}-public"
        }
    )
  }

### route-private ####

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge (
        var.private_route_tags ,
        var.common_tags ,
        {
            Name="${local.resource_name}-private"
        }
    )
  }


  ### route-database ####

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags = merge (
        var.database_route_tags ,
        var.common_tags ,
        {
            Name="${local.resource_name}-database"
        }
    )
  }

  ##### public-routes #########

  resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

  ##### private-routes #########

  resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

  ##### dayabase-routes #########
  resource "aws_route" "databse" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}


#### pub-routes-assocaition #########3

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public.id
}

#### private-routes-assocaition #########3

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private.id
}

#### Database-routes-assocaition #########3

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = element(aws_subnet.database[*].id,count.index)
  route_table_id = aws_route_table.database.id
}


