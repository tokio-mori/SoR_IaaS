resource "aws_api_gateway_vpc_link" "vpc_link" {
  name = "vpc-link"
  description = "VPC Link for API Gateway to ALB"
  target_arns = [ aws_lb.alb.arn ]
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name = "rest-api"
  endpoint_configuration {
    types = [ "REGIONAL" ]
  }
}

resource "aws_api_gateway_resource" "api" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part = "api"
}

resource "aws_api_gateway_method" "api_root" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_root" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api.id
  http_method = aws_api_gateway_method.api_root.http_method

  type = "HTTP"
  integration_http_method = "GET"

  connection_type = "VPC_LINK"
  connection_id = aws_api_gateway_vpc_link.vpc_link.id

  uri = "http://${aws_lb.alb.dns_name}/api"
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api.id,
      aws_api_gateway_method.api_root.id,
      aws_api_gateway_integration.api_root.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name = "v1"
}
