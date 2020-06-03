
####################  File1
$ cat /etc/profile.d/bash_syslog.sh

TMLOGLEVEL=local1.notice
TMLOGGER=/usr/bin/logger
HISTCONTROL="ignoredups"
TMSHELLPID=$$

TMGECOS=$GECOS
export TMGECOS TMLOGLEVEL TMLOGGER HISTCONTROL TMSHELLPID
readonly TMGECOS TMLOGLEVEL TMLOGGER HISTCONTROL TMSHELLPID





###################### File2
$ cat /etc/sysconfig/bash-prompt-xterm
function log2syslog ()
{
    if [ -z "$TMLOGLEVEL" -o -z "$TMGECOS" ] ; then
	return
    fi

    declare command
    command=$(history 1 | cut -b8-)
    echo $command | xargs $TMLOGGER -p $TMLOGLEVEL -t bash\[$TMSHELLPID\] -- \[$TMGECOS/$USER:$UID:$EUID\]:
}

echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/$HOME/~}\007"; history -a; log2syslog