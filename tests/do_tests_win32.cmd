:: this compiles and runs the test suite under Visual Studio 2008
::@echo off
if defined VS90COMNTOOLS (
   call "%VS90COMNTOOLS%\vsvars32.bat" > vc.out 
) ELSE ( 
  if defined VS100COMNTOOLS (
      call "%VS100COMNTOOLS%\vsvars32.bat" > vc.out
  )
)

mkdir obj
mkdir bin
del /s /y obj\*
del /s /y bin\*
set "COMPILE=cl.exe /I ..\src /EHsc /Zi /nologo /Foobj\ /Febin\ /Fdbin\"
echo compiling...
%COMPILE% tdiff.cpp > compile.out
::for %%f in (test*.c) do %COMPILE% /Tp %%f >> compile.out
for %%f in (test*.c) do (
  %COMPILE% /Tc %%f > compile.out
  if ERRORLEVEL 1 (
   type compile.out
   goto error
  )
)
echo running tests...
for %%f in (bin\test*.exe) do (
  %%f > bin\%%~nf.out  
  if ERRORLEVEL 1 goto error
  bin\tdiff bin\%%~nf.out %%~nf.ans
  if ERRORLEVEL 1 goto error
)
echo tests completed
::for %%f in (test*.out test*.obj test*.exe vc.out compile.out tdiff.obj tdiff.exe) do del %%f
::pause
goto end

:error
echo "error" %errorlevel%
:end
