#----------------------------
# Security Groups
#----------------------------

# Bastion Host
resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Allow SSH from everywhere"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# Ansible Server
resource "aws_security_group" "ansible" {
  name        = "ansible-sg"
  description = "Allow SSH from Bastion Host"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      	= "Allow SSH from Bastion Host"
    from_port        	= 22
    to_port          	= 22
    protocol         	= "tcp"
    security_groups     = [aws_security_group.bastion.id] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_from_bastion"
  }
}


# Internal Servers
resource "aws_security_group" "internal" {
  name        = "internal-sg"
  description = "Allow SSH from Ansible Server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description         = "Allow SSH from Ansible Server"
    from_port           = 22
    to_port             = 22
    protocol            = "tcp"
    security_groups     = [aws_security_group.ansible.id] 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_from_ansible"
  }
}


#----------------------------
# EC2
#----------------------------

# Bastion Host
resource "aws_instance" "bastion" {

  ami                    = "ami-07200fa04af91f087"
  instance_type          = "t2.micro"
  key_name               = "EC2_Ubuntu"
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_id              = element(module.vpc.public_subnets, 0)

  tags = {
    Name	= "Bastion"
    Terraform   = "true"
  }
}

# Ansible
resource "aws_instance" "ansible" {

  ami                    = "ami-07200fa04af91f087"
  instance_type          = "t2.micro"
  key_name               = "EC2_Ubuntu"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.ansible.id]
  subnet_id              = element(module.vpc.private_subnets, 0)
  user_data		 = file("./ansible_install.sh")

  tags = {
    Name	= "Ansible"
    Terraform   = "true"
  }
}

# Internal Server 1
resource "aws_instance" "internal-ubuntu" {

  ami                    = "ami-07200fa04af91f087"
  instance_type          = "t2.micro"
  key_name               = "EC2_Ubuntu"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.internal.id]
  subnet_id              = element(module.vpc.private_subnets, 0)

  tags = {
    Name	= "internal-001"
    Terraform   = "true"
  }
}

# Internal Server 2
resource "aws_instance" "internal-redhat" {


  ami                    = "ami-0f36dcfcc94112ea1"
  instance_type          = "t2.micro"
  key_name               = "EC2_Ubuntu"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.internal.id]
  subnet_id              = element(module.vpc.private_subnets, 0)

  tags = {
    Name 	= "internal-002"
    Terraform   = "true"
  }
}



