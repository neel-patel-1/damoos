#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: GPL-2.0

# This is the main runner script of damoos that interacts with the user.

DAMOOS=$(dirname "$0")

if [ $# -lt 1 ]
then
	pr_usage
	exit 1
fi

function pr_usage {
	echo "Usage: $0 <log file> <workload> <Runtime_Importance_Score>"
	echo
}

adapter="simple_adapter"
scheme_adapters=$(ls "$DAMOOS/scheme_adapters")
adapter_dir="$DAMOOS/scheme_adapters/$adapter"
adapter_requirements=$(cat "$adapter_dir/requirements.txt")

cmd=""
log_file=$1
[ -z "${Workload_Name}" ] && Workload_Name="stairs"
Workload_Name=$2
[ -z "${Workload_Name}" ] && Workload_Name="stairs"
Runtime_Importance_Score=$3
[ -z "${Runtime_Importance_Score}" ] && Runtime_Importance_Score=0.3
Lazybox_Path="/home/shared/lazybox"

cmd="sudo DAMOOS=\"$DAMOOS\" bash \"scheme_adapters/simple_adapter/simple_adapter.sh\" $Workload_Name $Runtime_Importance_Score $Lazybox_Path"

if $DRYRUN script -c "$cmd" -f "$log_file"
then
	echo "Successfull!"
else
	echo "Please fix the mentioned error"
	exit 1
fi

