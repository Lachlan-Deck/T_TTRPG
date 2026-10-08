find . -not -path '*/.*' -not -path './_build*' -not -path './deps*' -type f | while read -r file; do
    perl -pi -e 's/[Pp]heonix/Phoenix/g' "$file"
done
