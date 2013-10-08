#!/bin/bash

if [ "$2" == "" ];
then
    echo "Usage: $0 <old_version> <new_version> [--apply]"
    exit 1
fi

export OLD=$1
export NEW=$2

#find . -name "$OLD" -exec bash -c 'echo mv "{}" "`dirname {}`/$NEW"' \;

export SED_SCRIPT="s/((module|import)\s+(test\.)?ceylon(\.[a-z]+)+\s+)['\"]($OLD)['\"]/\1\"$NEW\"/g"

if [ "$3" == "--apply" ];
then
    echo "Now do it for real..."
    find . -name module.ceylon -exec sed -r -i "$SED_SCRIPT" "{}" \;
    echo "Done."
else
    find . -name module.ceylon -exec echo sed -r -i "$SED_SCRIPT" "{}" \;
fi

