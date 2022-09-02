output "bastion_pub_ip" { value = aws_instance.bastion.public_ip  }

output "ansible_pri_ip" { value = aws_instance.ansible.private_dns }

output "internal_ubuntu_pri_ip" { value = aws_instance.internal-ubuntu.private_dns }

output "internal_amazon_linux_pri_ip" { value = aws_instance.internal-redhat.private_dns }
