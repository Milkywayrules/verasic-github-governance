terraform {
  required_version = ">= 1.5.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.owner
}

module "repo_baseline" {
  source = "../../modules/repo_baseline"

  name           = var.repo_name
  description    = var.description
  private        = var.private
  default_branch = var.default_branch
}

module "branch_protection" {
  source = "../../modules/branch_protection"

  repository_id = module.repo_baseline.node_id
  pattern       = var.default_branch
  enabled       = false
}

output "repository_full_name" {
  value = module.repo_baseline.full_name
}

output "hard_protection_enabled" {
  value = false
}
