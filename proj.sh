#!/bin/bash
set -e

remote="origin"
command="help"
workingbranch="dev$RANDOM"

help() {
    cat <<\End-of-help

         Helper script to manage code reviews with gerrit.

         proj [init|update|review|clean] <working branch name>

         Usage:
         proj start: start working on something (remote name,working branch name optional)
         proj update: pull updates from gerrit master (remote name, working branch name optional)
         proj clean: clean branches that are fully merged into master
         proj review : send your work for review (remote name optional)

End-of-help
}

start(){
    echo "Fetching and checking out $workingbranch from $remote/master"
    git fetch $remote
    git checkout -b $workingbranch $remote/master
    cat <<\End-of-Message

Now you have a branch to work on a feature or bug fix.
Commit your work in this branch. Once you're finished
type proj update to get any changes commited while you
worked.

End-of-Message
}

update(){
    cat <<-End-of-Message

This command pulls updates from the remote
and performs a rebase see: http://book.git-scm.com/4_rebasing.html.
If the incoming commits are conflicting with your changes
then merge them manually and type "git rebase --continue" instead of git commit.
Once the command finishes your changes will be placed on top of the incoming commits.

End-of-Message
    echo "Pulling updates from $remote master"
    git pull --rebase $remote master
}

review(){
    branch_name=$(git symbolic-ref HEAD 2> /dev/null | cut -d"/" -f 3)
    echo "Sending commits from $branch_name to $remote for review"
    git push $remote "HEAD:refs/for/master"
    cat <<End-of-Message

Checking out local master branch.
If you want to start working on something else then type "proj start".
If you want to continue working on this item then type "git checkout $branch_name"

End-of-Message
}


clean(){
    echo "This has to be run from master. Switching."
    git checkout master
    echo "Update our list of remotes"
    git fetch
    git remote prune origin
    echo "Remove local fully merged branches"
    git branch --merged master | grep -v 'master$' | xargs git branch -d
}

install(){
    if [ ! -d $HOME/bin ]; then
        echo "~/bin directory not present. Creating now."
        mkdir -p $HOME/bin
    fi
    echo "Copying script to ~/bin"
    cp $0 $HOME/bin/proj
    set +e
    grep -Fxq "export PATH=\$PATH:$HOME/bin/" $HOME/.bashrc
    RETVAL=$?
    set -e
    if [ $RETVAL -eq 1 ]
    then
        echo "Installing bin dir to PATH"
        echo "export PATH=\$PATH:$HOME/bin/" >> $HOME/.bashrc
    else
        echo "Not installing bin dir to PATH"
    fi
    echo "Installation completed."
    echo "Type proj help for instructions"
}


if [ $# -eq 1 ]; then
    command=$1
    workingbranch="dev$RANDOM"
elif [ $# -eq 2 ]; then
     command=$1
     workingbranch=$2    
fi

case "$1" in
    "start")
        start
        ;;
    "update")
        update
        ;;
    "review")
        review
        ;;
    "init")
        init
        ;;
    "clean")
        clean
        ;;
    "install")
        install
        ;;
    *)
        help
    ;;
esac

