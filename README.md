# verasic-github-governance

Verasic Labs factory for **GitHub repo governance**: local soft guardrails (hooks, CI, contributing norms) plus optional **hard rules** declared as OpenTofu when your GitHub plan allows.

This repository dogfoods the [`verasic-github-governance`](https://github.com/Milkywayrules/verasic-github-governance) skill and OpenTofu modules. Agent skills under `.agents/` are local-only (gitignored); install them with rsync from the personal-space skill tree or run `verasic-init` in a harness repo.

## Soft vs hard governance

| Layer | What it does | When it applies |
| --- | --- | --- |
| **Soft** | Repo-local hooks (pre-commit / pre-push), `CONTRIBUTING.md`, PR template, required **CI workflow** (`jobs.ci`) | Every repo that runs `bootstrap-repo.sh` + `wire-hooks.sh` |
| **Hard** | Branch protection, required status checks, merge constraints via GitHub API | Only when `enable_hard_protection=true` **and** the target repo/plan supports branch protection |

Soft governance works on **private GitHub Free** repos. Hard protection will be **rejected by the API** on plans that do not allow it — keep `enable_hard_protection=false` until you are on Team/Pro or an eligible public repo.

## Bootstrap (this repo)

From the repository root, with the skill copied to `.agents/skills/verasic-github-governance`:

```bash
bash .agents/skills/verasic-github-governance/scripts/bootstrap-repo.sh
bash .agents/skills/verasic-github-governance/scripts/wire-hooks.sh
command -v lefthook >/dev/null && lefthook install || true
bash .agents/skills/verasic-github-governance/scripts/doctor.sh
```

`doctor` must exit **0** before you treat governance as ready. Re-run `bootstrap-repo.sh --force` if templates change.

Agent GitHub CLI auth (not committed): copy `.github-agent.local.example` → `.github-agent.local`, then `source .agents/skills/verasic-github-env/scripts/load-gh-env.sh` before `gh` commands.

## OpenTofu layout

```
main.tf / variables.tf / outputs.tf / versions.tf   — root module wiring
modules/repo_baseline/                               — visibility, merge options, delete branch on merge
modules/branch_protection/                           — classic protection; gated by enable_hard_protection
examples/sandbox/                                    — dogfood default (hard protection off)
examples/production-gated/                             — enable_hard_protection=true when plan allows
scripts/                                             — plan.sh, apply.sh helpers
Makefile                                             — fmt, validate, plan, apply
```

## Plan gating

| Scenario | `enable_hard_protection` |
| --- | --- |
| Private repo on **GitHub Free** | Must stay **`false`** — API rejects protection |
| **Team / Pro** private or eligible public | May set **`true`** when you intentionally enforce checks |

When hard protection is enabled, the required status check context must be **`ci`** — match the job id in `.github/workflows/ci.yml` from the governance templates.

## OpenTofu usage

```bash
cp examples/sandbox/terraform.tfvars.example terraform.tfvars
# Edit owner/name — do NOT commit terraform.tfvars (gitignored)
export TF_VAR_github_token="..."   # fine-grained PAT with repo admin; never commit
make fmt validate plan
make apply   # or: bash scripts/apply.sh
```

**Variables**

- `github_token` — pass via `TF_VAR_github_token` or `-var`; never commit
- `enable_hard_protection` — default **`false`**; flip only when plan matrix allows

Requires OpenTofu **≥ 1.5** or Terraform **≥ 1.5**. Example lock files under `examples/` may be committed; local `.terraform/` and `*.tfstate*` stay gitignored.

## Commands

```bash
make fmt validate plan apply
bash .agents/skills/verasic-github-governance/scripts/doctor.sh
```
