output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "security_group_id" {
  value = aws_security_group.web.id
}

output "load_balancer_dns" {
  value = aws_lb.web.dns_name
}
