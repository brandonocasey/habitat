if [ ! -f "$assert_script" ] || [ ! -f "$stub_script" ]; then
    wget "https://raw.githubusercontent.com/lehmannro/assert.sh/master/assert.sh" "$assert_script"
    wget  "https://raw.githubusercontent.com/jimeh/stub.sh/master/stub.sh" "$stub_script"
fi

for unit_test_file in $(find "$unit_test_dir" -name "*.t.sh"); do
    unit_test="$(basename "$unit_test_file")"
    echo "*** Running Test $unit_test ***"
done
