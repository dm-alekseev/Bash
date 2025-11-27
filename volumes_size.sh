#!/bin/bash
for dir in /opt/volumes/*/; do
  size_kb=$(du -s "$dir" | cut -f1)
  printf "%s\t%.2fG\n" "$dir" "$(echo "$size_kb / 1024 / 1024" | bc -l)"
done