module "vpc" {
  source = "git::https://github.com/pavanbairu/tf-module-vpc.git"

  for_each         = var.vpc
  cidr_block       = each.value["cidr_block"]
  subnets          = each.value["subnets"]
  default_vpc_id   = var.default_vpc_id
  default_vpc_cidr = var.default_vpc_cidr
  default_vpc_rtid = var.default_vpc_rtid
  tags             = local.tags
  env              = var.env
}

#module "web" {
#  source = "git::https://github.com/pavanbairu/tf-module-app.git"
#
#  for_each      = var.app
#  instance_type = each.value["instance_type"]
#  name          = each.value["name"]
#  desired_capacity  = each.value["desired_capacity"]
#  max_size          = each.value["max_size"]
#  min_size          = each.value["min_size"]
#
#  env           = var.env
#  bastion_cidr  = var.bastion_cidr
#  tags          = local.tags
#
#  subnet_ids     = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
#  vpc_id        = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
#  allow_app_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_app_cidr"], null), "subnet_cidrs", null)
#}



#variable "port_number" {
#  default = 27017
#}


module "docdb" {
  source = "git::https://github.com/pavanbairu/tf-module-docdb.git"

  for_each      = var.docdb
  subnets       = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  vpc_id        = local.vpc_id
  tags          = local.tags
  env           = var.env
  allow_db_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)
  kms_arn       = var.kms_arn
  engine_version = each.value["engine_version"]
}

