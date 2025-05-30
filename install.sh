#!/bin/bash

log_info() {
  echo -e "\033[34m[INFO]\033[0m $1"
}

create_symlinks() {
  if [ -d "stow" ]; then
    cd stow

    for dir in */; do
      if [ -d "$dir" ]; then
          dir_name=${dir%/}
          log_info "Stowing $dir_name..."
          stow "$dir_name" -t ~/
      fi          
    done
  fi
}

main() {
    create_symlinks
}

main "$@"

