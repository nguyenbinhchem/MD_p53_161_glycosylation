#!/bin/bash
#PBS -N equil_242_251_245S_run1
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
MACHINE_FILE=/home/nguyentb/AMBER_GPU/MHC_I/A2402/p53_242_251/O-GlcNAc/245S/run1/machine_file.$$  #### have to change
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
cd /home/nguyentb/AMBER_GPU/MHC_I/A2402/p53_242_251/O-GlcNAc/245S/run1
AMBERHOME=/cluster/apps/x86_64/packages/amber14/amber14
source /cluster/apps/x86_64/packages/amber14/amber14/amber.sh

/cluster/apps/x86_64/packages/mvapich2/bin/mpiexec -np 8 /cluster/apps/x86_64/packages/amber14/bin/pmemd.MPI -O -i min.in -o min.out -p A24-p53-242-251-sol.prmtop -c A24-p53-242-251-sol.inpcrd -r A24-p53-242-251-min.rst -ref A24-p53-242-251-sol.inpcrd -inf A24-p53-242-251-min.mdinfo

/cluster/apps/x86_64/packages/mvapich2/bin/mpiexec -np 8 /cluster/apps/x86_64/packages/amber14/bin/pmemd.MPI -O -i heat.in -o heat.out -p A24-p53-242-251-sol.prmtop -c A24-p53-242-251-min.rst -r A24-p53-242-251-heat.rst -x heat-A24-p53-242-251.nc -ref A24-p53-242-251-min.rst -inf A24-p53-242-251-heat.mdinfo 

/cluster/apps/x86_64/packages/mvapich2/bin/mpiexec -np 8 /cluster/apps/x86_64/packages/amber14/bin/pmemd.MPI -O -i density.in -o density.out -p A24-p53-242-251-sol.prmtop -c A24-p53-242-251-heat.rst -r A24-p53-242-251-density.rst -x density-A24-p53-242-251.nc -ref A24-p53-242-251-heat.rst -inf A24-p53-242-251-density.mdinfo 

/cluster/apps/x86_64/packages/mvapich2/bin/mpiexec -np 8 /cluster/apps/x86_64/packages/amber14/bin/pmemd.MPI -O -i equil.in -o equil.out -p A24-p53-242-251-sol.prmtop -c A24-p53-242-251-density.rst -r A24-p53-242-251-equil.rst -x equil-A24-p53-242-251.mdcrd -ref A24-p53-242-251-density.rst -inf A24-p53-242-251-equil.mdinfo

#-------------- Shutdown MPD processes when complete----------------#
$MPI_DIR/bin/mpdallexit
rm -f $MACHINE_FILE
