###############################################################
# Ubuntu 24.04 LTS
#
# Both the NAT instance and application instances intentionally
# use the same base image. The application software is installed
# through user data. This can be replaced with a custom AMI in
# the future without changing the module design.
###############################################################
data "aws_ami" "ubuntu24" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}