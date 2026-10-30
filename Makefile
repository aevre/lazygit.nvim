LUA_FILES := $(shell find lua plugin -name '*.lua')
TEST_FILES := $(wildcard tests/*.lua)
NVIM_BIN ?= nvim

.PHONY: fmt fmt-check lint test check

fmt:
	stylua $(LUA_FILES) $(TEST_FILES)

fmt-check:
	stylua --check $(LUA_FILES) $(TEST_FILES)

lint:
	selene $(LUA_FILES)

test:
	$(NVIM_BIN) --clean --headless -u NONE --cmd 'set rtp^=.' -l tests/lazygit.lua

check: fmt-check lint test
