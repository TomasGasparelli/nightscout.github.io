#! /bin/bash -eu

rm -Rf out
# mkdir out
export GIT_EMAIL=$GIT_EMAIL
export GIT_NAME=$GIT_NAME
echo $FOO $BAR
GIT_REMOTE=$(git config remote.origin.url)
export NEW_REMOTE="https://${GH_TOKEN}@github.com/${GH_REPO}.git"
( git clone -q -b master "$NEW_REMOTE" out ) 2>&1 > /dev/null
ls out
(
  cd out;
  git rm -r -q ./*
  ls

)
./node_modules/.bin/docpad generate --env static
msg="build from $(git rev-parse HEAD)"
(
  cd out;
  cp ../master.travis .travis.yml
  # cp ../CNAME CNAME
  touch .nojekyll
  git config --local user.email "$GIT_EMAIL"
  git config --local user.name "$GIT_NAME"
  git add .
  git add .travis.yml
  git add .nojekyll
  git status
  git commit -avm "$msg"
  # gh-pages uses master branch on user/org repos
  ( git push -q origin master:master
  ) 2>&1 > /dev/null

)
