# RSA key of size 42048 bits
resource "tls_private_key" "terraform_private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

#send keys to Azure Vault

resource azurerm_key_vault_secret "var.azurerm_key_vault.name" {
  key_vault_id = azurerm_key_vault.terraform_private_key.id
  name         = "ssh-public"
  value        = tls_private_key.terraform_private_key.public_key_openssh
}

resource azurerm_key_vault_secret "var.azurerm_key_vault.name" {
  key_vault_id = azurerm_key_vault.terraform_private_key.id
  name         = "ssh-private"
  value        = tls_private_key.terraform_private_key.private_key_pem
}

# Output the public key
output "ssh-public" {
  value = tls_private_key.ssh_key.ssh-public_openssh
}