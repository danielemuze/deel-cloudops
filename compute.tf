resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCJhXZfxqfLCU5taYdVCs817lHSQdE+F3qtCYhN5BwEmKzgIvVX6ibSNFGT3R3/GAYbJFbra4gFAwO0PT+B5uRREGhnkaU2pzrHYwMlwrF4HHckzLnBwnlluangmxru/VFQn8+ypOm6xMp+1rn8R506KDavqnraszx9S9a42lbfAm+9kAklXeldiWy85y6X2sO+w7JS6tB9glDRtboyqmfYrDrwewaUJaSWXM/ePOzyRBgO1HnalfdPj3tLvPlPQzTC2WIgwm5NG/KKm33sJInN0aJ9zaTDW00YljzZwVlW1a3+nt2eYlKq3/1+Uoffcn+/braz6o7VFdOgHOw1cB9D deployer-key"
}

resource "aws_launch_template" "web" {
  name_prefix            = "web-launch-configuration-"
  image_id               = "ami-0e001c9271cf7f3b9"  # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  key_name = aws_key_pair.deployer.key_name

  user_data = filebase64("${path.module}/user_data.sh")
}

resource "aws_autoscaling_group" "web" {
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  vpc_zone_identifier  = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "DockerWebApp"
    propagate_at_launch = true
  }

  depends_on = [aws_lb.web]
}

resource "aws_lb" "web" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_target_group" "web" {
  name     = "web-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "HTTP"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  lb_target_group_arn    = aws_lb_target_group.web.arn
}
