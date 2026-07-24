# verasic-github-governance-public-free

Public dogfood registry for **Verasic GitHub repo governance** — soft guardrails at the repo root plus OpenTofu **hard rules** under `infra/github-governance/` when your GitHub plan allows branch protection.

Pairs with the [`verasic-github-governance`](https://github.com/Milkywayrules/verasic-skills) skill (local-only under `.agents/`; install via rsync from personal-space or `verasic-init` in a harness repo).

## Soft vs hard governance

| Layer | What it does | Where |
| --- | --- | --- |
| **Soft** | Hooks (pre-commit / pre-push), `CONTRIBUTING.md`, PR template, required **CI workflow** (`jobs.ci`) | Repo root — `.github/`, `lefthook.yml`, `CONTRIBUTING.md` |
| **Hard** | Branch protection, required status checks, merge constraints via GitHub API | `infra/github-governance/` — OpenTofu modules; apply only when plan allows |

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

## OpenTofu (hard rules)

All IaC lives under **`infra/github-governance/`** — not the repo root. See [infra/github-governance/README.md](infra/github-governance/README.md) for layout, plan gating, and `make plan` / `make apply`.

**Product repos** (e.g. `verasic-harness-kit`) use **soft governance only** — do not copy the OpenTofu tree.

## Commands

```bash
bash .agents/skills/verasic-github-governance/scripts/doctor.sh
cd infra/github-governance && make fmt validate plan apply
```
