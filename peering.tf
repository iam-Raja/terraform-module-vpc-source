### VPC-Peering ###

resource "aws_vpc_peering_connection" "peering" {
  count= var.is_peering_required ? 1 : 0
  peer_vpc_id   = aws_vpc.main.id  ## requstor
  vpc_id        = var.target_vpc_id == "" ? data.aws_vpc.default.id : var.target_vpc_id  ## acceptor
  auto_accept = var.target_vpc_id == "" ? true : false
    tags = merge (
        var.vpc_peering_tags ,
        var.common_tags,
        {
            Name=local.resource_name
        }
    )
}

  ##### pub-peering #########

  resource "aws_route" "PUBLIC_PEERING" {
  count= var.is_peering_required &&  var.target_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id ## as peerinf resource is created via count so we should give list[] 
  }

    ##### pri-peering #########

  resource "aws_route" "PRIVATE_PEERING" {
  count= var.is_peering_required &&  var.target_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  }

    ##### Database-peering #########

  resource "aws_route" "DB_PEERING" {
  count= var.is_peering_required &&  var.target_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  }

  
    ##### default-main -peering #########

  resource "aws_route" "deafult_main_PEERING" {
  count= var.is_peering_required &&  var.target_vpc_id == "" ? 1 : 0
  route_table_id            = data.aws_route_table.main.id
  destination_cidr_block    = var.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  }

