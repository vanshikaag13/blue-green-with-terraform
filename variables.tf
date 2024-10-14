variable "active_service" {
  description = "Which ECS service (blue or green) is active"
  default     = "blue"
}

variable "app_image" {
  description = "Docker image to use for the application"
  default     = "nginx:latest"
}
