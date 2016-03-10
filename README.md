# scripts
a little script that lets you patch a certain branch and push to your origin.

#add this to your zshrc or bash 
alias gpatch='<dir from root>/git_rebase.sh'

#add a origin remote
git remote add origin <git remote>

#run your script from local branch to other branch. ex from dev to qa
gpatch qa


