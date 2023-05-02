variable "components" {
  default = {
    frontend = {
      name = "frontend"
      instance_type = "t3.micro"
    }
    mongodb = {
      name = "mongodb"
      instance_type = "t3.micro"
    }
    catalogue  = {
      name = "catalogue"
      instance_type = "t3.micro"
    }
  }
}

data "aws_ami" "centos" {
  owners      = ["973714476881"]
  name_regex  = "Centos-8-DevOps-Practice"
  most_recent = true
}

data "aws_security_group" "allow-all" {
  name = "allow-all"
}

#variable "instance_type" {
#  default = "t3.micro"
#}

resource "aws_instance" "all_instance" {
  for_each = var.components
  ami = data.aws_ami.centos.image_id
  instance_type = each.value["instance_type"]
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = each.value["name"]
  }
}

resource "aws_route53_record" "records" {
  for_each = var.components
  name    = "${each.value["name"]}-dev.pavanbairu.tech"
  type    = "A"
  zone_id = "Z08846229MEF59DJAKAS"
  ttl = 30
  records = [aws_instance.all_instance[each.value["name"]].private_ip]
}
