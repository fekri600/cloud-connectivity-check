module "network" {
  source           = "./modules/network"
  environment      = "network"
  prefix           = local.name_prefix
  project_settings = var.project_settings
  network          = var.network
  load_balancer    = var.load_balancer
  security_groups  = var.security_groups
}


module "staging" {
  source           = "./modules/environment"
  environment      = "staging"
  project_settings = var.project_settings
  prefix           = local.name_prefix

  policies_path   = local.policies
  scripts_path    = local.scripts
  security_groups = var.security_groups

  launch_template       = var.launch_template.staging
  ec2_security_group_id = module.network.ec2_security_group_id
  autoscaling           = var.autoscaling.staging
  target_group_arn      = module.network.target_group_arn

  database              = var.database.staging
  private_subnet_ids    = module.network.private_subnet_ids
  db_security_group_ids = [module.network.db_security_group_id]
  rds_subnet_group_name = module.network.rds_subnet_group_name

  redis                   = var.redis.staging
  redis_subnet_group_name = module.network.redis_subnet_group_name
  redis_security_group_id = module.network.redis_security_group_id

  depends_on = [
    module.network,
  ]
}



module "cloudwatch" {
  source           = "./modules/cloudwatch"
  aws_region       = var.project_settings.aws_region
  logs             = var.logs
  envirnomet = "staging"
  vpc_id = module.network.vpc_id
  depends_on = [
    module.network,
    module.staging,
  ]
}


module "connectivity_staging" {
  source                 = "./modules/connectivity"
  prefix                 = local.name_prefix
  environment            = "staging"
  aws_region             = var.project_settings.aws_region
  logs                   = var.logs 
  rds_address            = module.staging.rds_address
  redis_primary_endpoint = module.staging.redis_primary_endpoint
  ec2_name_tag           = "${local.name_prefix}-staging-ec2"
  db_user                = var.database.staging.username
  database               = var.database.staging
  scripts_path           = local.scripts
}




