terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

variable "repository_id" {
  type        = string
  description = "GitHub repository node ID"
}

variable "pattern" {
  type        = string
  description = "Branch name pattern (default branch)"
}

variable "enabled" {
  type        = bool
  default     = false
  description = "When false, no branch protection resource is created (Free private default)."
}

variable "required_status_check" {
  type    = string
  default = "ci"
}

variable "required_approving_review_count" {
  type    = number
  default = 1
}

resource "github_branch_protection" "this" {
  count = var.enabled ? 1 : 0

  repository_id = var.repository_id
  pattern       = var.pattern

  enforce_admins                  = false
  require_conversation_resolution = true
  required_linear_history         = false

  required_pull_request_reviews {
    required_approving_review_count = var.required_approving_review_count
    dismiss_stale_reviews           = true
  }

  required_status_checks {
    strict   = true
    contexts = [var.required_status_check]
  }

  # v1: no signed commits requirement
}
