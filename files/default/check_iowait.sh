#!/bin/bash
#
# Check CPU Performance plugin for Nagios
#
# Licence : GPL - http://www.fsf.org/licenses/gpl.txt
#
# Author        : Luke Harris
# version       : 2011090802
# Creation date : 1 October 2010
# Revision date : 8 September 2011
# Description   : Nagios plugin to check CPU performance statistics.
#               This script has been tested on the following Linux and Unix platforms:
#       RHEL 4, RHEL 5, RHEL 6, CentOS 4, CentOS 5, CentOS 6, SUSE, Ubuntu, Debian, FreeBSD 7, AIX 5, AIX 6, and Solaris 8 (Solaris 9 & 10 *should* work too)
#               The script is used to obtain key CPU performance statistics by executing the sar command, eg. user, system, iowait, steal, nice, idle
#       The Nagios Threshold test is based on CPU idle percentage only, this is NOT CPU used.
#       Support has been added for Nagios Plugin Performance Data for integration with Splunk, NagiosGrapher, PNP4Nagios,
#       opcp, NagioStat, PerfParse, fifo-rrd, rrd-graph, etc
#
# USAGE         : ./check_cpu_perf.sh {warning} {critical}
#
# Example: ./check_cpu_perf.sh 20 10
# OK: CPU Idle = 84.10% | CpuUser=12.99; CpuNice=0.00; CpuSystem=2.90; CpuIowait=0.01; CpuSteal=0.00; CpuIdle=84.10:20:10
#
# Note: the option exists to NOT test for a threshold. Specifying 0 (zero) for both warning and critical will always return an exit code of 0.

# Change log    : 2012/04/30 Yahoo! Japan

#Ensure warning and critical limits are passed as command-line arguments
if [ -z "$1" -o -z "$2" ]
then
    echo "Please include two arguments, eg."
    echo "Usage: $0 {warning} {critical}"
    echo "Example :-"
    echo "$0 10 20"
    exit 3
fi

#Disable nagios alerts if warning and critical limits are both set to 0 (zero)
if [ $1 -eq 0 ]
then
    if [ $2 -eq 0 ]
    then
        ALERT=false
    fi
fi

#Ensure warning is greater than critical limit
if [ $1 -gt $2 ]
then
    echo "Please ensure warning is greater than critical, eg."
    echo "Usage: $0 20 40"
    exit 3
fi

#Define locale to ensure time is in 24 hour format
LC_MONETARY=en_AU.UTF-8
LC_NUMERIC=en_AU.UTF-8
LC_ALL=en_AU.UTF-8
LC_MESSAGES=en_AU.UTF-8
LC_COLLATE=en_AU.UTF-8
LANG=en_AU.UTF-8
LC_TIME=en_AU.UTF-8

#Collect sar output
SARCPU=`/usr/bin/sar -P ALL 1 1|grep all|grep -v Average|tail -1`
SARCPUIOW=`echo ${SARCPU}|awk '{print $6}'|awk -F. '{print $1}'`
CPU=`echo ${SARCPU}|awk '{print "Cpu Iowait = " $6 "% | " "CpuIowait=" $6 ";"}'`${1}";"${2}

#Display CPU Performance without alert
if [ "$ALERT" == "false" ]; then
    echo "$CPU"
    exit 0
else
    ALERT=true
fi

#Display CPU Performance with alert
if [ ${SARCPUIOW} -gt $2 ]; then
    echo "CRITICAL: $CPU"
    exit 2
elif [ $SARCPUIOW -gt $1 ]; then
    echo "WARNING: $CPU"
    exit 1
else
    echo "OK: $CPU"
    exit 0
fi
