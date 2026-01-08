del sample.bas
del sprites.bin

Get-Content .\src\sample.bas | python.exe number.py | Out-File sample.bas -Encoding ascii
cd .\sprites
.\update2.bat

cd ..

python.exe fnxmgr.zip --copy sprites.bin
python.exe fnxmgr.zip --binary sample.bas --address 28000
