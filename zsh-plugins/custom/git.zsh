alias eg="ws $(dirname "$0")/git.zsh"

git_current_branch() {
  current_branch=echo git branch --show-current
  echo $current_branch
}

alias ga="git add"
alias gaa="git add --all"
alias gb="git branch"
alias gpu='git push origin "$(git_current_branch)"'
alias gpun="gpu --no-verify"
alias gmc="git merge --continue"
alias gma="git merge --abort"
alias gld="git pull origin development"
alias gco="git checkout"
alias gcd="gco development"
alias gl="git pull"
alias glog="git log"
alias gst="git status"
alias gcp="git cherry-pick"
alias gcpa="gcp --abort"
alias gcpc="gcp --continue"
alias gsta="git stash"
alias gstaa="gsta apply"
alias gsu='git branch --set-upstream-to=origin/$(git_current_branch) $(git_current_branch)'
alias gc="git commit"
alias gcm="gc -m"
grh() { git reset --hard HEAD~$1 }
alias grhh="grh 10"
alias gcb="gco -b $1 && echo"
alias gcbr="gcdr && gcb"
alias g_create_release_branch="gcbr release/$1"

alias gaac="gaa && gcm"
gaap() { gaac $1 && gpu; }
gaapn () { gaac $1 --no-verify && gpun; }
gcl() { git clone git@github:sky-distribution/$1.git }

alias cb="git_current_branch | pbcopy"

gstatus() {
  CHANGES=$(git status -s)
  if [[ ${#CHANGES} -gt 0 ]]; then
     echo 'ABORTED: There are uncommited changes on branch:'
     git status -s
     return 1
  fi
}

alias gco="git checkout"
alias gcd="gco development"
grh() { git reset --hard HEAD~$1 }
alias grhh="grh 10"
alias gl="git pull"
alias gcdr="gstatus && gcd && grhh && gl && ni"
