locals {
  name = var.env != "" ? "${var.component_name}-${var.env}" : var.component_name

  db_commands = [
    "rm -f /roboshop-shell-script",
    "git clone https://github.com/pavanbairu/roboshop-shell-script.git",
    "cd roboshop-shell-script",
    "sudo bash ${var.component_name}.sh ${var.password}"
  ]

  app_commands = [
    "sudo labauto ansible",
    "ansible-pull -i localhost, -U https://github.com/pavanbairu/roboshop-ansible.git roboshop.yml -e env=${var.env} -e role_name=${var.component_name}",


  ]
}