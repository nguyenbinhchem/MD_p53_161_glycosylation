
cd ./mmpbsa
rm snapshot*
j_id=`qsub ante-mmpbsa.sh`
sleep 0.2
cd ./enthalpy
mkdir backup
mv snapshot* ./backup
qsub -W depend=afterany:$j_id enthalpy-amber14.qsub

cd ../DQ-pep
j_id1=`qsub ante-mmpbsa.sh`
cd ./enthalpy
mkdir backup
mv snapshot* ./backup
qsub -W depend=afterany:$j_id1 enthalpy-amber14.qsub
cd ../bfed
mkdir backup
mv snapshot* ./backup
qsub -W depend=afterany:$j_id1 bfed-amber14.qsub

cd ../../DQ-TCR
j_id2=`qsub ante-mmpbsa.sh`
cd ./enthalpy
mkdir backup
mv snapshot* ./backup
qsub -W depend=afterany:$j_id2 enthalpy-amber14.qsub
cd ../bfed
mkdir backup
mv snapshot* ./backup
qsub -W depend=afterany:$j_id2 bfed-amber14.qsub

cd ../../pep-TCR
j_id3=`qsub ante-mmpbsa.sh`
cd ./enthalpy
mkdir backup
mv snapshot* ./backup
qsub -W depend=afterany:$j_id3 enthalpy-amber14.qsub
cd ../bfed
mkdir backup
mv snapshot* ./backup
qsub -W depend=afterany:$j_id3 bfed-amber14.qsub
