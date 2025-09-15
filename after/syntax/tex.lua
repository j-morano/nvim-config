vim.cmd [[
  syn region texZone start="\\gls" end="}" contains=@NoSpell
  syn region texZone start="\\Gls" end="}" contains=@NoSpell
]]
