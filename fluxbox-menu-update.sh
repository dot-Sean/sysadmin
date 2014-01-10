#!/bin/sh
#
# ~/fluxbox-menu-update.sh
#
# nellinux@rocketmail.com
#


###############################################################################
# Configs                                                                     #
###############################################################################


###############################################################################
# Constants                                                                   #
###############################################################################

EXIT_SUCCESS=0
NOOP=0
APP_NAME=($basename $0)


###############################################################################
# Functions                                                                   #
###############################################################################

log() {
    echo "[$APP_NAME `date +%T`] $1"
    logger $1 -t $APP_NAME
}

usage() {
cat <<EOF
Hide items referred to commands not available;  and vice-versa.
USAGE:
    $(basename $0) [OPTIONS]

OPTIONS:
    -h  this help
EOF
}

work_in_progress() {
cat <<EOF
$(basename $0)
Function not yet implemented :-)
EOF
}

###############################################################################
# Get Opts                                                                    #
###############################################################################

while getopts ":h" option; do
  case $option in
      h)  usage
          exit $EXIT_SUCCESS
          ;;
  esac
done

shift $(($OPTIND - 1))



###############################################################################
# MAIN                                                                        #
###############################################################################

name=$1

if [ -r "$1" ]; then
    file=$name
    output=$name.new
else
    file=/dev/stdin
    output=/dev/stdout
fi

while IFS='' read -r row; do

     if echo $row | grep '\[exec\]' > /dev/null; then

         cmdrow=$(printf '%s' "$row" | sed 's/^\( *\)#\(.*\)/\1\2/')

         first_token=$(echo $cmdrow \
             | sed -e 's/^.*{\(.*\)}.*$/\1/' -e 's/-[_a-zA-Z0-9]*//g' \
             | tr -d "&;()" | cut -f1 -d" ")

         if which 1>/dev/null 2>/dev/null $first_token  ; then
             printf "%s\n" "$cmdrow" >> $output
         else
             printf "#%s\n" "$cmdrow" >> $output
         fi
     else
         printf "%s\n" "$row" >> $output
    fi

done < $file

if [ "$output" == "$name.new" ]; then
    mv $file $name.bak
    mv $output $name
fi
