return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#141218',
				base01 = '#141218',
				base02 = '#88878b',
				base03 = '#88878b',
				base04 = '#2c2c2d',
				base05 = '#f2f0f6',
				base06 = '#f2f0f6',
				base07 = '#f2f0f6',
				base08 = '#c46074',
				base09 = '#c46074',
				base0A = '#7a5cc7',
				base0B = '#4eb464',
				base0C = '#ad9ed5',
				base0D = '#7a5cc7',
				base0E = '#e0d5ff',
				base0F = '#e0d5ff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#88878b',
				fg = '#f2f0f6',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#7a5cc7',
				fg = '#141218',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#88878b' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ad9ed5', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#e0d5ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#7a5cc7',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#7a5cc7',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#ad9ed5',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#4eb464',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#2c2c2d' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#2c2c2d' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#88878b',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
