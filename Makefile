.PHONY: setup \
		clean-cache-temp-files \
		doc  \
		format \
		pipeline all

.DEFAULT_GOAL := all

PATH_PROJECT_ROOT ?= .
TEST_PATH ?= tests

setup:
	@echo "Installing dependencies..."
	@uv sync --all-extras
	@echo "✅ Dependencies installed."

clean-cache-temp-files:
	@echo "Cleaning cache and temporary files..."
	@find . -type d -name __pycache__ -exec rm -rf {} +
	@find . -type d -name .pytest_cache -exec rm -rf {} +
	@find . -type d -name .mypy_cache -exec rm -rf {} +
	@find . -type f \( -name '*.pyc' -o -name '*.pyo' \) -delete
	@echo "✅ Clean complete."

doc:
	@echo "Serving documentation..."
	@uv run zensical serve

pipeline: clean-cache-temp-files
	@echo "✅ Pipeline complete."

format:
	@echo "Formatting documents..."
	@npx prettier --write .
	@echo "✅ Formatting complete."

all: setup format pipeline doc
	@echo "✅ All tasks complete."
