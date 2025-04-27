remove_large_files() {
    # Rewrite the commit history to remove files larger than 10 MB (10485760 bytes)
    git filter-branch --force --index-filter '
        # Process each file in the index, handling names with spaces or special characters
        while IFS= read -r -d "" path; do
            # Get the blob SHA1 for the file in the current commit's index
            sha1=$(git rev-parse :"$path")
            # Get the size of the blob in bytes
            size=$(git cat-file -s "$sha1")
            # Check if the size exceeds 10 MB
            if [ "$size" -gt 10485760 ]; then
                # Remove the file from the index, ignoring if it’s already absent
                git rm --cached --ignore-unmatch "$path"
            fi
        done < <(git ls-files -z)
    ' --all

    # Remove the backup references created by filter-branch
    git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin

    # Expire all reflog entries immediately to allow garbage collection
    git reflog expire --expire=now --all

    # Garbage collect unreferenced objects, pruning them immediately
    git gc --prune=now
}