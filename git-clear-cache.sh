#!/bin/bash

### Declare Array of GitHub repositories URLs
declare -a repoArray=("...proj-1.git"
"...proj-2.git")

### Declare Array of GitHub repository names
declare -a nameArray=("proj-1"
"proj-2")

len=${#repoArray[*]}

### Loop through the array
count=0
for i in "${repoArray[@]}"
do
  echo '[RUN] git clone '$i
  git clone $i
  cd ${nameArray[count]}
  echo '[RUN] git rm -r --cached . '
  git rm -r --cached .
  echo '[RUN] git add . '
  git add .
  echo '[RUN] git commit -am Cleared Git Cache'
  git commit -am "Cleared Git Cache"
  echo '[RUN] git push'
  git push
  echo '[RUN] cd ..'
  cd ..
  echo '[RUN] rm -rf '${nameArray[count]}
  rm -rf ${nameArray[count]}
  count=$((count + 1))
done

# End
echo ''
echo 'End.'
