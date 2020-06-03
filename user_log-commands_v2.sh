# To be stored at /etc/profile.d/log-commands.sh with mode 644
#
# Log commands to syslog, where they will be picked up by the log watcher
function log2syslog
{
   declare command
   # command=$BASH_COMMAND
   command=$(history 1 | cut -b8-)
   if [ "$command" != "" -a "$command" != "history -a" ]; then
     logger -p local1.notice -t bash -i -- "${USER}@${HOSTNAME}:${PWD/$HOME/~}:$command"
   fi
}

# Only append to history file - rather than overwite it
shopt -s histappend

# Save all lines of a multi-line command in the same history entry
shopt -s cmdhist

# Force the history filename
HISTFILE="$HOME/.bash_history"

# Don't use the default size limits
HISTFILESIZE=1000000
HISTSIZE=1000000

# Don't let items with leading spaces skip history, or ignore duplicate commands
HISTCONTROL=ignoreboth

# Don't ignore specific patterns
#HISTIGNORE=""

# Log the time when things happened too
HISTTIMEFORMAT='%F %T '
#HISTTIMEFORMAT=''

# Write to the history immediately
PROMPT_COMMAND='log2syslog'

# Reset the history number
unset HISTCMD

# Special root settings
if groups | grep -q root
then
  # Timeout root logins after 3600 seconds (1 hour)
  TMOUT=3600
fi
