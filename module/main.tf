resource "aws_instance" "all_instance" {
  ami = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = var.component_name
  }
}

resource "null_resource" "provisioner" {
  depends_on = [aws_instance.all_instance, aws_route53_record.records]
  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_instance.all_instance.private_ip
    }

    inline = [
      "rm -f /roboshop-shell-script",
      "git clone https://github.com/pavanbairu/roboshop-shell-script.git",
      "cd roboshop-shell-script",
      "sudo bash ${var.component_name}.sh ${var.password}"
    ]
  }
}

resource "aws_route53_record" "records" {
  name    = "${var.component_name}-dev.pavanbairu.tech"
  type    = "A"
  zone_id = "Z08846229MEF59DJAKAS"
  ttl = 30
  records = [aws_instance.all_instance.private_ip]
}
