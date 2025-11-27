data "template_file" "user_data" {
  template = file("userdata.sh")
  vars = {
    db_user = var.db_username
    db_pass = var.db_password
    db_host = aws_db_instance.vprofile-rds.address
  }
}

resource "aws_instance" "vprofile-app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.vprofile-key.key_name
  vpc_security_group_ids = [aws_security_group.vprofile-app-sg.id]
  user_data              = data.template_file.user_data.rendered

  tags = {
    Name = "vprofile-app"
  }

  # ننتظر السيرفر يقوم عشان نقدر نرفع الملف
  provisioner "remote-exec" {
    inline = ["echo 'Server Ready!'"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("vprofile-key")
      host        = self.public_ip
    }
  }
}

output "app_public_ip" {
  value = aws_instance.vprofile-app.public_ip
}