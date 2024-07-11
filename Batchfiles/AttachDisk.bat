
@echo off


set DriveLetter=E

echo Select VDisk file="C:\VHD.vhd">attach_vhd_script.txt
echo Attach VDisk>>attach_vhd_script.txt
echo Assign letter="E">>attach_vhd_script.txt

diskpart /s attach_vhd_script.txt

del attach_vhd_script.txt

echo VHD attached and mapped to drive %DriveLetter%.
pause
