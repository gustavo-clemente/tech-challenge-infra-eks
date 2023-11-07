variable "vpc_id" {
  description = "ID da vpc associada ao cluster"
  type = string
}

variable "cluster_region" {
  description = "Região da AWS onde o cluster está localizado"
  type = string
}

variable "cluster_name" {
  description = "Nome do cluster na qual será instalado"
  type = string
}

