#!/bin/bash

# geth --verbosity=10 &
ROLLUP_STATEDUMP=""
VERBOSITY="10"
while (( "$#" )); do
  case "$1" in
    -r|--rollup.statedumppath)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        ROLLUP_STATEDUMP="$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;    
    -v|--verbosity)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        VERBOSITY="$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    *)
      echo "Unknown argument $1" >&2
      shift
      ;;
  esac
done

cmd="geth --verbosity=$VERBOSITY"
if [ ! -z "$ROLLUP_STATEDUMP" ]; then
    cmd="$cmd --rollup.statedumppath=$ROLLUP_STATEDUMP"
fi
cmd="$cmd &"
$cmd