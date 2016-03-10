#!/bin/bash

# calls a git push force on your origin
branch=$1


read -p "push force to origin $1?[Yy] " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
  git push origin $1 --force
fi