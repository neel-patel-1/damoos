#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: GPL-2.0

# This is the main runner script of damoos that interacts with the user.

DAMOOS=$(dirname "$0")

scheme_adapters=$(ls "$DAMOOS/scheme_adapters")


if [ $# -lt 1 ]
then
	echo "$0 log_file"
	exit 1
fi

while [ $# -ne 0 ]; do
	case $1 in
	"--dry")
		DRYRUN=echo
		shift 1
		continue
		;;
	*)
		if [ $# -ne 1 ]
		then
			pr_usage
			exit 1
		fi
		log_file=$1

		break
		;;
	esac
done

adapter_dir="$DAMOOS/scheme_adapters/$adapter"
adapter_requirements=$(cat "$adapter_dir/requirements.txt")
adapter="simple_adapter"

cmd=""
Workload_Name=$3
[ -z "${Workload_Name}" ] && Workload_Name="stairs"
Runtime_Importance_Score=$4
[ -z "${Runtime_Importance_Score}" ] && Runtime_Importance_Score=0.3
Lazybox_Path="/home/shared/lazybox"

if [[ "$adapter" == "simple_adapter" ]]
then
	cmd="sudo DAMOOS=\"$DAMOOS\" bash \"scheme_adapters/simple_adapter/simple_adapter.sh\" $Workload_Name $Runtime_Importance_Score $Lazybox_Path"
fi

if [ "$cmd" == "" ]
then
	echo "something wrong!"
	exit 1
fi

if $DRYRUN script -c "$cmd" -f "$log_file"
then
	echo "Successfull!"
else
	echo "Please fix the mentioned error"
	exit 1
fi

