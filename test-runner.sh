#!/usr/bin/env bash

TIMEFORMAT=%R
function run_tests() {
   local total=0
   local failures=0
   local unit_test_file
   for unit_test_file in $(find "$(dirname "$0")"/t -name "*.t.sh"); do
        echo "*** Running $(basename "$unit_test_file")"
        $unit_test_file "$@"
        if [ "$?" != 0 ]; then
           ((failures=failures+1))
        fi
        ((total=total+1))
   done
   echo ""
   #use printf to get around the fact that we cannot return
   printf "$failures/$total Tests Failed"
}
time_taken=$( time ( run_tests 2>&1 ) 3>&1 1>&2 2>&3 )
echo " In ${time_taken}s"
