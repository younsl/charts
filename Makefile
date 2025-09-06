CHARTS_DIR ?= charts

# Generate documentation for all charts
.PHONY: docs
docs:
	@for chart in $(CHARTS_DIR)/*; do \
		if [ -f "$$chart/Chart.yaml" ]; then \
			echo "Generating docs for $$chart using common .github/templates/README.md.gotmpl"; \
			helm-docs --chart-search-root "$$chart" --template-files="../../.github/templates/README.md.gotmpl" --sort-values-order file --log-level info; \
		fi \
	done
