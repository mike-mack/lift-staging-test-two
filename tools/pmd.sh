#from https://help.sonatype.com/display/LIFT/pmd

#!/bin/bash
 
# Use:  In the .lift/config specify:
# ```
# customTools = "https://help.sonatype.com/lift/files/78578763/78578764/1/1623180860953/pmd.sh rulesets/java/quickstart.xml"
# ```
dir=$1
# commit=$2
cmd=$3
ruleset=$4
shift
shift
shift
shift
args=$*
 
if [[ "$cmd" = "run" ]] ; then
    if [[ -z "$args" ]] ; then
        jsonout=$(/opt/pmd/bin/run.sh pmd -d "$dir" -R "$ruleset" \
                                          -f codeclimate | \
                    sed  's|\\w|\\\\w|g' | \
                    jq '. | if type == "object" then . else empty end')
    else
        jsonout=$(/opt/pmd/bin/run.sh pmd -d "$dir" -R "$ruleset" \
                                          -f codeclimate "$@" | \
                    sed  's|\\w|\\\\w|g' | \
                    jq '. | if type == "object" then . else empty end')
    fi
 
    echo "$jsonout" | jq "del(.type) | .[\"type\"] = .check_name | del(.\"check_name\")" \
                    | jq "del(.find) | .[\"file\"] = .location.path | del(.\"location.path\")" \
                    | jq "del(.line) | .[\"line\"] = .location.lines.begin | del(.\"location.lines.begin\")" \
                    | jq "del(.message) | .[\"message\"] = .description | del(.\"description\")" \
                    | jq ".file = ( .file | sub(\"^$(pwd)\"; \".\"))" \
                    | jq -s .
fi
 
if [[ "$cmd" = "applicable" ]] ; then
    echo "true"
fi
 
if [[ "$cmd" = "version" ]] ; then
    echo "1"
fi