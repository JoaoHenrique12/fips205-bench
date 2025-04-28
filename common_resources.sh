# Function to check if a value is in a list
is_in_list() {
  local value=$1
  shift
  local list=("$@")

  for item in "${list[@]}"; do
    if [[ "$item" == "$value" ]]; then
      return 0  # Found
    fi
  done
  return 1  # Not found
}

# Exports
export valid_algorithms=("lamport")
export valid_languages=("python" "golang")
export -f is_in_list
