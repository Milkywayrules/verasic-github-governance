provider "github" {
  token = var.github_token
  owner = var.owner
}

module "repo_baseline" {
  source = "./modules/repo_baseline"

  name           = var.repo_name
  description    = var.description
  private        = var.private
  default_branch = var.default_branch
}

module "branch_protection" {
  source = "./modules/branch_protection"

  repository_id                   = module.repo_baseline.node_id
  pattern                         = var.default_branch
  enabled                         = var.enable_hard_protection
  required_status_check           = var.required_status_check
  required_approving_review_count = var.required_approving_review_count
}
