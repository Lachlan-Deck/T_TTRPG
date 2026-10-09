#!/usr/bin/env bash

set -e

echo ""
echo "Step 1: Fixing file contents..."
echo ""

find . -not -path '*/.*' -not -path './_build*' -not -path './deps*' -type f | while read -r file; do
    perl -pi -e '
        BEGIN { $modified = 0; $| = 1; }
        if (s/[Pp]heonix/Phoenix/g) {
            $modified = 1;
        }
        END {
            if ($modified) {
                print STDERR "Updated content in: $ARGV\n";
            }
        }
    ' "$file"
done

echo ""
echo ""
echo "Step 2: Renaming directories and files..."
echo ""

find . -depth -name "*[Pp]heonix*" | while read -r target; do
    dir=$(dirname "$target")
    base=$(basename "$target")
    
    newbase="${base//Phoenix/Phoenix}"
    newbase="${newbase//Phoenix/Phoenix}"
    
    if [ "$base" != "$newbase" ]; then
        echo "Renaming: $target -> $dir/$newbase"
        mv "$target" "$dir/$newbase"
    fi
done

echo ""
echo "Done! All instances of 'Phoenix/Phoenix' have been fixed."
