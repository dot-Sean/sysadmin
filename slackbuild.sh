#!/bin/sh
#
#

EXIT_SUCCESS=0
APP_NAME=($basename $0)

log() {
    echo "[$APP_NAME `date +%T`] $1"
    logger $1 -t $APP_NAME
}

usage() {
cat <<EOF
NAME
	$APP_NAME - Build a package from Slackbuilds.

SYNOPSIS
	$(basename $0) REPOSITORY PACKAGE

DESCRIPTION
	$APP_NAME gets the package directory from Slackbuilds and make the Slackware package; REPOSITORY and PACKAGE must be valid names in http://slackbuilds.org/.

OPTIONS
	-h  prints the synopsis

EXAMPLES
	slackbuild.sh network ldapvi
	

SEE ALSO
	http://slackbuilds.org/
	http://www.sbopkg.org/
EOF
exit 1
}

#### MAIN ###

while getopts ":h" option; do
  case $option in
      h)  usage
  esac
done

shift $(($OPTIND - 1))


AREA=$1
APP=$2

test $1 || usage
test $2 || usage

lftp -c "open http://slackbuilds.org/slackbuilds/14.1/$AREA/; mirror $APP"
cd $APP
grep 'DOWNLOAD' $APP.info
wget $(sed -n '/DOWNLOAD/s/.*"\(.*\)"/\1/p' $APP.info | head -1)
/bin/sh $APP.SlackBuild

