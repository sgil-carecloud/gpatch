#!/bin/bash

# TO USE: RUN SCRIPT WITH THE NAME OF THE DESTINATION BRANCH AS A PARAM
# EX: ./git_rebase.sh QA
# YOU CAN ALSO PASS IN A PATCH NAME AS A SECOND PARAM
# EX: ./git_rebase.sh QA c1.patch
clear
current_branch=$(git rev-parse --abbrev-ref HEAD)
dest_branch=$1

if [ "$2" != "" ]; then
  patch_name=$2
else
  patch_name="c1_$RANDOM.patch"
fi

function clear
{
  rm $patch_name
  git checkout $current_branch
}
echo "REBASING: $current_branch"
git rebase -i $dest_branch ||  { echo 'FAILURE' ;$(clear); exit 1; }

echo "PREPARING PATCH: $patch_name"
$(git format-patch $dest_branch --stdout > $patch_name) ||  { echo 'FAILURE' ;$(clear); exit 1; }

echo "SWITCHING TO BRANCH: $dest_branch"
git checkout $dest_branch

echo "CHECKING STATUS OF: $patch_name"
git apply --stat $patch_name ||  { echo 'FAILURE' ;$(clear); exit 1; }
read -p "checkout changes?[Yy] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "RUN GIT CHECKOUT: $patch_name"
    git apply --check $patch_name  ||  { echo 'FAILURE' ;$(clear); exit 1; }

    echo "RUN GIT AM ON  $patch_name"
    git am --signoff < $patch_name  ||  { echo 'FAILURE' ;$(clear); exit 1; }

    echo "SUCCESSFULLY PATCHED $dest_branch WITH $patch_name"

    echo "DELETING PATCH FILE: $patch_name"
    rm $patch_name 
fi

read -p "push to $dest_branch?[Yy] " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    git push origin $dest_branch
fi

echo "SUCCESSFULLY EXITING"
exit 0
