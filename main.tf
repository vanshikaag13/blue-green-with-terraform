resource "aws_lb" "app_lb" {
  name               = "app-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = data.aws_subnets.public_subnets.ids  # Referencing fetched subnets
  tags{
    Name = "BG-ALB"
  }
}


resource "aws_lb_target_group" "blue_tg" {
  name     = "blue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group" "green_tg" {
  name     = "green-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.active_service == "blue" ? aws_lb_target_group.blue_tg.arn : aws_lb_target_group.green_tg.arn
  }
}

resource "aws_ecs_cluster" "blue_green_cluster" {
  name = "BG-Cluster"
  tags{
    Name = "BG-ECS-Cluster"
  }
}

resource "aws_ecs_service" "blue_service" {
  name            = "blue-service"
  cluster         = aws_ecs_cluster.blue_green_cluster.id
  task_definition = aws_ecs_task_definition.blue_task.arn
  desired_count   = 2

  network_configuration {
    subnets          = data.aws_subnets.public_subnets.ids  # Use fetched public subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue_tg.arn
    container_name   = "my-app"
    container_port   = 80
  }
}

resource "aws_ecs_service" "green_service" {
  name            = "green-service"
  cluster         = aws_ecs_cluster.blue_green_cluster.id
  task_definition = aws_ecs_task_definition.green_task.arn
  desired_count   = 2

  network_configuration {
    subnets          = data.aws_subnets.public_subnets.ids  # Use fetched public subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.green_tg.arn
    container_name   = "my-app"
    container_port   = 80
  }
}
