#!/bin/bash

entry=$1
end=$2 # last residue we want the constraint to affect. It always starts from 1.
queue=$3

if [ $# -eq 0 ]; then
       	echo
	echo -e "Usage: equilibration.sh \t entry_name \t last residue in contraint"
	echo
	echo -e "\t This script writes out all the input files for amber equilibration: min.in,"
	echo -e "\t heat.in, density.in, equil.in & the corresponding files to send them to the cluster, in this case santa"
	echo
	exit 0
fi

MPI_DIR=/cluster/apps/x86_64/packages/mvapich2

#############################################################
# MINIMIZATION (Cartesian restraints for prot & nucleotide) #
# perform minimisation, no MD (imin=1)
# 1000 cycles of minimisation, 500 cycles of steepest descent, 500 cycles of conjugate gradient
# nonbonded cutoff = 9.0A
# constant volume periodic boundary (ntb=1)
# SHAKE not performed since it is an algorithm based on dynamics (ntc=1)
# print energy info every 100 steps (ntpr=100)
# restrain all protein and ligand atoms, using weight 2.0 kcal/mol
#############################################################
cat > min.in << eof_min
minimise $entry
&cntrl
  imin=1,maxcyc=1000,ncyc=500,
  cut=9.0,ntb=1,
  ntc=1,
  ntpr=100,
  ntr=1, restraintmask=':1-$end&!@H=',
  restraint_wt=2.0
/
eof_min

##############################################################
# HEATING (50 ps, Cartesian restraints for prot & nucleotide) #
# perform MD (imin=0)
# no need to restart calculation from a previous MD run (irest=0)
# coordinates read with no initial velocity info (ntx=1/2 when starting from minimised coordinates)
# perform 25000 steps of MD, timestep = 0.002 ps
# SHAKE on all bonds involving H (ntc=2)
# bond interactions involving H atoms are omitted (ntf=2, use with ntc=2)
# nonbonded cutoff= 9.0A
# periodic boundary at constant volume (ntb=1)
# print energy info every 500 steps (ntpr=500)
# print coordinate info every 500 steps (ntwx=500)
# save trajectory file in binary NetCDF format (ioutfm=1)
# temp scaling using Langevin dynamics (ntt=3), collision freq = 2/ps
# initial temp=0K, final temp=300K
# restrain all protein and ligand atoms (ntr=1)
# initiate reading in of varying conditions (nmropt=1)
###############################################################
cat > heat.in << eof_heat
heat $entry-heat
 &cntrl
  imin=0,irest=0,ntx=1,
  nstlim=25000,dt=0.002,
  ntc=2,ntf=2,
  cut=9.0, ntb=1,
  ntpr=500, ntwx=500, ioutfm=1,
  ntt=3, gamma_ln=2.0, ig=-1,iwrap=1,
  tempi=0.0, temp0=300.0,
  ntr=1, restraintmask=':1-$end',
  restraint_wt=2.0,
  nmropt=1,
 /
 &wt TYPE='TEMP0', istep1=0, istep2=25000,
  value1=0.1, value2=300.0, /
 &wt TYPE='END' /
eof_heat

##################################################
# DENSITY EQUILIBRATION (50 ps, weak restraints) #
# perform MD (imin=0)
# coordinates and velocity read formatted (ntx=5)
# restart calculation from a previous MD run (irest=1)
# perform 25000 steps of MD, timestep = 0.002 ps
# SHAKE on all bonds involving H (ntc=2)
# bond interactions involving H atoms are omitted (ntf=2, use with ntc=2)
# nonbonded cutoff= 9.0A
# periodic boundary at constant pressure (ntb=2)
# constant pressure dynamics (ntp=1), pressure relaxation time = 1 ps (taup)
# print energy info every 500 steps (ntpr=500)
# print coordinate info every 500 steps (ntwx=500)
# save trajectory file in binary NetCDF format (ioutfm=1)
# temp scaling using Langevin dynamics (ntt=3), collision freq = 2 /ps (gamma_ln)
# temp=300K
# restrain all protein and ligand atoms (ntr=1)
##################################################
cat > density.in << eof_density
heat $entry-density
 &cntrl
  imin=0,irest=1,ntx=5,
  nstlim=25000,dt=0.002,
  ntc=2,ntf=2,
  cut=9.0, ntb=2, ntp=1, taup=1.0,
  ntpr=500, ntwx=500, ioutfm=1,
  ntt=3, gamma_ln=2.0,ig=-1,iwrap=1,
  temp0=300.0,
  ntr=1, restraintmask=':1-$end',
  restraint_wt=2.0,
 /
eof_density

# generate equil.sh from ib2-amber14.qsub
sed 's/sander.mpi/equilibration/g' /home/nguyentb/AMBER_GPU/MHC_I/A2402/p53_242_251/run1/$queue-amber14.qsub | sed 's/NODES=1/NODES=1/g' | sed 's/TOTAL_CPUS=8/TOTAL_CPUS=8/g' | sed 's/#PBS -l nodes=1:ppn=8/#PBS -l nodes=1:ppn=8/g'> equil.sh 
cat >> equil.sh << eof_sh
cd $PWD
AMBERHOME=/cluster/apps/x86_64/packages/amber14/amber14
source /cluster/apps/x86_64/packages/amber14/amber14/amber.sh

$MPI_DIR/bin/mpiexec -np 8 /cluster/apps/x86_64/packages/amber14/bin/pmemd.MPI -O -i $PWD/min.in -o $PWD/min.out -p $PWD/$entry-sol.prmtop -c $PWD/$entry-sol.inpcrd -r $PWD/$entry-min.rst \
-ref $PWD/$entry-sol.inpcrd -inf $PWD/$entry-min.mdinfo

$MPI_DIR/bin/mpiexec -np 8 /cluster/apps/x86_64/packages/amber14/bin/pmemd.MPI -O -i $PWD/heat.in -o $PWD/heat.out -p $PWD/$entry-sol.prmtop -c $PWD/$entry-min.rst -r $PWD/$entry-heat.rst \
-x $PWD/heat-$entry.nc -ref $PWD/$entry-min.rst -inf $PWD/$entry-heat.mdinfo 

$MPI_DIR/bin/mpiexec -np 8 /cluster/apps/x86_64/packages/amber14/bin/pmemd.MPI -O -i $PWD/density.in -o $PWD/density.out -p $PWD/$entry-sol.prmtop -c $PWD/$entry-heat.rst -r $PWD/$entry-density.rst \
-x $PWD/density-$entry.nc -ref $PWD/$entry-heat.rst -inf $PWD/$entry-density.mdinfo 

eof_sh

cat equil.sh /home/nguyentb/AMBER_GPU/MHC_I/A2402/p53_242_251/run1/remove.job > 1
mv 1 equil.sh 

EQUIL=`qsub < equil.sh`
echo $EQUIL
exit 0
