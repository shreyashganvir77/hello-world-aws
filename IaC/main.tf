resource "aws_ecs_cluster" "app_cluster" {
  name = "hello-world-nodejs"
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "node-hello-world-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = <<DEFINITION
[
  {
    "name": "node-hello-world",
    "image": "",
    "cpu": 256,
    "memory": 512,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ],
    "essential": true
  }
]
DEFINITION
}

resource "aws_ecs_service" "app_service" {
  name            = "node-hello-world-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [""]
    security_groups  = ""
    assign_public_ip = true
  }

  desired_count = 1
}
