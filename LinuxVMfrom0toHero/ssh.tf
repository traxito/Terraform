# RSA key of size 42048 bits
resource "tls_private_key" "terraform_private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

#send keys to Azure Vault

resource azurerm_key_vault_secret ssh_private_key {
  key_vault_id = var.kv-name  
  name         = "ssh-private"
  value        = tls_private_key.terraform_private_key.private_key_pem
}

resource azurerm_key_vault_secret ssh_public_key {
  key_vault_id = var.kv-name  
  name         = "ssh-public"
  value        = tls_private_key.terraform_private_key.public_key_openssh
}

# Output the public key
output "ssh-public" {
  value = tls_private_key.terraform_private_key.public_key_openssh 
}