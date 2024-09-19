return {
	linters_by_ft = {
		lua = { "selene" },
		sh = { "shellcheck" },
		dockerfile = { "hadolint" },
		proto = { "buf_lint" },
		markdown = {
			"markdownlint",
			"vale",
		},
	},
}
