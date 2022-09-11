[
    {
        "name": "${container_name}",
        "image": "${ecr_repository_url}:latest",
        "essential": true,
        "portMappings": [
            {
                "protocol": "tcp",
                "containerPort": 80,
                "hostPort": 80
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group}",
                "awslogs-region": "ap-northeast-1",
                "awslogs-stream-prefix": "ecs"
            }
        },
        "environment": [
            {
                "name": "ENV_TEST",
                "value": "1"
            }
        ]
    }
]