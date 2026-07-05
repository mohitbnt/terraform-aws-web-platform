locals {
  # NAT Security Group Rules
  nat_sg_ingress_rules = {
    "all_traffic_from_ec2" = {
      port                         = null #  Must be null when protocol is "-1"
      protocol                     = "-1" #  "-1" means ALL protocols (TCP, UDP, ICMP, etc.)
      use_cidr                     = false
      cidr                         = null
      referenced_security_group_id = aws_security_group.ec2_sg.id
    }
  }
  nat_sg_egress_rules = {
    "all_trafic" = {
      port                         = null #  Must be null when protocol is "-1"
      protocol                     = "-1" #  "-1" means ALL protocols (TCP, UDP, ICMP, etc.)
      use_cidr                     = true
      cidr                         = "0.0.0.0/0"
      referenced_security_group_id = null
    }
  }
  # EC2 Security Group Rules  
  ec2_sg_ingress_rules = {
    "http" = {
      port                         = 80
      protocol                     = "tcp"
      use_cidr                     = false
      cidr                         = null
      referenced_security_group_id = aws_security_group.alb_sg.id
    }
  }
  ec2_sg_egress_rules = {
    "all_traffic" = {
      port                         = null #  Must be null when protocol is "-1"
      protocol                     = "-1" #  "-1" means ALL protocols (TCP, UDP, ICMP, etc.)
      use_cidr                     = true
      cidr                         = "0.0.0.0/0"
      referenced_security_group_id = null
    }
  }
  # ALB Security Group Rules   
  alb_sg_ingress_rules = {
    "http" = {
      port                         = 80
      protocol                     = "tcp"
      use_cidr                     = true
      cidr                         = "0.0.0.0/0"
      referenced_security_group_id = null
    }
    "https" = {
      port                         = 443
      protocol                     = "tcp"
      use_cidr                     = true
      cidr                         = "0.0.0.0/0"
      referenced_security_group_id = null
    }
  }
  alb_sg_egress_rules = {
    "http" = {
      port                         = 80
      protocol                     = "tcp"
      use_cidr                     = false
      cidr                         = null
      referenced_security_group_id = aws_security_group.ec2_sg.id
    }
  }
  # Endpoint Security Group Rules  
  endpoints_sg_ingress_rules = {
    "ec2_https" = {
      port                         = 443
      protocol                     = "tcp"
      use_cidr                     = false
      cidr                         = null
      referenced_security_group_id = aws_security_group.ec2_sg.id
    }
    "nat_https" = {
      port                         = 443
      protocol                     = "tcp"
      use_cidr                     = false
      cidr                         = null
      referenced_security_group_id = aws_security_group.nat_sg[0].id
    }
  }
  endpoints_sg_egress_rules = {
    "all_traffic" = {
      port                         = null #  Must be null when protocol is "-1"
      protocol                     = "-1" #  "-1" means ALL protocols (TCP, UDP, ICMP, etc.)
      use_cidr                     = true
      cidr                         = "0.0.0.0/0"
      referenced_security_group_id = null
    }
  }
}