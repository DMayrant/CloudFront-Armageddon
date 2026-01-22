resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-cluster-${var.env}"
  engine                  = var.engine # aurora-postgresql
  engine_mode             = "provisioned"
  master_username         = var.db_username
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]
  storage_encrypted       = true
  deletion_protection     = false
  skip_final_snapshot     = true
  backup_retention_period = 7
  apply_immediately       = true

  tags = {
    Name        = "Aurora-Cluster"
    Environment = var.env
  }
}

resource "aws_rds_cluster_instance" "aurora_writer" {
  identifier           = "aurora-writer-${var.env}"
  cluster_identifier   = aws_rds_cluster.aurora_cluster.id
  instance_class       = "db.t3.medium"
  engine               = aws_rds_cluster.aurora_cluster.engine
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.aurora_subnet_group.name

  tags = {
    Name        = "Aurora-Writer"
    Environment = var.env
  }
}

resource "aws_rds_cluster_instance" "aurora_reader" {
  identifier           = "aurora-reader-${var.env}"
  cluster_identifier   = aws_rds_cluster.aurora_cluster.id
  instance_class       = "db.t3.medium"
  engine               = aws_rds_cluster.aurora_cluster.engine
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.aurora_subnet_group.name

  tags = {
    Name        = "Aurora-Reader"
    Environment = var.env
  }
}
