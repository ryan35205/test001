#!/bin/bash
rank=0
> /home/xiss/Testing/LS_Dyna/LS_Bench/rankfile
/cm/shared/apps/pbspro/11.2.0.113417/bin/qstat -f $PBS_JOBID |tr -d '\n'| tr -d '\t'|grep -oP '(?<=exec_host = )\S*'  |sed  's/.cm.cluster\// /g;s/ ;s/\*/\:0\,/g'|while read node slot ; do echo "rank $((rank ++))=$node slot=$slot" ;done >> /home/xiss/Testing/LS_Dyna/LS_Bench/rankfile
