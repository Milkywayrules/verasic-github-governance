.PHONY: fmt validate plan apply

EXAMPLE ?= examples/sandbox

fmt:
	@if command -v tofu >/dev/null 2>&1; then \
		tofu fmt -recursive .; \
	elif command -v terraform >/dev/null 2>&1; then \
		terraform fmt -recursive .; \
	else \
		echo "tofu or terraform required"; exit 1; \
	fi

validate:
	@cd $(EXAMPLE) && \
	if command -v tofu >/dev/null 2>&1; then \
		tofu init -backend=false -input=false && tofu validate; \
	elif command -v terraform >/dev/null 2>&1; then \
		terraform init -backend=false -input=false && terraform validate; \
	else \
		echo "tofu or terraform required"; exit 1; \
	fi

plan:
	bash scripts/plan.sh $(EXAMPLE)

apply:
	VERASIC_GOVERNANCE_IAC_CONFIRM=1 bash scripts/apply.sh $(EXAMPLE)
