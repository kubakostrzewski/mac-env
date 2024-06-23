ZSH_PLUGINS_DIR="$(dirname "$0")"

alias ei="ws $ZSH_PLUGINS_DIR/init-plugins.zsh"

source "$ZSH_PLUGINS_DIR"/zsh-autocomplete/zsh-autocomplete.plugin.zsh
for source in $ZSH_PLUGINS_DIR/custom/**/*.zsh; do source $source; done
