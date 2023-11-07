variable "fargate_subnet_ids" {
  description = "ID's das subentes associadas ao fargate"
  type = list
}

variable "subnet_ids" {
  description = "Lista com o ID das subnets associadas"
  type = list
}

variable "vpc_id" {
  description = "ID da vpc associada"
  type = string
}

variable "cluster_region" {
  description = "Região que será criado o cluster"
  type = string
}

