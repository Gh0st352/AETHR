:: Create .lua file list
dir *.lua /b>dofiles.txt
 
:: Clear dofiles.lua
break>dofiles.lua
 

set mypath=%cd%
set mypath=%mypath:\=\\%

:: Generate dofiles.lua
for /F "tokens=*" %%A in (dofiles.txt) do echo dofile("%mypath%\\%%A")>>dofiles.lua
 
:: Delete dofiles.txt
del dofiles.txt