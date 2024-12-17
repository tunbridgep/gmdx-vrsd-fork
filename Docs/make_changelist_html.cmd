cd %~dp0
pandoc -f markdown -t html "List of Changes.md" -o  "List of Changes.html"