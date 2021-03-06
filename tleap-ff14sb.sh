#!/bin/bash

source /cluster/apps/x86_64/packages/amber14/amber.sh

cat > tleap.in << eof
source /cluster/apps/x86_64/packages/amber14/amber14/dat/leap/cmd/leaprc.ff14SB
source /cluster/apps/x86_64/packages/amber14/amber14/dat/leap/cmd/leaprc.gaff
source /cluster/apps/x86_64/packages/amber14/amber14/dat/leap/cmd/leaprc.GLYCAM_06j-1
loadamberparams /cluster/apps/x86_64/packages/amber14/amber14/dat/leap/parm/frcmod.ionsjc_tip3p
loadamberparams /cluster/apps/x86_64/packages/amber14/amber14/dat/leap/parm/frcmod.ionslm_1264_tip3p
prot = loadPdb A24-p53-TCR_start.pdb
bond prot.102.SG prot.165.SG
bond prot.204.SG prot.260.SG
bond prot.303.SG prot.358.SG
bond prot.612.SG prot.680.SG
bond prot.545.SG prot.757.SG
bond prot.731.SG prot.796.SG
bond prot.520.SG prot.570.SG
saveAmberParm prot A24-pep-TCR.prmtop A24-pep-TCR.inpcrd
solvateoct prot TIP3PBOX 10.0
addions prot Na+ 0
addions prot Cl- 0
charge prot
saveAmberParm prot A24-pep-TCR-sol.prmtop A24-pep-TCR-sol.inpcrd
quit
eof

tleap -s -f tleap.in

ambpdb -p A24-pep-TCR-sol.prmtop < A24-pep-TCR-sol.inpcrd > A24-pep-TCR-sol.pdb
ambpdb -p A24-pep-TCR.prmtop < A24-pep-TCR.inpcrd > A24-pep-TCR.pdb
