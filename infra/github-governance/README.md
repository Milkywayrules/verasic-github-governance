# OpenTofu — GitHub governance (hard rules)

OpenTofu modules for GitHub repo baseline and plan-gated branch protection. Run all commands from this directory.

## Layout

```
main.tf / variables.tf / outputs.tf / versions.tf   — root module wiring
modules/repo_baseline/                               — visibility, merge options, delete branch on merge
modules/branch_protection/                           — classic protection; gated by enable_hard_protection
examples/sandbox/                                    — dogfood default (hard protection off)
examples/production-gated/                           — enable_hard_protection=true when plan allows
scripts/                                             — plan.sh, apply.sh helpers
Makefile                                             — fmt, validate, plan, apply
```

## Plan gating

| Scenario | `enable_hard_protection` |
| --- | --- |
| Private repo on **GitHub Free** | Must stay **`false`** — API rejects protection |
| **Team / Pro** private or eligible public | May set **`true`** when you intentionally enforce checks |

When hard protection is enabled, the required status check context must be **`ci`** — match the job id in `.github/workflows/ci.yml` from the governance templates.

## Usage

```bash
cd infra/github-governance
cp examples/sandbox/terraform.tfvars.example terraform.tfvars
# Edit owner/name — do NOT commit terraform.tfvars (gitignored)
export TF_VAR_github_token="..."   # fine-grained PAT with repo admin; never commit
make fmt validate plan
make apply   # or: VERASIC_GOVERNANCE_IAC_CONFIRM=1 bash scripts/apply.sh
```

**Variables**

- `github_token` — pass via `TF_VAR_github_token` or `-var`; never commit
- `enable_hard_protection` — default **`false`**; flip only when plan matrix allows

Requires OpenTofu **≥ 1.5** or Terraform **≥ 1.5**. Example lock files under `examples/` may be committed; local `.terraform/` and `*.tfstate*` stay gitignored.
