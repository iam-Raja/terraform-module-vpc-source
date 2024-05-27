######### Project ################

variable "project_name" {
    type = string
}

variable "environment" {
    type=string
    default="Dev"
 
}

variable "common_tags" {
    type=map

}


#### vpc ############

variable "cidr" {
    type=string
    default="10.0.0.0/16"
}

variable "dns-hs" {
  type=bool
  default = true
}

 
variable "vpc_tags" {
    type = map
    default = {}
}

#### IGW ###
variable "igw_tags" {
   default = {}  
}


### public-subnet #####

variable "public_subnet_cidrs" {
   validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Provide valid subnet two public subnets CIDRS."
  }
}

variable "public_subnet_cidrs_tags" {
    default = {}
  
}


##### private-subnet ########
variable "private_subnet_cidrs" {
   validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Provide valid subnet two private subnets CIDRS."
  }
}

variable "private_subnet_cidrs_tags" {
    default = {}
  
}



#### database-subnet #######3

variable "database_subnet_cidrs" {
   validation {
    condition     = length(var.database_subnet_cidrs) == 2
    error_message = "Provide valid subnet two database subnets CIDRS."
  }
}

variable "database_subnet_cidrs_tags" {
    default = {}
  
}

variable "db_subnet_grops_tags" {
    default = {}
  
}


#### route-public #####
variable "public_route_tags" {
    default = {}
  
}

#### route-private #####
variable "private_route_tags" {
    default = {}
  
}

#### route-database #####
variable "database_route_tags" {
    default = {}
  
}

#### nat-gw-tags ####
variable "nat_gw_tags" {
    default = {}
  
}


## Vpc-peering ###

variable "is_peering_required" {
    type=bool
    default=false
  
}

variable "target_vpc_id" {
    default = {}
}

variable "vpc_peering_tags" {
    type=map
    default = {}  
}