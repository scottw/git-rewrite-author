#!/bin/sh

## based on http://stackoverflow.com/questions/3042437/change-commit-author-at-one-specific-commit/28845565#28845565

## This script has almost no error checking and no error recovery.
##
## Use at your own risk.
##
## You may be tempted to use this with xargs or in some kind of loop
## to rewrite many commits in a single go. Keep in mind that when you
## rewrite a commit, it and all of its decendant commit ids change. If
## you're trying to rewrite history from the oldest to youngest,
## you'll need to re-query the log to find the new commit ids.

author="$1"
commit="$2"

if [[ "x${commit}" == "x" ]]; then
    echo "usage: git-rewrite-author.sh 'Joe Schmoe <joe@schmoe.org>' 6344d7d3";
    exit 1;
fi

git checkout "$commit" || exit 2;

git commit --amend --no-edit --author "$author"

update="$(git log | head -n 1 | cut -d ' ' -f 2)"

git replace "$commit" "$update"

git filter-branch -f -- --all

git replace -d "$commit"

git checkout master
