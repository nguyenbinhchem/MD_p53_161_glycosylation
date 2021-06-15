cd ../run2

cp ../run1/mmpbsa.sh ./

#mkdir mmpbsa
cd mmpbsa
cp ../../run1/mmpbsa/extract_coords.mmpbsa ./
cp ../../run1/mmpbsa/ante-mmpbsa.sh ./
sed -i -e 's/run1/run2/g' ante-mmpbsa.sh 

#mkdir enthalpy DQ-pep DQ-TCR pep-TCR
cd enthalpy
cp ../../../run1/mmpbsa/enthalpy/binding_energy.mmpbsa ./
cp ../../../run1/mmpbsa/enthalpy/enthalpy-amber14.qsub ./
sed -i -e 's/run1/run2/g' enthalpy-amber14.qsub
cd ../

cd DQ-pep
cp ../../../run1/mmpbsa/DQ-pep/extract_coords.mmpbsa ./
cp ../../../run1/mmpbsa/DQ-pep/ante-mmpbsa.sh ./
sed -i -e 's/run1/run2/g' ante-mmpbsa.sh
#mkdir enthalpy bfed
cd bfed
cp ../../../../run1/mmpbsa/DQ-pep/bfed/bfed.mmpbsa ./
cp ../../../../run1/mmpbsa/DQ-pep/bfed/bfed-amber14.qsub ./
sed -i -e 's/run1/run2/g' bfed-amber14.qsub
cd ../enthalpy
cp ../../../../run1/mmpbsa/DQ-pep/enthalpy/binding_energy.mmpbsa ./
cp ../../../../run1/mmpbsa/DQ-pep/enthalpy/enthalpy-amber14.qsub ./
sed -i -e 's/run1/run2/g' enthalpy-amber14.qsub

cd ../../DQ-TCR
cp ../../../run1/mmpbsa/DQ-TCR/extract_coords.mmpbsa ./
cp ../../../run1/mmpbsa/DQ-TCR/ante-mmpbsa.sh ./
sed -i -e 's/run1/run2/g' ante-mmpbsa.sh
#mkdir enthalpy bfed
cd bfed
cp ../../../../run1/mmpbsa/DQ-TCR/bfed/bfed.mmpbsa ./
cp ../../../../run1/mmpbsa/DQ-TCR/bfed/bfed-amber14.qsub ./
sed -i -e 's/run1/run2/g' bfed-amber14.qsub
cd ../enthalpy
cp ../../../../run1/mmpbsa/DQ-TCR/enthalpy/binding_energy.mmpbsa ./
cp ../../../../run1/mmpbsa/DQ-TCR/enthalpy/enthalpy-amber14.qsub ./
sed -i -e 's/run1/run2/g' enthalpy-amber14.qsub

cd ../../pep-TCR
cp ../../../run1/mmpbsa/pep-TCR/extract_coords.mmpbsa ./
cp ../../../run1/mmpbsa/pep-TCR/ante-mmpbsa.sh ./
sed -i -e 's/run1/run2/g' ante-mmpbsa.sh
#mkdir enthalpy bfed
cd bfed
cp ../../../../run1/mmpbsa/pep-TCR/bfed/bfed.mmpbsa ./
cp ../../../../run1/mmpbsa/pep-TCR/bfed/bfed-amber14.qsub ./
sed -i -e 's/run1/run2/g' bfed-amber14.qsub
cd ../enthalpy
cp ../../../../run1/mmpbsa/pep-TCR/enthalpy/binding_energy.mmpbsa ./
cp ../../../../run1/mmpbsa/pep-TCR/enthalpy/enthalpy-amber14.qsub ./
sed -i -e 's/run1/run2/g' enthalpy-amber14.qsub

cd  ../../../../run3

cp ../run1/mmpbsa.sh ./

#mkdir mmpbsa
cd mmpbsa
cp ../../run1/mmpbsa/extract_coords.mmpbsa ./
cp ../../run1/mmpbsa/ante-mmpbsa.sh ./
sed -i -e 's/run1/run3/g' ante-mmpbsa.sh 

#mkdir enthalpy DQ-pep DQ-TCR pep-TCR
cd enthalpy
cp ../../../run1/mmpbsa/enthalpy/binding_energy.mmpbsa ./
cp ../../../run1/mmpbsa/enthalpy/enthalpy-amber14.qsub ./
sed -i -e 's/run1/run3/g' enthalpy-amber14.qsub
cd ../

cd DQ-pep
cp ../../../run1/mmpbsa/DQ-pep/extract_coords.mmpbsa ./
cp ../../../run1/mmpbsa/DQ-pep/ante-mmpbsa.sh ./
sed -i -e 's/run1/run3/g' ante-mmpbsa.sh
#mkdir enthalpy bfed
cd bfed
cp ../../../../run1/mmpbsa/DQ-pep/bfed/bfed.mmpbsa ./
cp ../../../../run1/mmpbsa/DQ-pep/bfed/bfed-amber14.qsub ./
sed -i -e 's/run1/run3/g' bfed-amber14.qsub
cd ../enthalpy
cp ../../../../run1/mmpbsa/DQ-pep/enthalpy/binding_energy.mmpbsa ./
cp ../../../../run1/mmpbsa/DQ-pep/enthalpy/enthalpy-amber14.qsub ./
sed -i -e 's/run1/run3/g' enthalpy-amber14.qsub

cd ../../DQ-TCR
cp ../../../run1/mmpbsa/DQ-TCR/extract_coords.mmpbsa ./
cp ../../../run1/mmpbsa/DQ-TCR/ante-mmpbsa.sh ./
sed -i -e 's/run1/run3/g' ante-mmpbsa.sh
#mkdir enthalpy bfed
cd bfed
cp ../../../../run1/mmpbsa/DQ-TCR/bfed/bfed.mmpbsa ./
cp ../../../../run1/mmpbsa/DQ-TCR/bfed/bfed-amber14.qsub ./
sed -i -e 's/run1/run3/g' bfed-amber14.qsub
cd ../enthalpy
cp ../../../../run1/mmpbsa/DQ-TCR/enthalpy/binding_energy.mmpbsa ./
cp ../../../../run1/mmpbsa/DQ-TCR/enthalpy/enthalpy-amber14.qsub ./
sed -i -e 's/run1/run3/g' enthalpy-amber14.qsub

cd ../../pep-TCR
cp ../../../run1/mmpbsa/pep-TCR/extract_coords.mmpbsa ./
cp ../../../run1/mmpbsa/pep-TCR/ante-mmpbsa.sh ./
sed -i -e 's/run1/run3/g' ante-mmpbsa.sh
#mkdir enthalpy bfed
cd bfed
cp ../../../../run1/mmpbsa/pep-TCR/bfed/bfed.mmpbsa ./
cp ../../../../run1/mmpbsa/pep-TCR/bfed/bfed-amber14.qsub ./
sed -i -e 's/run1/run3/g' bfed-amber14.qsub
cd ../enthalpy
cp ../../../../run1/mmpbsa/pep-TCR/enthalpy/binding_energy.mmpbsa ./
cp ../../../../run1/mmpbsa/pep-TCR/enthalpy/enthalpy-amber14.qsub ./
sed -i -e 's/run1/run3/g' enthalpy-amber14.qsub
