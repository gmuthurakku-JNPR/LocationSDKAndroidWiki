#!/bin/bash

# Check if both arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <base-branch> <target-branch>"
    exit 1
fi

# Assign arguments to variables
BASE_BRANCH=$1
TARGET_BRANCH=$2

# Fetch the latest changes from the remote (optional, can be skipped if working locally)
git fetch origin

# Display commit descriptions (body) unique to the target branch compared to the base branch
echo "Commit descriptions (optional) unique to branch '$TARGET_BRANCH' (compared to '$BASE_BRANCH'):"

# List commits with only descriptions, skipping titles if the body is not empty
git log "$BASE_BRANCH".."$TARGET_BRANCH" --pretty=format:"%h%n%b%n" | awk 'NF'
