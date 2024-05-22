resource "aws_ecs_task_definition" "service" {
  family                = "service"
  network_mode          = "awsvpc"
  execution_role_arn    = "arn:aws:iam::362611231749:role/ecsTaskExecutionRole"
  requires_compatibilities = ["FARGATE"]
  cpu       = 256
  memory    = 512
  container_definitions = jsonencode([{
    name      = "my-app"
    image     = "nginx:latest"
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

resource "aws_ecs_service" "my-service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.hellocloud-cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = [aws_subnet.dev-public-subnet.id]
    security_groups = [aws_security_group.ecs-service-sg.id]
    assign_public_ip = true
  }
}