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

  be sure about the workspace you are:

  output local.be_aware_workspace
  or
  terraform workspace show
