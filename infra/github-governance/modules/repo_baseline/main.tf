terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "private" {
  type    = bool
  default = true
}

variable "default_branch" {
  type    = string
  default = "main"
}

variable "delete_branch_on_merge" {
  type    = bool
  default = true
}

resource "github_repository" "this" {
  name                   = var.name
  description            = var.description
  visibility             = var.private ? "private" : "public"
  delete_branch_on_merge = var.delete_branch_on_merge
  has_issues             = true
  has_projects           = false
  has_wiki               = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = var.default_branch
}

output "full_name" {
  value = github_repository.this.full_name
}

output "html_url" {
  value = github_repository.this.html_url
}

output "name" {
  value = github_repository.this.name
}

output "node_id" {
  value = github_repository.this.node_id
}
