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
