#!/usr/bin/env bash

TIMEFORMAT=%R
function run_tests() {
   local total=0
   local successes=0
   local unit_test_file
   for unit_test_file in $(find "$(dirname "$0")"/t -name "*.t.sh"); do
      local test_output=""
      local test_result="*** $(basename "$unit_test_file")$(tput sgr0)"
      test_output="$($unit_test_file "$@" 2>&1)"
      if [ "$?" = 0 ]; then
         test_result="$(tput setaf 2)${test_result}"
        ((successes=successes+1))
      else
         test_result="$(tput setaf 1)${test_result}"
         test_result="${test_result}
${test_output}"
      fi
      echo "$test_result"
      ((total=total+1))
   done
   echo ""
   #use printf to get around the fact that weo cannot return
   printf "$successes/$total Tests Succeeded"
}
time_taken=$( time ( run_tests "$@" 2>&1 ) 3>&1 1>&2 2>&3 )
echo " In ${time_taken}s"
