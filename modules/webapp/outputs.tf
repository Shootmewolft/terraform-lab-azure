output "web_app_name" {
  value = azurerm_linux_web_app.this.name
}

output "web_app_default_hostname" {
  value = azurerm_linux_web_app.this.default_hostname
}

output "app_service_plan_name" {
  value = azurerm_service_plan.this.name
}
