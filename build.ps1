del sample.bas
del sprites.bin

Get-Content .\src\sample.bas | python.exe number.py | Out-File sample.bas -Encoding ascii
cd .\sprites
.\update2.bat

cd ..

python.exe fnxmgr.zip --port COM110 --copy sprites.bin
python.exe fnxmgr.zip --port COM10 --binary sample.bas --address 28000
