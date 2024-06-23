alias ea="ws $(dirname "$0")/aliases.zsh"

CHROME_DIR="/Applications/Google\ Chrome.app"

#postgres
alias pg-local="export PGPASSWORD=postgres && pgcli -U postgres -h localhost -p 5432"

#chrome
alias ch="open $CHROME_DIR"
alias chga='ch https://github.com/sky-distribution/$(basename $(pwd))/actions'
alias og='ch https://github.com/sky-distribution/$(basename $(pwd))'
alias opr='ch https://github.com/sky-distribution/$(basename $(pwd))/pulls'

#npm, pnpm
alias t="npx tsc"
alias j="npx jest"
alias ju="npx jest -u"
alias jf="npx jest -f"
getPackageManager() {
  if test -f "pnpm-lock.yaml"; then
        echo 'pnpm'
    elif test -f "package-lock.json"; then
        echo 'npm'
    elif test -f "yarn.lock"; then
        echo 'yarn'
    else
      echo "ERROR: no pnpm-lock.yaml, package-lock.json and yarn.lock files found" > /dev/stdout
    fi
}

alias nu="nvm use"

nr(){
  echo "nu && $(getPackageManager) run"
}
alias ni='eval "nu && $(getPackageManager) install $1"'
alias pa="nu && pnpm add"
alias pad="nu && pnpm add -D"
alias nil="ni --legacy-peer-deps"
alias nt='eval "t && $(nr) test"'
alias ntf="nt -f"
alias ntu='eval "$(nr) test:u"'
alias ns='eval "$(nr) start"'
alias nsm='eval "$(nr) start:mocked"'
alias nsd='eval "$(nr) start:dev"'
alias nb='eval "$(nr) build"'
alias na='eval "$(getPackageManager) audit"'
alias naf='eval "$(getPackageManager) audit fix"'
alias nl='eval "$(nr) -s lint --quiet"'
alias nlf='eval "$(nr) -s lint:fix --quiet"'

#webstorm
alias ws="/Users/jakubkostrzewski/Library/Application\ Support/JetBrains/Toolbox/scripts/webstorm"
wo() { cd "$1" && ws .; }
wsc() { touch "$1" && ws "$1"; }
#node
alias clnm="rm -rf node_modules && ni"
alias clnm!="clnm && rm package-lock.json && ni"

#bash
alias ll="ls -al"
d64 () { echo $1 | base64 --decode; }
e64 () { echo $1 | base64; }
alias cls='printf "\033c"'

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

#typeorm
alias pmr="nu && pnpm migration:run"
alias pmg='nu && pnpm migration:run && pnpm migration:generate && pnpm migration:run'

alias nmg="nu && npm run migration:run && npm run migration:generate && npm run migration:run"
alias nmr="nu && npm migration:run"

#jwt
function jwt-decode() {
  jq -R 'split(".") | .[0],.[1] | @base64d | fromjson' <<< $1
}
