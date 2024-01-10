build_iso: ## Build installer ISO
	nix build .#iso
.PHONY: build_iso
