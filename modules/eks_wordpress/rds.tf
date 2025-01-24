# ------------------------------------------------------- RDS infra  ---------------------------------
# Crear un Security Group para MySQL (RDS)
/*
resource "aws_security_group" "rds_sg" {
  name        = "${var.tag_value}-rds-sg"
  description = "Security group for MySQL RDS"
  vpc_id      = var.vpc_id

  ingress{
    from_port   = 3306  # Puerto por defecto de MySQL
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.node.id]
  }

  tags = {
    Name = "rds-sg-${var.tag_value}"
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name        = "my-db-subnet-group-${var.tag_value}"
  description = "Subnets for RDS instance"
  subnet_ids  = var.subnets  # Referencia a las subredes existentes

  tags = {
    Name = "MyDbSubnetGroup-${var.tag_value}"
  }
}
# Crear una base de datos MySQL usando Amazon RDS
resource "aws_db_instance" "mysql_db" {
  #count = 0
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  identifier        = "mymysqldb${var.tag_value}"
  engine            = "mysql"
  instance_class    = "db.t3.micro"  # Clase de instancia para MySQL
  allocated_storage = 10  # Almacenamiento en GB
  db_name           = "mydatabase${var.tag_value}"
  username          = var.db_username
  password          = var.db_password  # Asegúrate de usar contraseñas seguras
  skip_final_snapshot = true
  publicly_accessible = true
  multi_az          = var.replicas>1?true:false
  storage_type      = "gp2"
  db_subnet_group_name  = aws_db_subnet_group.my_db_subnet_group.name
  #b_subnet_group

  tags = {
    Name = "MySQLDatabase-${var.tag_value}"
  }
  depends_on = [
    aws_security_group.rds_sg        # Esperar a que el Security Group RDS se cree
  ]
}

# ------------------------------------------------------------------ RDS infra 
/*
resource "null_resource" "update_rdsvars_ini1" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command = "echo rds_username: ${aws_db_instance.mysql_db.username}   > ${var.module_path}ansible/vars.yml && echo rds_password: ${aws_db_instance.mysql_db.password}   >> ${var.module_path}ansible/vars.yml && echo rds_endpoint: ${aws_db_instance.mysql_db.endpoint}   >> ${var.module_path}ansible/vars.yml && echo rds_db_name: ${aws_db_instance.mysql_db.db_name}   >> ${var.module_path}ansible/vars.yml"

  }
  # Usar triggers para forzar la ejecución del recurso
  triggers = {
    always_run = "${timestamp()}"  # Usamos timestamp como valor cambiante
  }
  depends_on=[aws_db_instance.mysql_db]
  
}*/