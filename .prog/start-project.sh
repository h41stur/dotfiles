#!/bin/bash

if [ $# -eq 0 ]
then
    echo -e "Use:\n\t$0 project"
    echo
    exit
fi

cwd="$HOME/pentest/$1"


mkdir -p $cwd/{1-recon/{osint/{manual,tools},scanning/{ports/{custom,tools},web/{custom,toos}}},2-expl/{exploits,payloads},3-post/{1-recon/{manual,tools},2-expl/privesc.3-pivot},4-loot/{scripts,creds,dumps,files,keylog,screenshots},5-logs/{videos,tmuxlogs,rsyslogcommands}}
touch $cwd/5-logs/rsyslogcommands/commands.log

cd $cwd
