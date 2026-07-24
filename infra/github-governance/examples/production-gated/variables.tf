variable "github_token" {
  type      = string
  sensitive = true
}

variable "owner" {
  type    = string
  default = "verasic-lab"
}

variable "repo_name" {
  type    = string
  default = "example-production-gated"
}

variable "description" {
  type    = string
  default = "Production-gated example — enable_hard_protection=true (Team/Pro or public Free only)"
}

variable "private" {
  type    = bool
  default = true
}

variable "default_branch" {
  type    = string
  default = "main"
}
