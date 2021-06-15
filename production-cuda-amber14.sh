#!/bin/bash

entry=$1
time=$2
frames=$(($2*500000))

if [ $# -eq 0 ]; then
       	echo
	echo -e "Usage: production.sh \t entry_name \t time (in ns)"
	echo
	echo -e "\t This script writes out the input file for an amber MD simulation,"
	echo -e "\t & the corresponding file to send them to the SANTA cluster"
	echo
	exit 0
fi

#############################################################
# EQUILIBRATION (2 ns, 300K, constant pressure, shake on Hs,# 
# perform MD (imin=0_
# coordinates and velocity read formatted (ntx=5)
# restart calculation from a previous MD run (irest=1)
# perform 1,000,000 steps of MD, timestep = 0.002 ps
# SHAKE on all bonds involving H (ntc=2)
# bond interactions involving H atoms are omitted (ntf=2, use with ntc=2)
# nonbonded cutoff= 9.0A
# periodic boundary at constant pressure (ntb=2)
# constant pressure dynamics (ntp=1), pressure relaxation time = 2 ps (taup)
# print energy info every 1000 steps (ntpr=1000)
# print coordinate info every 1000 steps (ntwx=1000)
# temp scaling using Langevin dynamics (ntt=3), collision freq = 2 /ps (gamma_ln)
# temp=300K
# wrap coordinates back to box (iwrap=1)
#############################################################
cat > equil.in << eof_equil
heat $entry-equil 
 &cntrl
  imin=0,irest=1,ntx=5,
  nstlim=1000000,dt=0.002,
  ntc=2,ntf=2,
  cut=9.0, ntb=2, ntp=1, taup=2.0,
  ntpr=2500, ntwx=2500,
  ntt=3, gamma_ln=2.0,ig=-1,iwrap=1,
  temp0=300.0,
 /
eof_equil

################
# PROD.IN file #
# perform MD (imin=0)
# restart calculation from a previous MD run (irest=1)
# coordinates and velocity read formatted (ntx=5)
# timestep = 0.002 ps (dt=0.002)
# SHAKE on all bonds involving H (ntc=2)
# bond interactions involving H atoms are omitted (ntf=2, use with ntc=2)
# nonbonded cutoff= 9.0A
# periodic boundary at constant pressure (ntb=2)
# constant pressure dynamics (ntp=1), pressure relaxation time = 2 ps (taup)
# print energy info every 5000 steps to mdinfo (ntpr=5000)
# print coordinate info every 5000 steps to mdcrd (ntwx=5000)
# write restrt file every 5000 steps (ntwr=5000)
# temp scaling using Langevin dynamics (ntt=3), collision freq = 2 /ps (gamma_ln), random seed (ig=-1)
# temp=300K
# wrap coordinates back into box (iwrap=1)

# each frame is 2 fs, a snapshot is taken every 5000 frames, therefore each snapshot is 10 ps
################

cat > prod.in << eof_prod
prod $entry-$time
 &cntrl
  imin=0,irest=1,ntx=5,
  nstlim=$frames,dt=0.002,
  ntc=2,ntf=2,
  cut=9.0, ntb=2, ntp=1, taup=2.0,
  ntpr=5000, ntwx=5000,ntwr=5000,
  ntt=3, gamma_ln=2.0,ig=-1,iwrap=1,
  temp0=300.0,
 /
eof_prod

# generate prod-$entry_'$time'ns.sh from cuda.qsub
sed "s/pmemd.cuda/prod_$entry/g" /home/nguyentb/AMBER_GPU/MHC_I/A2402/p53_242_251/run1/cuda.qsub > prod-$entry'_'$time'ns.sh'
cat >> prod-$entry'_'$time'ns.sh' << EOF_prod

cd $PWD

/cluster/apps/x86_64/packages/amber14/bin/pmemd.cuda -O -i $PWD/equil.in -o $PWD/equil.out -p $PWD/$entry-sol.prmtop -c $PWD/$entry-density.rst -r $PWD/$entry-equil.rst \
-x $PWD/equil-$entry.mdcrd -ref $PWD/$entry-density.rst -inf $PWD/$entry-equil.mdinfo

/cluster/apps/x86_64/packages/amber14/bin/pmemd.cuda -O -i $PWD/prod.in -o $PWD/prod.out -p $PWD/$entry-sol.prmtop -c $PWD/$entry-equil.rst -r $PWD/$entry-prod.rst -x $PWD/prod-$entry.mdcrd -inf $PWD/$entry-prod.mdinfo
EOF_prod

cat prod-$entry'_'$time'ns.sh' /home/nguyentb/AMBER_GPU/MHC_I/A2402/p53_242_251/run1/remove.job > 1
mv 1 prod-$entry'_'$time'ns.sh' 

PROD=`qsub-ambercuda 'prod-'$entry'_'$time'ns.sh'`
echo $PROD
