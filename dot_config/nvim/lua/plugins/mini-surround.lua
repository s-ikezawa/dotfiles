return {
	"echasnovski/mini.surround",
	version = false,
	config = function()
		require("mini.surround").setup({
			mappings = {
				highlight = "sx",
			},
			custom_surroundings = {
				-- 日本語の括弧に対応
				["j"] = {
					input = function()
						local ok, val = pcall(vim.fn.getchar)
						if not ok then
							return
						end
						local char = vim.fn.nr2char(val)

						local dict = {
							["("] = { "（().-()）" },
							["{"] = { "｛().-()｝" },
							["["] = { "「().-()」" },
							["]"] = { "『().-()』" },
							["<"] = { "＜().-()＞" },
							['"'] = { "”().-()”" },
						}

						if char == "b" then
							local ret = {}
							for _, v in pairs(dict) do
								table.insert(ret, v)
							end
							return { ret }
						end

						if dict[char] then
							return dict[char]
						end

						error("%s is unsupported surroundings in Japanese")
					end,
					output = function()
						local ok, val = pcall(vim.fn.getchar)
						if not ok then
							return
						end
						local char = vim.fn.nr2char(val)

						local dict = {
							["("] = { left = "（", right = "）" },
							["{"] = { left = "｛", right = "｝" },
							["["] = { left = "「", right = "」" },
							["]"] = { left = "『", right = "』" },
							["<"] = { left = "＜", right = "＞" },
							['"'] = { left = "”", right = "”" },
						}

						if not dict[char] then
							error("%s is unsupported surroundings in Japanese")
						end
						return dict[char]
					end,
				},
			},
		})
	end,
}
