data "template_file" "nginx_deployment_service_yaml" {
  template = file("${path.module}/chat-app-service.tpl")

}


resource "kubernetes_manifest" "nginx_deployment_service" {#el locad balancer en eks crea un lb de tipo network
  manifest = yamldecode(data.template_file.nginx_deployment_service_yaml.rendered)
  depends_on=[kubernetes_manifest.nginx_deployment]
}

data "external" "get_dns" {
  # En caso de usar Python, usa este comando:
   program = ["python3", "get_dns.py", "chat-app-service"]
   depends_on=[kubernetes_manifest.nginx_deployment_service]
}


