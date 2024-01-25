function sync_branch() {
  # Name of the branch to sync, defaults to current branch
  # local branch_name="${1:-$(git rev-parse --abbrev-ref HEAD)}"

  script_dir=$(dirname "$0")
  current_dir=$(cd "$script_dir" && pwd)
  echo "Current directory: $current_dir"
  current_branch=$(git -C "$current_dir" rev-parse --abbrev-ref HEAD)

  echo "Current branch: $current_branch"

  local branch_name="${1:-$(git rev-parse --abbrev-ref HEAD)}"

  echo "Branch name: $branch_name"


  # Check if the branch exists remotely
  if ! git -C "$current_dir" show-ref --quiet --verify "refs/remotes/origin/${current_branch}"; then
    echo "Remote branch does not exist."
    exit 1
  fi

  # Rest of the code...
}

  # Check for uncommitted changes
  if ! git -C "$current_dir" diff-index --quiet HEAD --; then
    echo "Uncommitted changes found. Please commit or stash your changes before syncing."
     git -C "$current_dir" add .
     git -C "$current_dir" status
    commit_message="Syncing branch $current_branch - $(date +%Y-%m-%d)"
    git -C "$current_dir" commit -m "$commit_message" 
  fi





   

    # Fetch all branches
    git -C "$current_dir" fetch origin

    # Compare local and remote branches
    local_status=$(git rev-list --left-right --count "${current_branch}"...origin/"${current_branch}")

    # Split the output into behind and ahead counts
    local behind=$(echo "$local_status" | cut -f1)
    local ahead=$(echo "$local_status" | cut -f2)

    if [ "$behind" -gt 0 ] && [ "$ahead" -eq 0 ]; then
        # If the local branch is behind and not ahead, try to merge
        if git -C "$current_dir" merge --ff-only origin/"${branch_name}"; then
            echo "Merged remote changes into ${branch_name}."
        else
            echo "Merge conflict detected. Aborting merge."
            git -C "$current_dir" merge --abort
            return 1
        fi
    elif [ "$ahead" -gt 0 ]; then
        # If the local branch is ahead, push the changes
        if git -C "$current_dir" push origin "${branch_name}"; then
            echo "Pushed local changes to the remote."
        else
            echo "Failed to push local changes to the remote."
            return 1
        fi
    else
        echo "Local and remote branches are already in sync."
    fi
}

# Usage: sync_branch [branch_name]
# If branch_name is not provided, it uses the current branch.

sync_branch
