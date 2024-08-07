Terraform code for Azure, AWS and GCP.

Original content, not copied from anyone!

Ideas to add:

Tag all resources with terraform workspace:

terraform workspace new DEV
terraform workspace new QUA
terraform workspace new PROD

locals = {

  be_aware_workspace = ${terraform.workspace}
  instance_name = ${terraform.workspace}-rest of the name (random + var)

  }

  tags {
    Name = be_aware_workspace
    }

  be sure about the workspace you are:

  output local.be_aware_workspace
  or
  terraform workspace show


---------------------

Validation!!

variable "instance_type" {
   description = "Instance type t2.micro"
   type        = string
   default     = ""

#  validation {
#   condition     = can(regex("^[Tt][2-3].(nano|micro|small)", var.instance_type))
#   error_message = "Invalid Instance Type name. You can only choose - t2.nano,t2.micro,t2.small"
# }
}
