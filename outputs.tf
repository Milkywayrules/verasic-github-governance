output "repository_full_name" {
  description = "owner/repo"
  value       = module.repo_baseline.full_name
}

output "repository_html_url" {
  description = "Web URL"
  value       = module.repo_baseline.html_url
}

output "hard_protection_enabled" {
  description = "Whether branch protection module was applied"
  value       = var.enable_hard_protection
}

output "default_branch" {
  value = var.default_branch
}
