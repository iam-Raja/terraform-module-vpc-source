## VPC CREATION ##

<<<<<<< HEAD
![alt text](terraform-module-vpc-source.vpc.jpg)
=======
![vpc](https://github.com/iam-Raja/terraform-module-vpc-source/assets/149984693/3714ceda-71b3-4132-9f45-582183251f90)

![expenses-dev-terraform](https://github.com/iam-Raja/terraform-module-vpc-source/assets/149984693/7f763ba9-f3b0-45f7-863f-07c3a5471172)

>>>>>>> 92355b92be40dacb84c7a96f83f040b9910d0fef

## Resource Created
* VPC
* Internet Gateway
* Internet and VPC attachment
* 2 Public Subnets.
* 2 Private Subnes
* 2 Database Subnets
* EIP
* NAT Gateway
* Public Route table
* Private Route table
* Database Route table
* Route table and subnet associations
* Routes in all tables
* Peering if required for user
* Routes of peering in requestor and acceptor VPC.
* Database subet group

## Reason for creating  Following Resource

*  VPC
*  Internet gateway : For VPC to access the Internet
*  subnets - 2 public, 2 private 2 DB : create in required multiple AZ's For HA
*  Elasic-IP : As Nat GW is managed by aws we need E-IP
*  Nat-gateway : so, Private subnets can access the internet , In public-subnet
*  Route-tables : public - Internet-GW, private-Nat-GW
*  Routes-association : Associate public-Rotes to Pub-subnets, private- to private-routes
*  Peering - If required for user
*  Peering Routes in requestor and acceptor
*  Database subnet groups


### Inputs
* project_name (Required): User should mention their project name. Type is string.
* environment (Optional): Default value is dev. Type is string.
* common_tags (Required): User should provide their tags related to their project. Type is map.
* vpc_cidr (Optional): Default value is 10.0.0.0/16. Type is string.
* enable_dns_hostnames (Optional): Default value is true. Type is bool.
* vpc_tags (Optional): Default value is empty. Type is map.
* igw_tags (Optional): Default value is empty. Type is map.
* public_subnet_cidrs (Required): User has to provide 2 valid subnet CIDR.
* public_subnet_cidr_tags (Optional): Default value is empty. Type is map.
* private_subnet_cidrs (Required): User has to provide 2 valid subnet CIDR.
* private_subnet_cidr_tags (Optional): Default value is empty. Type is map.
* database_subnet_cidrs (Required): User has to provide 2 valid subnet CIDR.
* database_subnet_cidr_tags (Optional): Default value is empty. Type is map.
* database_subnet_group_tags (Optional): Default value is empty. Type is map.
* nat_gateway_tags (Optional): Default value is empty. Type is map.
* public_route_table_tags (Optional): Default value is empty. Type is map.
* private_route_table_tags (Optional): Default value is empty. Type is map.
* database_route_table_tags (Optional): Default value is empty. Type is map.
* is_peering_required (Optional): Default value is false. Type is bool.
* target_vpc_id (Optional): Default value is empty, default VPC ID would be taken. Type is string.
* vpc_peering_tags (Optional): Default value is empty. Type is map.


### Outputs
* vpc_id: VPC ID
* public_subnet_ids: A list of 2 public subnet IDS created.
* database_subnet_ids: A list of 2 database subnet IDS created.
* private_subnet_ids: A list of 2 private subnet IDS created.
* database_subnet_group_id: A database subnet group ID created.
* igw_id: internte gateway created.
