# Validate Claude Code plugin
validate:
	@echo "Validating Claude Code plugin structure..."
	claude plugin validate .

# Run installation script
install:
	@echo "Running installation script..."
	bash install.sh

# Test installation without actually installing
test-install:
	@echo "Testing installation script (dry-run)..."
	@echo "Note: This will show what would be installed"
	bash -n install.sh
	@echo "✓ Installation script syntax is valid"

# Serve Jekyll documentation locally
serve-docs:
	@echo "Starting Jekyll server..."
	@echo "Documentation will be available at http://localhost:4000"
	cd docs && bundle exec jekyll serve

# Build Jekyll documentation
build-docs:
	@echo "Building Jekyll documentation..."
	cd docs && bundle exec jekyll build
	@echo "✓ Documentation built in docs/_site/"
