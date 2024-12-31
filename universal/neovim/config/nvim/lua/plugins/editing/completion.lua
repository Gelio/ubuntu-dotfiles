return {
	{
		"saghen/blink.cmp",
		version = "*",
		event = { "InsertEnter", "CmdlineEnter" },

		dependencies = {
			"rafamadriz/friendly-snippets",
			{
				"saghen/blink.compat",
				version = "*",
				lazy = true,
				opts = {},
			},
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-calc",
			{
				"Gelio/cmp-natdat",
				opts = {
					cmp_kind_text = "NatDat",
					highlight_group = "BlinkCmpKindText",
				},
			},
			"moyiz/blink-emoji.nvim",
			{
				"David-Kunz/cmp-npm",
				lazy = true,
				dependencies = { "nvim-lua/plenary.nvim" },
				config = true,
				event = "BufRead package.json",
			},
		},

		opts = {
			keymap = {
				preset = "default",
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<C-h>"] = { "snippet_backward", "fallback" },
				["<C-l>"] = { "snippet_forward", "fallback" },
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
				kind_icons = {
					-- TODO: fix me, so the UI uses this icon
					NatDat = "📅",
				},
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "natdat", "emoji", "nvim_lua", "calc", "npm" },
				providers = {
					natdat = {
						name = "natdat",
						module = "blink.compat.source",
					},
					buffer = {
						min_keyword_length = 4,
					},
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15,
					},
					["nvim_lua"] = {
						name = "nvim_lua",
						module = "blink.compat.source",
					},
					calc = {
						name = "calc",
						module = "blink.compat.source",
					},
					npm = {
						name = "npm",
						module = "blink.compat.source",
					},
				},
			},

			completion = {
				accept = {
					auto_brackets = {
						enabled = false,
					},
				},
				menu = {
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind", gap = 1 },
							{ "source_name" },
						},
						components = {
							source_name = {
								highlight = "Normal",
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					window = { border = "single" },
				},
			},
			signature = {
				-- NOTE: use build-in <C-j> signature
				enabled = false,
				window = { border = "single" },
			},
		},
	},
}
