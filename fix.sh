#!/bin/sh

# Prompt user for correct name and email
echo "Enter the correct name:"
read CORRECT_NAME
echo "Enter the correct email:"
read CORRECT_EMAIL

# Old email to be replaced
echo "Enter the old email:"
read OLD_EMAIL

git filter-branch --env-filter '
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags