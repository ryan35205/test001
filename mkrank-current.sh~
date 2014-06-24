#!/bin/bash
#Set variables
rank=0
rankfile=/home/xiss/Testing/LS_Dyna/LS_Bench/rankfile.`$PBS_JOBID|cut -d. -f1`
hosts=`/cm/shared/apps/pbspro/current/bin/qstat -f $PBS_JOBID | tr -d '\n' | tr -d '\t'| grep -oP '(?<=exec_host = )\S*'`

#Empty/Create the rankfile
> $rankfile || touch $rankfile

##      NEEDED FUNCTIONS ##

        # Single Node
function snode () { 
sed 's/.cm.cluster\// /g;s/\*/ /g'
}
		# Multi Node
function mnode () {
sed 's/.cm.cluster\// /g;s/\+/\n/g'
}
        #Single node rankfile
function SNS () {
while read node socket core
do
        if [[ "$socket" == [0-3] ]]
        then
        echo "rank 0=$node slot=0:*" >> $rankfile # Use Processor0
        else
        echo "rank 0=$node slot=1:*" >> $rankfile # Use Processor1
        fi
done
}
        #Multi node rankfile
function MNS () {
while read node core
do
        if [[ "$core" == [0-3] ]]
        then
        echo "rank $((rank ++))=$node slot=0:$core" >> $rankfile # Use Processor0
        else
        echo "rank $((rank ++))=$node slot=1:$core" >> $rankfile # Use Processor1
        fi
done
}


#make the rankfile

if [[ ! $hosts == "+" ]]        
then
        echo  $hosts| snode |SNS # Allocating only a single node
else            
        echo $hosts| mnode | MNS # Allocating multiple nodes

fi