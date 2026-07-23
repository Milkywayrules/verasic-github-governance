variable "github_token" {
  type      = string
  sensitive = true
}

variable "owner" {
  type    = string
  default = "Milkywayrules"
}

variable "repo_name" {
  type    = string
  default = "verasic-governance-sandbox"
}

variable "description" {
  type    = string
  default = "Sandbox — soft governance only (enable_hard_protection=false)"
}

variable "private" {
  type    = bool
  default = true
}

variable "default_branch" {
  type    = string
  default = "main"
}
