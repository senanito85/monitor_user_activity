##################### Step 1 ##################### 

vi /etc/profile

PORT=`who am i | awk '{ print $5 }' | sed 's/(//g' | sed 's/)//g'`
logger -p local7.notice -t "bash $LOGNAME $$" User $LOGNAME logged from $PORT
    function history_to_syslog
    {
        declare cmd
        declare p_dir
        declare LOG_NAME
        cmd=$(history 1)
        cmd=$(echo $cmd |awk '{print substr($0,length($1)+2)}')
        p_dir=$(pwd)
        LOG_NAME=$(echo $LOGNAME)
        if [ "$cmd" != "$old_command" ]; then
        logger -p local7.notice -- SESSION = $$, from_remote_host = $PORT,  USER = $LOG_NAME,  PWD = $p_dir, CMD = "${cmd}"
        fi
        old_command=$cmd
    }
trap history_to_syslog DEBUG || EXIT












#####################  Step 2 ##################### 

vi /etc/rsyslog.conf

local7.notice                           						/var/log/cmd.log
*.info;mail.none;authpriv.none;cron.none;local7.!notice                     /var/log/messages


#####################  Step 3 #####################

systemctl restart rsyslog

#####################  Step 4 #####################

output 

tailf /var/log/cmd.log