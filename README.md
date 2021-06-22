# MD_p53_161_glycosylation
MD script

The MD was run with the following command

/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i min.in -o min.out -p A24-p53-sol.prmtop -c A24-p53-sol.inpcrd -r A24-p53-min.rst -ref A24-p53-sol.inpcrd -inf A24-p53-min.mdinfo

/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i heat.in -o heat.out -p A24-p53-sol.prmtop -c A24-p53-min.rst -r A24-p53-heat.rst -x heat-A24-p53.nc -ref A24-p53-min.rst -inf A24-p53-heat.mdinfo 

/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i density.in -o density.out -p A24-p53-sol.prmtop -c A24-p53-heat.rst -r A24-p53-density.rst -x density-A24-p53.nc -ref A24-p53-heat.rst -inf A24-p53-density.mdinfo 

/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i equil.in -o equil.out -p A24-p53-sol.prmtop -c A24-p53-density.rst -r A24-p53-equil.rst -x equil-A24-p53.nc -ref A24-p53-density.rst -inf A24-p53-equil.mdinfo

/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i prod.in -o prod.out -p A24-p53-sol.prmtop -c A24-p53-equil.rst -r A24-p53-prod.rst -x prod-A24-p53.nc -inf A24-p53-prod.mdinfo

/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i prod.in -o prod1.out -p A24-p53-sol.prmtop -c A24-p53-prod.rst -r A24-p53-prod1.rst -x prod1-A24-p53.nc -inf A24-p53-prod1.mdinfo

/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i prod.in -o prod2.out -p A24-p53-sol.prmtop -c A24-p53-prod1.rst -r A24-p53-prod2.rst -x prod2-A24-p53.nc -inf A24-p53-prod2.mdinfo

/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i prod.in -o prod3.out -p A24-p53-sol.prmtop -c A24-p53-prod2.rst -r A24-p53-prod3.rst -x prod3-A24-p53.nc -inf A24-p53-prod3.mdinfo

/cluster/apps/x86_64/packages/amber16/bin/pmemd.cuda -O -i prod.in -o prod4.out -p A24-p53-sol.prmtop -c A24-p53-prod3.rst -r A24-p53-prod4.rst -x prod4-A24-p53.nc -inf A24-p53-prod4.mdinfo


