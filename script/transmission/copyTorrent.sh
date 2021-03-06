#!/usr/bin/env bash
#--------------------------------------------------------------------------------------------------
# Copia file in una directory predefinita
# Copyright (c) Marco Lovazzano
# Licensed under the GNU General Public License v3.0
# http://github.com/martcus
#--------------------------------------------------------------------------------------------------

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

# IFS stands for "internal field separator". It is used by the shell to determine how to do word splitting, i. e. how to recognize word boundaries.
SAVEIFS=$IFS
IFS=$(echo -en "\n\b") # <-- change this as it depends on your app

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

# log4.sh inclusion
source log4.sh -v INFO -d "+%Y-%m-%d %H:%M:%S" # use -f $__base.$(date +%Y%m%d_%H%M%S).log

DEBUG "__dir  = $__dir"
DEBUG "__file = $__file"
DEBUG "__base = $__base"
DEBUG "__root = $__root"

# --> function

# --> Main script
declare -A dirmap
dirmap["BOOKS"]="./provadir"
dirmap["TVSHOW"]=tvshow_dir
dirmap["MOVIES"]=movies_dir

# chiamata dello script <param per dir> <file>, ottimale se inserire le dir in un file di config di properties
DESTDIR="${dirmap["$1"]}"
FILE="$2"

if [ ! -e $DESTDIR ]; then
    WARN "Directory $DESTDIR does not exist. $DESTDIR will be created by the cp command."
fi

if [ -f $FILE ]; then
    cp -vr "$FILE" "$DESTDIR" | INFO
else
    FATAL "File $FILE does not exist."
    exit 1
fi

IFS=$SAVEIFS

exit 0
