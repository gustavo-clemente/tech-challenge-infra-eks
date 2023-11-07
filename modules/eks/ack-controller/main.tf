resource "local_file" "ack_iam_policy" {
  filename = "ack-iam-policy.json"
  source   = "https://raw.githubusercontent.com/aws-samples/amazon-apigateway-ingress-controller-blog/Mainline/apigw-ingress-controller-blog/ack-iam-policy.json"
}

resource "aws_iam_policy" "ack_policy" {
  name        = "ACKIAMPolicy"
  description = "Policy for ACK Apigatewayv2 Controller"
  path        = "/"
  policy      = local_file.ack_iam_policy.content
}

resource "aws_iam_role" "eks_service_role" {
  name = "eks-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_ack_policy" {
  name       = "attach_ack_policy"
  policy_arn = aws_iam_policy.ack_policy.arn
  roles      = [aws_iam_role.eks_service_role.name]
}

resource "kubernetes_service_account" "service-account" {
  metadata {
    name      = "aws-ack-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-ack-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = aws_iam_role.eks_service_role.arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "helm_release" "alb-controller" {
  name       = "ack-controller"
  repository = "oci://public.ecr.aws/aws-controllers-k8s"
  chart      = "apigatewayv2"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.service-account
  ]

  set {
    name  = "region"
    value = var.cluster_region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "image.repository"
    value = "oci://public.ecr.aws/aws-controllers-k8s/apigatewayv2"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-ack-controller"
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
}