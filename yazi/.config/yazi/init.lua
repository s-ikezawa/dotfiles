require("fr"):setup {
  bat = "--style 'header,grid'",
  fzf = [[--info-command='echo -e "$FZF_INFO ❤️"' --no-scrollbar]],
  rg = "--colors 'line:fg:red' --colors 'match:style:nobold'",
}

require("git"):setup {
  order = 1500,
}

