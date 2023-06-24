### Use below command for deleting single resource. 

### terraform destroy --target resource-type.terraform-resource-name

### terraform destroy --target github_repository.git_first_repo

provider "github" {
  token = var.token
}