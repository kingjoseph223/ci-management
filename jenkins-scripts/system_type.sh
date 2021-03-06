#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0
##############################################################################
# Copyright (c) 2018 IBM Corporation, The Linux Foundation and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License 2.0
# which accompanies this distribution, and is available at
# https://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# vim: sw=4 ts=4 sts=4 et :

HOST=$(/bin/hostname)
SYSTEM_TYPE=''

IFS='-' read -r -a HOSTPARTS <<< "${HOST}"

# slurp in the control scripts
# shellcheck disable=SC2207
FILES=($(find . -maxdepth 1 -type f -iname '*.sh' -exec basename -s '.sh' {} \;))
# remap into an associative array
declare -A A_FILES
for key in "${!FILES[@]}"
do
    A_FILES[${FILES[$key]}]="${key}"
done

# Find our system_type control script if possible
for i in "${HOSTPARTS[@]}"
do
    if [ "${A_FILES[${i}]}" != "" ]
    then
        SYSTEM_TYPE=${i}
        break
    fi
done

# Write out the system type to an environment file to then be sourced
echo "SYSTEM_TYPE=${SYSTEM_TYPE}" > /tmp/system_type.sh
