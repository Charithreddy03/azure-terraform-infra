output "subnet_id" {
  description = "ID of the subnet for the web VM."
  value       = azurerm_subnet.web.id
}