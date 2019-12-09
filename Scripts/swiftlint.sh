#!/bin/sh

if [[ ! $CI && ! $SKIP_SWIFTLINT ]]; then
  if which swiftlint >/dev/null; then
    swiftlint --no-cache
  else
    echo "error: SwiftLint does not exist, download it from https://github.com/realm/SwiftLint"
    exit 1
  fi
fi
