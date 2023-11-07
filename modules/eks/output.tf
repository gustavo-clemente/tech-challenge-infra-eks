output "cluster_name" {
  description = "Nome do cluster EKS criado"
  value       = module.eks.cluster_name
}

output "cluster_version" {
  description = "Versão do cluster EKS criado"
  value       = module.eks.cluster_version
}

output "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Dados da autoridade de certificação do cluster EKS"
  value       = module.eks.cluster_certificate_authority_data
}

output "fargate_profile" {
  description = "OS profiles fargates criados no clustes EKS"
  value = module.eks.fargate_profiles
}

output "oidc_provider_arn" {
  description = "O Amazon Resource Name (ARN) do provedor de identidade OpenID Connect (OIDC) associado ao seu cluster EKS."
  value = module.eks.oidc_provider_arn
}

output "cluster_primary_security_group_id" {
  description = "ID do grupo de seguranã primário que foi gerado para o cluster EKS"
  value = module.eks.cluster_primary_security_group_id
}