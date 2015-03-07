#!/usr/bin/env bash

for unit_test_file in $(find t -name "*.t.sh"); do
    echo "*** Running Test $(basename "$unit_test_file") ***"
    $unit_test_file
done
