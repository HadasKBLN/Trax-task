
resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_vpc}"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_subnet" "first_subnet_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.first_cidr_subnet}"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.az_a}"
}

resource "aws_route_table_association" "first_rta_subnet_public" {
  subnet_id      = "${aws_subnet.first_subnet_public.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

resource "aws_subnet" "second_subnet_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.second_cidr_subnet}"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.az_b}"
}

resource "aws_route_table_association" "second_rta_subnet_public" {
  subnet_id      = "${aws_subnet.second_subnet_public.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_security_group" "my_sg" {
  name = "my_sg"
  vpc_id = "${aws_vpc.vpc.id}"  
  
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp" 
      cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress {
      from_port   = 12346
      to_port     = 12346
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  
}

resource "aws_launch_template" "morsesrc" {
  name_prefix   = "morsesrc"
  image_id      = "${var.morse_src_ami}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.my_sg.id}"]

  tags = {
    Name = "morsesrc"
  }
}

resource "aws_autoscaling_group" "morsesrc_autoscaling" {
  vpc_zone_identifier = ["${aws_subnet.first_subnet_public.id}", "${aws_subnet.second_subnet_public.id}"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = "${aws_launch_template.morsesrc.id}"
    version = "$Latest"
  }

  load_balancers = ["${aws_elb.morsesrc.name}"]
  health_check_type = "ELB"
  tag {
    key = "Name"
    value = "morsesrc_autoscaling"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "morsesrc" {
  name = "${var.elb_name}"
  security_groups = ["${aws_security_group.my_sg.id}"]
  subnets = ["${aws_subnet.first_subnet_public.id}", "${aws_subnet.second_subnet_public.id}"]
    health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "TCP:12346/"
  }
  listener {
    lb_port = 12346
    lb_protocol = "tcp"
    instance_port = "12346"
    instance_protocol = "tcp"
  }
}

resource "aws_route53_zone" "my_zone" {
  name = "${var.my_srvice_name}"
}

resource "aws_route53_record" "geolocation" {
  zone_id         = "${aws_route53_zone.my_zone.zone_id}"
  name            = "www.${var.my_srvice_name}"
  type            = "A"
  set_identifier  = "${var.identifier}"

  alias { 
    zone_id                = "${aws_elb.morsesrc.id}" 
    name                   = "${aws_elb.morsesrc.name}"
    evaluate_target_health = false 
  }

  geolocation_routing_policy {
    location = "${var.location}" 
    set_identifier = "${var.location_id}"
  }
}
