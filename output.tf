output "vpc_id" {
    value = aws_vpc.main.id
   }
    output "public_subnet_ids" {
    value=aws_subnet.public[*].id   
   }

     output "private_subnet_ids" {
    value=aws_subnet.private[*].id  
   }

     output "database_subnet_ids" {
    value=aws_subnet.database[*].id
     }

     output "database_subnet_groups" {
       value=aws.aws_db_subnet_group.default.id
     }

     output "igw_id" {
        value=aws_internet_gateway.gw.id
       
     }

### this is aditional info #####   
# output "vpc_arn" {
#     value = aws_vpc.main.arn
  
# }

# output "zones" {
#     value = data.aws_availability_zones.available.names
# }


