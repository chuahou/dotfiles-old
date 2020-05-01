#!/bin/bash
#
# installs all current files in this directory to [HOME], ignoring paths matched
# by paths listed in [IGNORE], and backup originals (if any) to [BACKUP]
#
# ./install.sh -o(utput) [HOME] -i(gnore) [IGNORE] -b(ackup) [BACKUP]

print_usage ()
{
	echo "Usage: ./install.sh -o [HOME] -i [IGNORE] -b [BACKUP]"
	echo "    [HOME]: base directory (usually ~) to install symlinks in"
	echo "    [IGNORE]: file with paths to ignore"
	echo "    [BACKUP]: directory to backup to"
}

# defaults
ARGHOME=$HOME
ARGIGNORE=.install_ignore
ARGBACKUP=$(pwd)/.dotfiles_backup

# get options
while getopts 'o:i:b:' OPTION; do
	case "$OPTION" in
		o)
			ARGHOME="$OPTARG"
			;;
		i)
			ARGIGNORE="$OPTARG"
			;;
		b)
			ARGBACKUP="$OPTARG"
			;;
		?)
			print_usage
			exit 1
			;;
	esac
done

# ensure output directory exists and is directory
if [ ! -d "$ARGHOME" ]; then
	>&2 echo "$ARGHOME is not a directory"
	exit 1
fi

# ensure ignore file is a valid file
if [ ! -e "$ARGIGNORE" ]; then
	>&2 echo "$ARGIGNORE could not be read"
	exit 1
fi

# ensure backup directory exists, creating it otherwise
if [[ ! "$ARGBACKUP" =~ ^/ ]]; then # check if ARGBACKUP is absolute path
	ARGBACKUP=$(pwd)/$ARGBACKUP # if not, make it absolute relative to pwd
fi
mkdir -p $ARGBACKUP

# get list of dotfiles with absolute path
IGNOREFILES=$(cat $ARGIGNORE | \
	sed -r "s|/\./|/|g" | \
	sed -r "s|^\./||g") # get paths to ignore and remove excess "./"s
DOTFILES=$(echo "$IGNOREFILES" | \
	xargs printf "! -path ./%s " | \
	xargs find . -type f | \
	sed -r "s|^\./||g") # get paths of DOTFILES and ignore paths, then remove ./

# loop through each dotfile
for DOTFILE in $DOTFILES; do
	# generate full paths
	HOMEPATH=$HOME/$DOTFILE # path of file in [HOME]
	DOTPATH=$(pwd)/$DOTFILE # path of file in .
	BACKUPPATH=$(pwd)/$ARGBACKUP/$DOTFILE # path of backup
done
