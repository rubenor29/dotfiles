# Tokyo Night color scheme for Fish syntax highlighting
# (Prompt handled by Starship)

set -g RED f7768e
set -g GREEN 9ece6a
set -g ORANGE ff9e64
set -g YELLOW e0af68
set -g BLUE1 b4f9f8 
set -g BLUE2 7dcfff
set -g BLUE3 73daca
set -g BLUE4 2ac3de
set -g BLUE5 7aa2f7
set -g MAGENTA bb9af7
set -g BG1 565f89
set -g BG2 414868
set -g BG3 1a1b26
set -g WHITE c0caf5

# Base colors
set -g fish_color_normal $GRAY                                  # normal text
set -g fish_color_command $GREEN --bold --italics --underline # commands like echo, ls, git
set -g fish_color_param $BLUE4                                  # command parameters
set -g fish_color_error $RED                                    # error highlight
set -g fish_color_quote $YELLOW                                 # quoted strings (echo "text")
set -g fish_color_redirection $ORANGE                           # > < >> etc.
set -g fish_color_end $MAGENTA                                    # keywords like end, if, else, begin
set -g fish_color_operator $ORANGE                              # operators like =, $, *, ~
set -g fish_color_escape $BLUE1                                 # escape sequences (\n, \t)
set -g fish_color_autosuggestion $GRAY2                         # autosuggestions (faint gray)
set -g fish_color_valid_path --underline $BLUE5                 # valid paths (underlined)
set -g fish_color_selection --background=$BG2                 # selection background
set -g fish_color_search_match --background=$BG1 $WHITE       # search match
set -g fish_color_option $BLUE2 --italics                       # command options (--help, -l)

# Additional special cases
set -g fish_pager_color_completion a9b1d6
set -g fish_pager_color_description 565f89
set -g fish_pager_color_prefix 7dcfff
set -g fish_pager_color_progress 3b4261
