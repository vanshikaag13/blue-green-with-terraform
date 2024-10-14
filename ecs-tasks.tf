resource "aws_ecs_task_definition" "blue_task" {
  family                   = "blue-service"
  container_definitions    = jsonencode([{
    name      = "my-app"
    image     = var.app_image
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 80
    }]
  }])
}

resource "aws_ecs_task_definition" "green_task" {
  family                   = "green-service"
  container_definitions    = jsonencode([{
    name      = "my-app"
    image     = var.app_image
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 80
    }]
  }])
}
