ifeq ($(OS),Windows_NT)
	EXT := .ps1
	CMD_BASH := C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy Bypass -Command "bash"
else
	EXT := .sh
	CMD_BASH := bash
endif


.PHONY: pre-commit
pre-commit:
	$(CMD_BASH) scripts/pre-commit-hook.sh
