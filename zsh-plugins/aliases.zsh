PLUGINS_DIR="/Users/jakubkostrzewski/repo/private/mac-env/zsh-plugins/"
CHROME_DIR="/Applications/Google\ Chrome.app"

#chrome
alias ch="open $CHROME_DIR"
alias chga='ch https://github.com/sky-distribution/$(basename $(pwd))/actions'

#npm
alias nr="nu && npm run"
alias nu="nvm use"
ni() {
  nu
  PNPM_LOCK_FILE=pnpm-lock.yaml
  NPM_LOCK_FILE=package-lock.json
  if test -f "$PNPM_LOCK_FILE"; then
      echo "$PNPM_LOCK_FILE exists: using pnpm to install packages"
      pnpm install
  elif test -f "$NPM_LOCK_FILE"; then
      echo "$NPM_LOCK_FILE exists: using npm to install packages"
      npm install
  else
    echo "ERROR: no pnpm-lock.yaml and package-lock.json files found"
  fi
}


alias nil="ni --legacy-peer-deps"
alias nt="nr test"
alias ntf="npx jest -f"
alias ntu="nr test:u"
alias ns="nr start"
alias nsm="nr start:mocked"
alias nsd="nr start:dev"
alias nb="nr build"
alias na="npm audit"
alias naf="npm audit fix"
alias nl="nr -s lint --quiet"
alias nlf="nr -s lint:fix"

#webstorm
alias ws="/Users/jakubkostrzewski/Library/Application\ Support/JetBrains/Toolbox/scripts/webstorm"
wo() { cd "$1" && ws .; }
wsc() { touch "$1" && ws "$1"; }
#node
alias clnm="rm -rf node_modules && ni"
alias clnm!="clnm && rm package-lock.json && ni"

#bash
alias ea="ws $PLUGINS_DIR/aliases.zsh"
alias eg="ws $PLUGINS_DIR/git.zsh"
alias ei="ws $PLUGINS_DIR/init-plugins.zsh"
alias ll="ls -al"

d64 () { echo $1 | base64 --decode; }
e64 () { echo $1 | base64; }

REPO_DIR=/Users/jakubkostrzewski/repo/
fq=${REPO_DIR}fnol-questionnarie

#bee
alias cfq="cd ${fq}"
alias wfq="cfq && ws ."

#GH
triggerGhWorkflowFile() {
  gh workflow run $1 --raw-field branch_name=$(git branch --show-current) --raw-field target=$2
}

deploy() {
  DIGITAL_CICD_YML=.github/workflows/digital-cicd.yml
  DEPLOY_YML=.github/workflows/deploy.yml
  if [[ -f "$DIGITAL_CICD_YML" ]]; then
    triggerGhWorkflowFile $DIGITAL_CICD_YML $1
  fi
  if [[ -f "$DEPLOY_YML" ]]; then
    triggerGhWorkflowFile $DEPLOY_YML $1
  else
    echo No workflow file found
  fi
}

alias dd="deploy dev-3 && chga"
alias du="deploy uat && chga"

#services
alias rstmq="brew services stop rabbitmq && brew services start rabbitmq"

gen_sample_image () {
      FILE_NAME=$1.jpg
  if [ -z "$1" ]
    then
      FILE_NAME=250_KB_size_image.jpg
  fi

  convert -size 8000x8360 xc:white $FILE_NAME
}

gen_pdf () {
  re='^[0-9]+$'
  if ! [[ $1 =~ $re ]] ; then
    echo "error: Not a number";
  else
    START_TIMESTAMP=$(date +%s)
    TEMP_DIR_NAME=temp_$START_TIMESTAMP
    SAMPLE_IMAGE_NAME=sample
    PDF_FILE_NAME="$1_MB_PDF_$START_TIMESTAMP.pdf"
    NUMBER_OF_SAMPLE_COPIES=$(($1 * 4 - 1))

    echo "Generating $PDF_FILE_NAME started... Please wait..."

    mkdir "$TEMP_DIR_NAME"
    cd "$TEMP_DIR_NAME" || exit

    gen_sample_image $SAMPLE_IMAGE_NAME
    for ((i=1; i <= NUMBER_OF_SAMPLE_COPIES; i++)) ;
      do
        cp $SAMPLE_IMAGE_NAME.jpg "$SAMPLE_IMAGE_NAME$i.jpg" ;
      done

    img2pdf ./*.jpg -o "$PDF_FILE_NAME"

    cp "$PDF_FILE_NAME" ../"$PDF_FILE_NAME"
    cd ..
    rm -r "$TEMP_DIR_NAME"

    TIME_IN_SECONDS=$(($(date +%s) - START_TIMESTAMP))
    echo "Creating $PDF_FILE_NAME took $TIME_IN_SECONDS s"
  fi
}


