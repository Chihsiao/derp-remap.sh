#!/usr/bin/env bash
set -euo pipefail

:var() {
  local variable="${1:?variable}"
  # shellcheck disable=SC2015
  if [ "$#" -gt 1 ]; then
    declare -g -- "$variable"="$2"
    return
  fi
  printf '%s\n' "${!variable}"
}

:region() {
  local variable="${1:?variable}"
  variable="DERPMAP_REGION_${variable^^}"
  :var "$variable" "${@:2}"
}

extract_region() {
  jq -c --arg region_code "${1:?region code}" \
      '.Regions[] | select(.RegionCode == $region_code)'  
}

generate_derpmap() {
  local region_array=()

  for KEY in ${!DERPMAP_REGION_*}; do
    region_array+=("${!KEY}")
  done

  jq -c "$@" -n --jsonargs '{
    Regions: (
      [
        $ARGS.positional[] | {
          key: .RegionID | tostring,
          value: .
        }
      ] | from_entries
    )
  }' -- "${region_array[@]}"
}

add_nodes() {
  jq -c --argjson new_nodes "${1:?nodes}" \
      '.Nodes += $new_nodes'
}

DERPMAP_GENERATE_FLAGS=()
# shellcheck disable=SC1090
source "${1:?configuration}" || exit 1
generate_derpmap "${DERPMAP_GENERATE_FLAGS[@]}"
