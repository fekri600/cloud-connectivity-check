# Create all required CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "this" {

  name              = var.logs.group_path
  retention_in_days = var.logs.retention_in_days
  tags = {
    VpcId = var.vpc_id
  }
}

