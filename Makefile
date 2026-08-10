# Copyright (C) 2024 The Ad Noctem Collective Helm Authors
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

# Variables
ROOT_DIR := $(shell git rev-parse --show-toplevel)
CHART := $(ROOT_DIR)/charts/paperless-ngx
CHART_NAME := paperless-ngx
OUT_DIR := $(ROOT_DIR)/dist

# Essential tools
HELM := helm
NPX := npx
KUBECTL := kubectl
CT := ct

# README generator package
README_GEN_PACKAGE := @bitnami/readme-generator-for-helm

# Color output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
NC := \033[0m

# Defaults
RELEASE_NAME ?= $(CHART_NAME)-test
VALUES ?=

.PHONY: help
help:
	@echo "Paperless-NGX Helm Chart - Makefile"
	@echo ""
	@echo "Essential targets:"
	@echo "  build          Build chart package (.tgz)"
	@echo "  gen            Generate README and values.schema.json"
	@echo "  template       Render chart templates"
	@echo "  lint           Lint chart (uses chart-testing)"
	@echo "  tools-check    Verify required tools are installed"
	@echo ""
	@echo "Kubernetes targets:"
	@echo "  install        Install chart to cluster"
	@echo "  upgrade        Upgrade release in cluster"
	@echo "  dry-install    Dry-run installation"
	@echo "  env            Create local kind cluster (optional)"
	@echo "  prune          Delete local kind cluster"
	@echo ""
	@echo "Utility:"
	@echo "  clean          Remove dist/ directory"
	@echo "  help           Show this help"
	@echo ""
	@echo "Variables:"
	@echo "  VALUES=ci/test-values.yaml    Use test values"
	@echo "  RELEASE_NAME=my-release       Custom release name"
	@echo "  HELM_ARGS=\"--timeout 5m\"      Additional helm args"

# Core Chart Operations
.PHONY: build
build: $(OUT_DIR)
	@echo "$(GREEN)Building $(CHART_NAME)$(NC)"
	@$(HELM) package $(CHART) --destination $(OUT_DIR)

.PHONY: gen
gen:
	@echo "$(GREEN)Generating README and schema$(NC)"
	@$(NPX) $(README_GEN_PACKAGE) \
		-c $(ROOT_DIR)/config/bitnami-readme-gen.json \
		-v $(CHART)/values.yaml \
		-r $(CHART)/README.md \
		-s $(CHART)/values.schema.json
	@npx prettier --write $(CHART)/*.md $(CHART)/*.json 2>/dev/null || true

.PHONY: template
template:
	@echo "$(GREEN)Templating $(CHART_NAME)$(NC)"
	@if [ -n "$(VALUES)" ]; then \
		$(HELM) template $(RELEASE_NAME) $(CHART) \
			--values $(CHART)/$(VALUES) --debug; \
	else \
		$(HELM) template $(RELEASE_NAME) $(CHART) --debug; \
	fi

.PHONY: lint
lint:
	@echo "$(GREEN)Linting $(CHART_NAME)$(NC)"
	@if command -v $(CT) >/dev/null 2>&1; then \
		$(CT) lint --charts $(CHART); \
	else \
		echo "$(RED)✗ chart-testing not found. Install it or run: npm install -g @helm/chart-testing$(NC)"; \
		exit 1; \
	fi

# Kubernetes Operations
.PHONY: install
install:
	@echo "$(GREEN)Installing $(CHART_NAME)$(NC)"
	@if [ -n "$(VALUES)" ]; then \
		$(HELM) install $(RELEASE_NAME) $(CHART) \
			--values $(CHART)/$(VALUES) $(HELM_ARGS); \
	else \
		$(HELM) install $(RELEASE_NAME) $(CHART) $(HELM_ARGS); \
	fi

.PHONY: upgrade
upgrade:
	@echo "$(GREEN)Upgrading $(CHART_NAME)$(NC)"
	@if [ -n "$(VALUES)" ]; then \
		$(HELM) upgrade $(RELEASE_NAME) $(CHART) \
			--values $(CHART)/$(VALUES) --install $(HELM_ARGS); \
	else \
		$(HELM) upgrade $(RELEASE_NAME) $(CHART) --install $(HELM_ARGS); \
	fi

.PHONY: dry-install
dry-install:
	@echo "$(GREEN)Dry-run install $(CHART_NAME)$(NC)"
	@if [ -n "$(VALUES)" ]; then \
		$(HELM) install $(RELEASE_NAME) $(CHART) \
			--values $(CHART)/$(VALUES) --dry-run=client --debug; \
	else \
		$(HELM) install $(RELEASE_NAME) $(CHART) --dry-run=client --debug; \
	fi

# Development Environment (optional)
.PHONY: env
env:
	@echo "$(GREEN)Creating kind cluster...$(NC)"
	@kind create cluster \
		--config $(ROOT_DIR)/config/k8s/cluster/kind-config.yaml \
		--name helm-charts \
		--wait 15s
	@echo "$(YELLOW)Installing cert-manager...$(NC)"
	@$(HELM) repo add jetstack https://charts.jetstack.io --quiet
	@$(HELM) repo update jetstack --quiet
	@$(HELM) install cert-manager jetstack/cert-manager \
		--namespace cert-manager --create-namespace \
		--set installCRDs=true --quiet
	@echo "$(YELLOW)Installing ingress-nginx...$(NC)"
	@$(HELM) repo add ingress-nginx https://kubernetes.github.io/ingress-nginx --quiet
	@$(HELM) repo update ingress-nginx --quiet
	@$(HELM) install ingress-nginx ingress-nginx/ingress-nginx \
		--namespace ingress-nginx --create-namespace --quiet
	@echo "$(GREEN)✓ Cluster ready$(NC)"

.PHONY: prune
prune:
	@echo "$(RED)Deleting kind cluster...$(NC)"
	@kind delete cluster --name helm-charts || true
	@echo "$(GREEN)✓ Cluster deleted$(NC)"

# Maintenance
.PHONY: tools-check
tools-check:
	@echo "$(YELLOW)Checking essential tools...$(NC)"
	@command -v $(HELM) >/dev/null 2>&1 || (echo "$(RED)✗ helm not found$(NC)" && exit 1)
	@command -v $(NPX) >/dev/null 2>&1 || (echo "$(RED)✗ npx not found$(NC)" && exit 1)
	@command -v $(KUBECTL) >/dev/null 2>&1 || (echo "$(RED)✗ kubectl not found$(NC)" && exit 1)
	@echo "$(GREEN)✓ Essential tools found$(NC)"
	@if command -v $(CT) >/dev/null 2>&1; then \
		echo "$(GREEN)✓ chart-testing found (optional)$(NC)"; \
	else \
		echo "$(YELLOW)⚠ chart-testing not found (optional, needed for: make lint)$(NC)"; \
	fi

.PHONY: clean
clean:
	@echo "Cleaning dist/"
	@rm -rf $(OUT_DIR)

# Helper targets
$(OUT_DIR):
	@mkdir -p $(OUT_DIR)

.PHONY: all
all: gen lint build

.DEFAULT_GOAL := help
