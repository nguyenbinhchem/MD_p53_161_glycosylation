#!/bin/bash
#PBS -N prod_A24-p53-242-251_run1
#PBS -j oe
#PBS -q cuda
#PBS -l walltime=400:00:00

if [ ! -f $HOME/.mpd.conf ] ; then
  echo "FATAL! No $HOME/.mpd.conf"
  exit 1
fi

###### preamble starts #######
# determine GPU number by doing a simple mem_test 
NUM_DEVICE=`/usr/bin/nvidia-smi -L | wc -l`
 

for I in `seq 0 $((NUM_DEVICE - 1))` 
do
/cluster/apps/x86_64/packages/utils/cuda_memtest --disable_all --enable_test 0 --num_passes 1 --device $I > /dev/null 2>/dev/null
if [ "$?" -eq "0" ]; then
GPU_NUM=$I
export CUDA_VISIBLE_DEVICES="$I"
break
fi
done
# $GPU_NUM is now "--device $I", dont change value of $GPU_NUM as inputs to cuda-fied binaries unless you know what you are doing !!!
##### preamble ends ########


sleep 1
source /cluster/apps/x86_64/packages/modules-tcl/init/bash
module load amber16
module load cuda8.0

cd /home/nguyentb/AMBER_GPU/MHC_I/A2402/p53_242_251/O-GlcNAc/WT/run1

/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i min.in -o min.out -p A24-p53-242-251-sol.prmtop -c A24-p53-242-251-sol.inpcrd -r A24-p53-242-251-min.rst -ref A24-p53-242-251-sol.inpcrd -inf A24-p53-242-251-min.mdinfo
/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i heat.in -o heat.out -p A24-p53-242-251-sol.prmtop -c A24-p53-242-251-min.rst -r A24-p53-242-251-heat.rst -x heat-A24-p53-242-251.nc -ref A24-p53-242-251-min.rst -inf A24-p53-242-251-heat.mdinfo 
/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i density.in -o density.out -p A24-p53-242-251-sol.prmtop -c A24-p53-242-251-heat.rst -r A24-p53-242-251-density.rst -x density-A24-p53-242-251.nc -ref A24-p53-242-251-heat.rst -inf A24-p53-242-251-density.mdinfo 
/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i equil.in -o equil.out -p A24-p53-242-251-sol.prmtop -c A24-p53-242-251-density.rst -r A24-p53-242-251-equil.rst -x equil-A24-p53-242-251.nc -ref A24-p53-242-251-density.rst -inf A24-p53-242-251-equil.mdinfo
/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i prod.in -o prod.out -p A24-p53-242-251-sol.prmtop -c A24-p53-242-251-equil.rst -r A24-p53-242-251-prod.rst -x prod-A24-p53-242-251.nc -inf A24-p53-242-251-prod.mdinfo
/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i prod.in -o prod1.out -p A24-p53-242-251-sol.prmtop -c A24-p53-242-251-prod.rst -r A24-p53-242-251-prod1.rst -x prod1-A24-p53-242-251.nc -inf A24-p53-242-251-prod1.mdinfo
/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i prod.in -o prod2.out -p A24-p53-242-251-sol.prmtop -c A24-p53-242-251-prod1.rst -r A24-p53-242-251-prod2.rst -x prod2-A24-p53-242-251.nc -inf A24-p53-242-251-prod2.mdinfo
/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i prod.in -o prod3.out -p A24-p53-242-251-sol.prmtop -c A24-p53-242-251-prod2.rst -r A24-p53-242-251-prod3.rst -x prod3-A24-p53-242-251.nc -inf A24-p53-242-251-prod3.mdinfo
/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i prod.in -o prod4.out -p A24-p53-242-251-sol.prmtop -c A24-p53-242-251-prod3.rst -r A24-p53-242-251-prod4.rst -x prod4-A24-p53-242-251.nc -inf A24-p53-242-251-prod4.mdinfo

#-------------- Shutdown MPD processes when complete----------------#
$MPI_DIR/bin/mpdallexit
rm -f $MACHINE_FILE
