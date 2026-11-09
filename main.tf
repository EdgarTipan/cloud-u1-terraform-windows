# Configuración del proveedor de AWS
provider "aws" {
  region = "us-east-1" # Región donde se desplegarán los recursos
}

# AMI oficial más reciente de Windows Server 2022 Base
data "aws_ami" "windows_2022" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Creamos el security group
resource "aws_security_group" "mi-sg" {
  name        = "mi-security-group-terraform"
  description = "Security Group para mi instancia Windows de terraform"
  vpc_id      = "vpc-00a236095923f1d29"

  # Regla de entrada para RDP (Escritorio Remoto de Windows)
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de entrada para HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de salida abierta para permitir DNS, HTTPS y actualizaciones
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Declaración de la instancia Windows
resource "aws_instance" "mi_instancia_2" {
  ami                    = data.aws_ami.windows_2022.id
  instance_type          = "t3.medium"
  key_name               = "mi-primera-llaves-et"
  vpc_security_group_ids = [aws_security_group.mi-sg.id]

  tags = {
    Name = "MiInstanciaWindowsTerraform"
  }
}