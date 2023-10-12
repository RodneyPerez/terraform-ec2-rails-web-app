data "aws_ami" "web_app" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["${var.ami_name}*"]
  }
}
