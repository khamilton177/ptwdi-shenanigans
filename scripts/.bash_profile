# Credits
# - Armin Ronacher Dotfiles -- https://github.com/mitsuhiko/dotfiles
# - GA WDI Installfest -- https://github.com/GA-WDI/installfest
# - Bash Ref Manual -- https://www.gnu.org/software/bash/manual/bashref.html
# - LS Colors -- http://geoff.greer.fm/lscolors/
# - Bash Colors -- https://gist.github.com/vratiu/9780109#file-bash_aliases-L51
# - Bash History -- http://jorge.fbarr.net/2011/03/24/making-your-bash-history-more-efficient/


# Increase bash history size
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE


# Aliases
# ===========================================================================

# executing an alias in terminal will execute its respective commands

# open apps
alias chrome='open -a "Google Chrome"'
alias subl='open -a "Sublime Text 3"'

# reload the shell
alias reload="clear; source ~/.bash_profile"


# Colors
# ===========================================================================

# Add colors to ls (mac only)
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"

# Reset text
RESET="\033[0m"

# Regular colors
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
PURPLE="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"

# Bold colors
BBLACK="\033[1;30m"
BRED="\033[1;31m"
BGREEN="\033[1;32m"
BYELLOW="\033[1;33m"
BBLUE="\033[1;34m"
BPURPLE="\033[1;35m"
BCYAN="\033[1;36m"
BWHITE="\033[1;37m"


# Build Bash Prompt
# ===========================================================================

PS1="\n\[${GREEN}\]\u \[${CYAN}\]\w"
PS1+="\$(prompt_git)"
PS1+="\n\[${BYELLOW}\]\$\[${RESET}\] "


# Git Details
# ===========================================================================

# Show more information regarding git status in prompt
GIT_DIFF_IN_PROMPT=true

# Long git to show (+, ?, !)
is_git_repo() {
    $(git rev-parse --is-inside-work-tree &> /dev/null)
}

is_git_dir() {
    $(git rev-parse --is-inside-git-dir 2> /dev/null)
}

get_git_branch() {
    local branch_name
    # Get the short symbolic ref
    branch_name=$(git symbolic-ref --quiet --short HEAD 2> /dev/null) ||
    # If HEAD isn't a symbolic ref, get the short SHA
    branch_name=$(git rev-parse --short HEAD 2> /dev/null) ||
    # Otherwise, just give up
    branch_name="(unknown)"
    printf $branch_name
}

# Git status information
prompt_git() {
    local git_info git_state
    if ! is_git_repo || is_git_dir; then
        return 1
    fi
    git_info=$(get_git_branch)

    if $GIT_DIFF_IN_PROMPT; then
      # Check for uncommitted changes in the index
      if ! $(git diff --quiet --ignore-submodules --cached); then
          git_state+="${RED}+"
      fi
      # Check for unstaged changes
      if ! $(git diff-files --quiet --ignore-submodules --); then
          git_state+="${RED}!"
      fi
      # Check for untracked files
      if [ -n "$(git ls-files --others --exclude-standard)" ]; then
          git_state+="${RED}?"
      fi
      # Check for stashed files
      if $(git rev-parse --verify refs/stash &>/dev/null); then
          git_state+="${RED}$"
      fi
      # Combine branch and state
      if [[ $git_state ]]; then
          git_info="$git_info${RESET}[$git_state${RESET}]"
      fi
    fi

    printf "${RESET} - ${YELLOW}${git_info}"
}
