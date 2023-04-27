variable "components" {
  default = ["frontend", "mongodb", "catalogue"]
}

data "aws_ami" "centos" {
  owners      = ["973714476881"]
  name_regex  = "Centos-8-DevOps-Practice"
  most_recent = true
}

data "aws_security_group" "allow-all" {
  name = "allow-all"
}

variable "instance_type" {
  default = "t3.micro"
}

resource "aws_instance" "all_instance" {
  count = length(var.components)
  ami = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = var.components[count.index]
  }
}

