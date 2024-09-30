#!/usr/bin/env derp-remap.sh
# shellcheck shell=bash

:var DERPMAP "$(wget  -qO - -- \
    "${DERPMAP_SRC:=https://controlplane.tailscale.com/derpmap/default}")"

:region hkg "$(
    :var DERPMAP \
    | extract_region hkg \
    | add_nodes '[
      {
        "Name": "20z", "RegionID": 20,
        "HostName": "derp20z.tailscale.com",
        "CanPort80": true
      }
    ]')"

printf 'Content-type: %s\n\n' "application/json"
