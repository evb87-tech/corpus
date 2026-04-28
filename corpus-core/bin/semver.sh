#!/usr/bin/env bash
# semver.sh — minimal semver range comparator for corpus-core pack discovery.
#
# This file is meant to be sourced. It defines a single function:
#   semver_satisfies <version> <range>
# Returns 0 (true) if <version> satisfies <range>, 1 otherwise.
#
# Semantics follow corpus-core/rules/09-extension-contract.md §6, NOT npm semver:
#   ^X[.Y[.Z]]   — caret: same major, version >= range_ver. Includes 0.x;
#                  ^0.1 accepts 0.2.0 (pack opted into minor-bump tolerance).
#   ~X[.Y[.Z]]   — tilde: pin minor when minor is explicit (~0.1 → 0.1.x);
#                  if only major given (~1), behave like caret.
#   X[.Y[.Z]]    — exact match (with optional leading =)
#   >=, <=, >, < — inequality operators
# Missing minor/patch components default to 0.

semver_satisfies() {
  local version="$1"
  local range="$2"

  # Parse version: X[.Y[.Z]], missing fields default to 0.
  local v_major v_minor v_patch
  if [[ "$version" =~ ^([0-9]+)(\.([0-9]+))?(\.([0-9]+))?$ ]]; then
    v_major="${BASH_REMATCH[1]}"
    v_minor="${BASH_REMATCH[3]:-0}"
    v_patch="${BASH_REMATCH[5]:-0}"
  else
    return 1
  fi

  local op=""
  local range_ver="$range"

  if [[ "$range" =~ ^(\^|~|>=|<=|>|<|=)(.+)$ ]]; then
    op="${BASH_REMATCH[1]}"
    range_ver="${BASH_REMATCH[2]}"
  fi

  # Parse range. Track whether minor was explicitly given so the tilde branch
  # can distinguish "~1" (any minor) from "~1.2" (pin minor).
  local r_major r_minor r_patch r_minor_given
  if [[ "$range_ver" =~ ^([0-9]+)(\.([0-9]+))?(\.([0-9]+))?$ ]]; then
    r_major="${BASH_REMATCH[1]}"
    r_minor="${BASH_REMATCH[3]:-0}"
    r_patch="${BASH_REMATCH[5]:-0}"
    r_minor_given="${BASH_REMATCH[3]:+yes}"
  else
    return 1
  fi

  local v_int r_int
  v_int=$(( v_major * 1000000 + v_minor * 1000 + v_patch ))
  r_int=$(( r_major * 1000000 + r_minor * 1000 + r_patch ))

  case "$op" in
    "^")
      [[ "$v_major" -eq "$r_major" && "$v_int" -ge "$r_int" ]]
      ;;
    "~")
      if [[ -n "$r_minor_given" ]]; then
        [[ "$v_major" -eq "$r_major" && "$v_minor" -eq "$r_minor" && "$v_int" -ge "$r_int" ]]
      else
        [[ "$v_major" -eq "$r_major" && "$v_int" -ge "$r_int" ]]
      fi
      ;;
    ">=") [[ "$v_int" -ge "$r_int" ]] ;;
    "<=") [[ "$v_int" -le "$r_int" ]] ;;
    ">")  [[ "$v_int" -gt "$r_int" ]] ;;
    "<")  [[ "$v_int" -lt "$r_int" ]] ;;
    "="|"") [[ "$v_int" -eq "$r_int" ]] ;;
    *) return 1 ;;
  esac
}
