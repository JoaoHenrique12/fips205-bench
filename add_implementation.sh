#!/bin/bash

# Load variables
source common_resources.sh


if [ "$#" -ne 4 ]; then
  echo "Error: This script expects exactly four arguments."
  echo "Usage: add_implementation.sh algorithmName languageImplemented mainBranch gitRepositoryLink"
  echo "-> algorithmName = [${valid_algorithms[@]}]"
  echo "-> languageImplemented = [${valid_languages[@]}]"
  echo "-> mainBranch = ['main', 'master', 'any_other_branch_name']"
  echo "-> gitRepositoryLink = ['any_https_github_gitlab_link']"
  exit 1
fi

# Assign the received arguments to variables
algorithmName="$1"
languageImplemented="$2"
mainBranch="$3"
gitRepositoryLink="$4"


# Validate algorithmName
if is_in_list  "$algorithmName" "${valid_algorithms[@]}"; then
  echo "algorithm: $algorithmName"
else
  echo "algorithm <$algorithmName> not found on list [${valid_algorithms[@]}]"
  exit 1
fi

# Validate languageImplemented
if is_in_list  "$languageImplemented" "${valid_languages[@]}"; then
  echo "language: $languageImplemented"
else
  echo "algorithm <$languageImplemented> not found on list [${valid_languages[@]}]"
  exit 1
fi

# Regex to capture the username after the second '/' and before the next '/'
regex='^https:\/\/(github|gitlab)\.com\/([^\/]+)\/.*$'

gitUser=""
if [[ "$gitRepositoryLink" =~ $regex ]]; then
  gitUser="${BASH_REMATCH[2]}"
else
  echo "Could not extract the username from the git link. <$gitRepositoryLink>"
  exit 1
fi

echo "user: $gitUser"
echo "gitRepositoryLink: $gitRepositoryLink"
echo "mainBranch: $mainBranch"

# Copy template to respective folder
mkdir -p algorithms/$algorithmName/"$languageImplemented-$gitUser"
cp -r templates/$languageImplemented/* algorithms/$algorithmName/"$languageImplemented-$gitUser"/
cp templates/metadata.json algorithms/$algorithmName/"$languageImplemented-$gitUser"/

# Update metadata
## Ensure jq is installed
if ! command -v jq &> /dev/null
then
  echo "jq is not installed. Please install it using: sudo apt install jq"
  exit 1
fi

metadata_file=algorithms/$algorithmName/"$languageImplemented-$gitUser"/metadata.json

jq ".git_link = \"$gitRepositoryLink\"" "$metadata_file" > tmp.json && mv tmp.json "$metadata_file"
jq ".branch = \"$mainBranch\"" "$metadata_file" > tmp.json && mv tmp.json "$metadata_file"

# Clone repository

git clone $gitRepositoryLink algorithms/$algorithmName/"$languageImplemented-$gitUser"/git-repository/

exit 0
