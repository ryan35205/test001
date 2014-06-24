#!/bin/bash
#Set variables
rank=0
rankfile=/home/xiss/Testing/LS_Dyna/LS_Bench/rankfile
hosts=`/cm/shared/apps/pbspro/current/bin/qstat -f 5122.master | tr -d '\n' | tr -d '\t'| grep -oP '(?<=exec_host = )\S*'`

#Multi-node or Single node?
function snode () {
sed 's/.cm.cluster\// /g;s/\*/ /g'
}
function mnode () {
sed 's/.cm.cluster\// /g;s/\+/\n/g'
}

# Add the hosts/slots to rankfile
function addS0 ()
{
while read node slot ; do echo "rank $((rank ++))=$node slot=$slot";done 
}


#Empty the rankfile
> $rankfile

#Gather and parse environment data

if [[ $hosts == "*" ]]
then
        echo  $hosts|snode|SNS
else
        echo $hosts|mnode|addrank
fi

#Need to add "if snode or mnode contains 0-3 then do this elif 4-7 then do that else die"

# Add the hosts/slots to rankfile
#Singlenode rankfile
function SNS () {
while read node socket core
do
	if [[ "$socket" == [0-3] ]]
	then 
	echo "rank 0=$node slot=0:*" >> $rankfile
	else
	echo "rank 0=$node slot=1:*" >> $rankfile
	fi
done
}
#Multinode rankfile
function MNS () {
while read node core
do
	if [[ "$core" == [0-3] ]]
	then
	echo "rank $((rank ++))=$node slot=0:$core" >> $rankfile
	else
	echo "rank $((rank ++))=$node slot=1:$core" >> $rankfile
	fi
done
}
