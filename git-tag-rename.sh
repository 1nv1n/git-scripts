#!/bin/bash

# Array of GitHub repository URLs
declare -a repoArray=("...proj1.git")

# Array of GitHub repository names
declare -a nameArray=("proj1")

# Array that will store the names of the tags
declare -a tagArray=()

len=${#repoArray[*]}
echo 'Repo. Count: '$len

# Loop through the repositories
count=0
for r in "${repoArray[@]}"
do
  echo '' # Determine the length of the filename
  nameLength=${#nameArray[count]}
  echo 'Project Name Length: '$nameLength
  nameLength=$((nameLength + 2))

  echo '' # Clone the Git repository
  echo '[RUN] git clone '$r
  git clone $r

  echo '' # CD into the cloned repo.
  echo '[RUN] cd '${nameArray[count]}
  cd ${nameArray[count]}

  echo '' # List & store all tags
  echo '[RUN] git tag -l'
  tagArray=($(git tag -l))
  for (( i=0; i<${#tagArray[@]}; i++ ));
    do echo ${tagArray[i]};
  done

  # Loop through each tag
  for t in "${tagArray[@]}"
  do
    echo '' # Identify the commit/object ID of the tag
    echo '[RUN] git rev-parse '$t
    commitID=($(git rev-parse $t))
    echo 'Commit ID for' $t 'is' $commitID

    echo '' # Delete the tag
    echo '[RUN] git tag -d '$t
    git tag -d $t

    echo '' # Delete tag from remote
    echo '[RUN] git push origin :refs/tags/'$t
    git push origin :refs/tags/$t

    echo '' # Update local refs
    echo '[RUN] git fetch --prune --prune-tags'
    git fetch --prune --prune-tags

    echo '' # Create the new (renamed) tag
    tagNameLength=${#t}
    newTagName=$(echo $t | cut -c$nameLength-$tagNameLength)
    echo 'New Tag Name:' $newTagName '(Original Name Length:'$nameLength 'Tag Name Length:'$tagNameLength')'
    echo '[RUN] git tag -a' $newTagName '-m "Renaming"' $commitID
    git tag -a $newTagName '-m "Renaming"' $commitID

    echo '' # Push tags to remote
    echo '[RUN] git push --tags'
    git push --tags
  done

  echo ''
  echo '[RUN] cd ..'
  cd ..

  echo '' # Remove cloned repository
  echo '[RUN] rm -rf '${nameArray[count]}
  rm -rf ${nameArray[count]}

  count=$((count + 1))
done

# End
echo ''
echo 'End.'
