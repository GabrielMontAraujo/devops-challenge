provider "aws" {
  region = "us-east-1"  # Escolha a região que você preferir
}

# Criar uma VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Criar uma sub-rede pública
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Criar um gateway de internet para permitir o tráfego da internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Criar uma tabela de rotas para a sub-rede pública
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associar a sub-rede pública com a tabela de rotas
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Criar um grupo de segurança que permite SSH e HTTP
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir SSH de qualquer lugar (pode restringir ao seu IP)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir HTTP de qualquer lugar
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Permitir todo tráfego de saída
  }
}

# Criar o par de chaves SSH
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("terraform.pub") # Chave pública gerada localmente
}

# Criar uma instância EC2 com Ubuntu
resource "aws_instance" "web_server" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name = "WebServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              echo "<h1>Hello, World</h1>" > /var/www/html/index.html
              systemctl start nginx
              EOF
}
output "public_ip" {
  value = aws_instance.web_server.public_ip
}
