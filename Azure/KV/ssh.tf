
# RSA key of size 4096 bits or 2048
resource "tls_private_key" "alias-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 2048

}

#send the keys to KV

resource "azurerm_key_vault_secret" "ssh_public_key" {
  key_vault_id = azurerm_key_vault.kv-alias.id
  name         = "ssh-public-key"
  value        = tls_private_key.alias-ssh-key.public_key_openssh

}

resource "azurerm_key_vault_secret" "ssh_private_key" {
  key_vault_id = azurerm_key_vault.kv-alias.id
  name         = "ssh-private-key"
  value        = tls_private_key.alias-ssh-key.private_key_pem
}