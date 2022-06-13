.PHONY: test
test: check-format
	gleam test

.PHONY: check-format
check-format:
	gleam format --check src test

.PHONY: format
format:
	gleam format src test
