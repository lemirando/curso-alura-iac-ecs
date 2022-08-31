module "prod" {
    source = "../../infra"
    repo_name = "prod"
    app_role = "prod"
    app_profile = "prod"
    app_env = "prod"
}

output "app_lb_ip_main_us_east_1" {
    value = module.prod.app_lb_ip_us_east_1
}