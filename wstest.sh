#!/bin/bash

INPUT_FILES=('input.txt' 'input_wrap.txt')
OUTPUT_FILES=('output.txt' 'output_wrap.txt')
TEST_VERSION=2.0

function output_succ() {
    echo -e "\033[32;49;1m$*\033[39;49;0m"
}

function output_error() {
    echo -e "\033[31;49;1m$*\033[39;49;0m"
}

function output_info() {
    echo -e "\033[39;49;2m$*\033[39;49;0m"
}

# @param script
# @example do_test 'ws.py'
function do_test() {
    output_info "$1 test begin"
    local SUCC_NUM=0
    local ERROR_NUM=0
    for INDEX in $(seq 0 $((${#INPUT_FILES[*]}-1)))
    do
        INPUT_FILE=${INPUT_FILES[$INDEX]}
        OUTPUT_BUFFER=$(./${TEST_VERSION}/$1 ./raw/$INPUT_FILE)
        if [[ $OUTPUT_BUFFER = ${OUTPUT_EXPECTS[$INDEX]} ]]; then
            SUCC_NUM=$(($SUCC_NUM + 1))
            output_succ "$INPUT_FILE test success!"
        else
            ERROR_NUM=$(($ERROR_NUM + 1))
            output_error "$INPUT_FILE test fail!"
        fi
    done
    output_info "$1 test finish: $SUCC_NUM success, $ERROR_NUM error"
}

# begin
## get expected outputs
for INDEX in $(seq 0 $((${#OUTPUT_FILES[*]}-1)))
do
    OUTPUT_EXPECTS[$INDEX]=$(cat ./raw/${OUTPUT_FILES[$INDEX]})
done

### test python
#do_test 'ws.py'
#
### test coffee
#do_test 'ws.coffee'
#
## test ruby
do_test 'ws.rb'

### test php
#do_test 'ws.php'
