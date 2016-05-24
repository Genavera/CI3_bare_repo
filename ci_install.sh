#!/bin/bash

#-- REQUIRED PARAMETERS
#-- $1 = command (install|upgrade)
#-- $2 = CI tag version (default 3.03)

#-- DEFAULT VARIABLES
CI_GIT="git://github.com/bcit-ci/CodeIgniter.git"
CI_TAG="3.0.3"
CI_DIR="CI"

#-- Check if installation directory is present
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CI_PATH=$CWD"/"$CI_DIR

#-- Check GIT executable
GIT_EXEC=`which git`
if [ -z "$GIT_EXEC" ]; then
    echo "No Git executable to use."
    exit 11
fi


#-- Execute command parameter
case "$1" in
    install)
        #-- Check if git is already installed in path
        if [ -d "$CI_PATH/.git" ]; then
            echo "CI already installed in [ $CI_PATH ]"
            exit 2
        fi

        #-- Create the necesary path
        if [ ! -d "$CI_PATH" ]; then
            mkdir $CI_PATH
        fi

	#-- Clone the repo
        echo "-- Cloning $CI_GIT into $CI_PATH..."
	$GIT_EXEC clone $CI_GIT $CI_PATH
	if [ $? -ne 0 ]; then
            echo "Git clone execution failure [ $? ] command [ $GIT_EXEC clone $CI_GIT $CI_PATH ]"
            echo 3
        fi

        #-- Swith to the repo
        echo "-- Acquiring CodeIgniter tags"
        cd $CI_PATH
        $GIT_EXEC fetch --tags
	echo "-- Available tags :"
        $GIT_EXEC tag

        #-- Switch to the actual tag
        if [ ! -z "$2" ]; then
            CI_TAG="$2"
        fi
        echo "-- Switching to tag $CI_TAG"
        $GIT_EXEC checkout $CI_TAG
	if [ $? -ne 0 ]; then
           echo "Tag switching failed. Manually checkout tag [ $CI_TAG ] on [ $CI_PATH ] or clean the directory and try the command again."
           exit 4
        fi
        ;;

    upgrade)
        #-- Check if git is already installed in path
        if [ ! -d "$CI_PATH/.git" ]; then
            echo "CI not yet installed in [ $CI_PATH ]"
            exit 5
        fi

        #-- Swith to the repo
        echo "-- Acquiring CodeIgniter tags"
        cd $CI_PATH
        $GIT_EXEC fetch --tags
	echo "-- Available tags :"
        $GIT_EXEC tag

        #-- Switch to the actual tag
        if [ ! -z "$2" ]; then
            CI_TAG="$2"
        fi
        echo "-- Switching to tag $CI_TAG"
        $GIT_EXEC checkout $CI_TAG
	if [ $? -ne 0 ]; then
           echo "Tag switching failed. Manually checkout tag [ $CI_TAG ] on [ $CI_PATH ] or clean the directory and try the command again."
           exit 4
        fi
        ;;


    *)
        echo "Unknown command parameter"
        exit 1
esac

echo "ci_install.sh [ $1 ] successful"
exit 0




