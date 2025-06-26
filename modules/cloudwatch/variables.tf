variable "aws_region" { type = string }
variable "envirnomet" {
  type = string
}

variable "vpc_id" { type = string }



variable "logs" {
  description = "CloudWatch log configuration for all services"
  type = object({
    retention_in_days = number
    group_path       = string
  })
}





