#!/bin/bash
# Gabriel Pimentel Dolzan GRR20209948

# Check if the file exists
if [ -f "BD.sqlite3" ]; then
  # Delete the file
  rm BD.sqlite3
fi

# Run the Ruby script
ruby runner.rb