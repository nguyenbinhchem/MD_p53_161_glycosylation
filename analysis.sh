#!/bin/bash
#PBS -N ana_p53_run1
#PBS -l nodes=1:ppn=8
#PBS -j oe
#PBS -q ibqueue2
#PBS -l walltime=160:00:00

if [ ! -f $HOME/.mpd.conf ] ; then
  echo "FATAL! No $HOME/.mpd.conf"
  exit 1
fi

#-------------------- Defining the nodes and cpus ----------#
NODES=1
TOTAL_CPUS=8
MPI_DIR=/cluster/apps/x86_64/packages/mvapich2
LD_LIBRARY_PATH=/cluster/apps/x86_64/packages/mvapich2/lib
export LD_LIBRARY_PATH

#---- Parse $PBS_NODEFILE, and generate $MACHINE_FILE ---------#
MACHINE_FILE=/home/nguyentb/AMBER_GPU/MHC_I/A2402/p53_161/template_3i6l/TCR/no_glycan/run1/machine_file.$$  #### have to change
sort < $PBS_NODEFILE | uniq > $MACHINE_FILE

#--- Startup MPD, do a quick test before we proceed ---------#

$MPI_DIR/bin/mpdboot -n $NODES -f $MACHINE_FILE
if [ $? -ne 0 ] ; then
  exit 1
fi
RESULT=`$MPI_DIR/bin/mpdtrace | wc -l`
if [ "$RESULT" != "$NODES" ] ; then
  $MPI_DIR/bin/mpdallexit
  exit 1
fi

#----------------------------- start the job -----------------------#
cd /home/nguyentb/AMBER_GPU/MHC_I/A2402/p53_161/template_3i6l/TCR/no_glycan/run1/
AMBERHOME=/cluster/apps/x86_64/packages/amber14/amber14
source /cluster/apps/x86_64/packages/amber14/amber14/amber.sh

#gzip -9 prod-A24-pep-TCR.nc.gz
#gzip -9 prod1-A24-pep-TCR.nc.gz
#gzip -9 prod2-A24-pep-TCR.nc.gz
#gzip -9 prod3-A24-pep-TCR.nc.gz
#gzip -9 prod4-A24-pep-TCR.nc.gz
#gzip -9 equil-A24-pep-TCR.nc.gz
#rm prod-A24-pep-TCR-no-wat_outtraj.mdcrd.gz
#/cluster/apps/x86_64/packages/amber14/amber14/bin/cpptraj -i rmsd.ptraj 
#/cluster/apps/x86_64/packages/amber14/amber14/bin/cpptraj -i rmsf.ptraj 
/cluster/apps/x86_64/packages/amber14/amber14/bin/cpptraj -i remove_wat_mdcrd.in
#/cluster/apps/x86_64/packages/amber14/amber14/bin/cpptraj -i dist.ptraj 
#/cluster/apps/x86_64/packages/amber14/amber14/bin/cpptraj -i combine_traj.in
gzip -9 prod-A24-pep-TCR-no-wat_outtraj.mdcrd
#/cluster/apps/x86_64/packages/amber14/amber14/bin/cpptraj -i hydration.in 
#/cluster/apps/x86_64/packages/amber14/amber14/bin/cpptraj -i hbond.ptraj 
