# Definindo versões compativeis para terraform
terraform {
  required_version = ">= 1.0.0" # define versão permitida igual ou maior que 1.0.0

  # Define a versão mínima do Terraform que é necessária para executar o código
  required_providers {
    aws = {
      source  = "hashicorp/aws" #especifica a origem do provedor
      version = ">= 4.0.0"      #define a versão minima do provedor, quem determina é a hashicorp
    }
  }
}

# Definindo o provedor que será usado para gerenciar recursos
# E dentro dos {} está definindo a região que será utilizada
provider "aws" {
  region = "us-east-1"
}

# Esse bloco define o tipo de recurso e na frente o nome que será utilizado
# Dentro do bloco definimos as informações necessarias do recurso
resource "aws_instance" "ec2_teste1" {
  ami           = "ami-0427090fd1714168b"
  instance_type = "t2.micro"
  key_name = "werserver-us-east-1"

# referenciando a interface de rede criada no recurso "aws_instance" 
  #  da forma normal estava apresentando erro, esse bloco foi alternativa
network_interface {
  network_interface_id = aws_network_interface.vpc-01.id # .id no final é para usado para acessar o identificador único de um recurso no Terraform, e esse identificador é representado como uma string
  device_index = 0
 }

  tags = {
    nome = "instancia-ec2-teste"
  }
}

# criando um recurso para interface de rede com uma subrede (subnet) e um security group
  #  alternativa, para poder referenciar dentro do "aws-instance"
resource "aws_network_interface" "vpc-01" {
  subnet_id = "subnet-0b13e89a740972c03"
  security_groups = ["sg-00b99766f2aa8d7d5"]
}