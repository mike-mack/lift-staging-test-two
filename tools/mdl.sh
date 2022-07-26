#from https://help.sonatype.com/display/LIFT/mdl
#!/bin/bash
 
# Use:  In the .lift/config specify:
# ```
# customTools = "https://help.sonatype.com/lift/files/78578761/78578762/1/1623180857208/mdl.sh"
# ```
dir=$1
# commit=$2
cmd=$3
shift
shift
shift
args=$*
 
if [[ "$cmd" = "run" ]] ; then
    gem install mdl 1>&2
    MDLOUT=$(mdl --json $args ${dir})
    echo "$MDLOUT" | jq '[ .[] | .file = .filename | .type = "MDL (" + .rule + ", " + .aliases[0] + ")" | .message = .description | del(.aliases) | del(.description) | del(.filename) | del(.rule) ]'
fi
 
if [[ "$cmd" = "name" ]] ; then
    echo "MDL"
fi
 
if [[ "$cmd" = "applicable" ]] ; then
    echo "true"
fi
 
if [[ "$cmd" = "version" ]] ; then
    echo 1
fi