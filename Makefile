.PHONY: format-check
format-check:
	gleam format --check src test

.PHONY: format
format:
	gleam format src test
