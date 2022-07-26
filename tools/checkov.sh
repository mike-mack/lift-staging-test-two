#!/usr/bin/env bash

function tellApplicable() {
    files=$(git ls-files | grep -E '(.tf$|.yaml$|.json$)' | head)
    res="broken"
    if [[ -z "$files" ]] ; then
        res="false"
    else
        res="true"
    fi
    printf "%s\n" "$res"
}

function tellVersion() {
    echo "1"
}

function tellName() {
    echo "Checkov"
}

function emit_results() {
    local input=$1
    echo $1 | jq '.results.failed_checks | [
            .[] |
            select(.check_result.result = "FAILED") |
            .line = .file_line_range[0] |
            .file = "." + .file_path |
            .message = .resource + ": " + .check_name + " ([See " + .check_id + "](https://www.checkov.io/3.Scans/resource-scans.html))" |
            .type = .check_class |
            del(.file_path) |
            del(.evaluations) |
            del(.file_line_range) |
            del(.check_class) |
            del(.code_block) |
            del(.check_result) |
            del(.resource) |
            del(.check_name) |
            del(.check_id)
       ]'
}

function ensure_installed() {
    if [[ ! ( -x "$(command -v checkov)" ) ]] ; then
        pip3 install checkov 1>&2
    fi
}

function run() {
    output=$(timeout 10m checkov --directory . -o json -s 2>/tmp/checkov.log)
    result=$?
    if [[ $result = 0 ]] ; then
        emit_results "$output"
    else
        printf "Tool failed!" >&2
        cat /tmp/checkov.log
        exit $result
    fi
}

case "$3" in
    run)
        ensure_installed
        run
        ;;
    applicable)
        tellApplicable
        ;;
    name)
        tellName
        ;;
    *)
        tellVersion
        ;;
esac