#!/bin/bash

failed=0
readarray -t <<<$(git diff main --diff-filter=M --name-only)
for (( i=0; i<${#MAPFILE[@]}; i++ ))
    #Going over all the files that were changed in this PR
    #And making sure that in every file that its filename contains the word "Detection" or "Analytic Rules" and file type must be yaml or yml, the version was updated
    do
    	echo processing the file ${MAPFILE[$i]}.
	if [[ "${MAPFILE[$i]: -4}" == *".psd1"* ]];
	then
		echo ${MAPFILE[$i]} is a manifest file
		diffs=$(echo $(git diff origin/main -U0 --ignore-space-change "${MAPFILE[$i]}"))
		if [[ "$diffs" == *"ModuleVersion:"* ]];
		then
			echo "all good - the version was updated"
		else
			echo "You **did not** change the version in this file: ${MAPFILE[$i]}."
			failed=1
		fi

	else
		echo "${MAPFILE[$i]} is not a manifest file."
    fi
done

exit $failed
