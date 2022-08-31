resource "aws_iam_role_policy" "policy_app_role" {
  role = aws_iam_role.app_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:GreateLogStream",
                "logs:PutLogEvents"
            ]
            Effect = "Allow"
            Resource = "*"
        }
    ]
  })
}

resource "aws_iam_role" "app_role" {
  name = "${var.app_role}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid = ""
            Principal = {
                Service = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
            }
        }
    ]
  })
}

resource "aws_iam_instance_profile" "app_profile" {
  name = var.app_profile
  role = aws_iam_role.app_role.name
}