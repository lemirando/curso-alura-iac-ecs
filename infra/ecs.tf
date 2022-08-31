module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = var.app_env

  cluster_settings = {
    "name": "containerInsights",
    "value": "enabled"
  }

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/ecs-us-east-1"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }
}

resource "aws_ecs_task_definition" "app_task_us_east_1" {
  family = "app-task-us-east-1"
  requires_compatibilities = [ "FARGATE" ]
  network_mode = "awsvpc"
  cpu = 256
  memory = 512
  execution_role_arn = aws_iam_role.app_role.arn
  container_definitions = jsonencode(
    [
        {
            "name"= "prod"
            "image"= "" # aqui vai a imagem salva no ECR
            "cpu"= 256
            "memory"= 512
            "essential"= true
            "portMappings"= [
                {
                    "containerPort"= 8000
                    "hostPort"= 8000
                }
            ]
        }
    ]
  )
}

resource "aws_ecs_service" "app_service_us_east_1" {
  name = "app-service-us-east-1"
  cluster = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.app_task_us_east_1.arn
  desired_count = 3
  load_balancer {
    target_group_arn = aws_lb_target_group.app_lb_target_group_us_east_1.arn
    container_name = "prod"
    container_port = 8000
  }
  network_configuration {
    subnets = module.vpc_ecs.private_subnets
    security_groups = [ aws_security_group.private_net_sg_us_east_1.id ]
  }
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight = 1
  }
}