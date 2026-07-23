variable "github_token" {
  type        = string
  sensitive   = true
  description = "GitHub PAT with repo admin scope. Pass via TF_VAR_github_token — never commit."
}

variable "owner" {
  type        = string
  description = "GitHub org or user owning the repository."
}

variable "repo_name" {
  type        = string
  description = "Repository name (without owner)."
}

variable "description" {
  type        = string
  default     = "Managed by verasic-github-governance OpenTofu"
  description = "Repository description."
}

variable "private" {
  type        = bool
  default     = true
  description = "Create/maintain as private (Verasic default)."
}

variable "default_branch" {
  type        = string
  default     = "main"
  description = "Default branch for protection rules."
}

variable "enable_hard_protection" {
  type        = bool
  default     = false
  description = <<-EOT
    Apply classic branch protection (PR + review + required check ci).
    MUST remain false for private repos on GitHub Free — plan does not allow protection.
    Set true only when plan-matrix confirms eligibility (Team/Pro private or eligible public).
  EOT
}

variable "required_approving_review_count" {
  type        = number
  default     = 1
  description = "Approving reviews required when hard protection enabled."
}

variable "required_status_check" {
  type        = string
  default     = "ci"
  description = "Required status check context — must match CI workflow job id."
}
