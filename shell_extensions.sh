#!/bin/bash

## Bash shell extenstions for personal home lab ##
# Author: Pranav Arun Kumar #
# Created Date: 09/10/2023 #
# Modified Date:  #

create_new_repo(){
    # Function to automate:
    #    1. Create directory for repo with the given repo name ( Argument 1)    
    #    2. CD into the directory and initalize Git repo
    #    3. Check if Github cli is installed and configured properly
    #    4. Connect the created directory to a repo on github and make sure the repo is configured as requested (Argument 2)
    # Arguments
    #    1. Arg1: folder name
    #    2. Arg2: Privacy setting of the repo

    ## Function to call gh cli validity
    check_gh_auth;
    ## create a file and cd into it
    cdmd $1
    
    ## create gh repo in the current repo and connect it to github and print repolist at the end so user can verify repo.
    gh repo create $1 --$2
    gh_username=$(git config user.name)
    gh repo clone $gh_username/$1 . 
}

## create a directory and cd into it
cdmd(){
    ## Function to create a new directory in the current directory and cd into it once done
    mkdir $1 || { echo "FILE ALREADY EXISTS!! Please check your parameters";  exit 0; }
    cd $1;
}

## Github cli check auth status
check_gh_auth(){
    if ! command -v gh >/dev/null 2>&1; then
        echo "Install gh first"
        exit 1
    fi

    if ! gh auth status >/dev/null 2>&1; then
    echo "You need to login: gh auth login"
    exit 1
fi
}

ntfy(){
    ## send success and failure message to ntfy.pranavak.com with the given tag
    ## Arguments:
    ##          1. Tag - Tag you want the message to be published in, please subscribe to this tag on ntfy app or web app
    ##          2. Success message - the message to be published if command ends in success
    ##          3. Fail message - message to be published if command ends in failure
    ntfy_tag=$1
    success_msg=$2
    fail_msg=$3
    ntfy_server="ntfy.pranavak.com"
    curl -d "$success_msg" $ntfy_server/$ntfy_tag || curl -d "$fail_msg" $ntfy_server/$ntfy_tag
}
