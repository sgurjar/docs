# Embedding Python script in Windows Batch file #

```Batchfile
@echo off
REM = """
c:\my\path\to\python.exe -x %~f0 %*
goto :eof
"""
#==========================
# python script starts here
#==========================
import sys

print sys.argv
```
