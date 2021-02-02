setlocal EnableDelayedExpansion

REM PSAppDeployPath
REM    The folder that contains the PSAppDeployToolkit. Default: "%~dp0\PSAppDeployToolkit"
REM
set "PSAppDeployPath=%~dp0\PSAppDeployToolkit"

REM SEVENZPath
REM    The folder that contains the 7-Zip (7za.exe) executable. Default: "%ProgramFiles%\7-Zip"
REM    You can download any versions of 7-Zip (including latest beta versions) from: https://www.7-zip.org/download.html
REM
REM set SEVENZPath=

REM SEVENZSFXPath
REM    The folder that contains the SFX module for installers (7zSD.sfx) file. Default: "%~dp0\7zSD.sfx"
REM    Acquiring the 7zSD.sfx stuffs is easy: The installers are on the official download page. Just look for keyword 7-Zip Extra. Version 9.20 for example is https://www.7-zip.org/a/7z920_extra.7z
REM
REM set SEVENZSFXPath=

REM
REM
REM DO NOT EDIT BELOW
REM
REM

if NOT [%1]==[] set InvokedFrom=%1
if NOT defined InvokedFrom set "InvokedFrom=%__CD__:~,-1%"
set InvokedFrom=%InvokedFrom:"=%
if %InvokedFrom:~-1%==\ SET InvokedFrom=%InvokedFrom:~0,-1%

pushd "%InvokedFrom%"
for %%i in ("%InvokedFrom%") do set "InvokedFromShort=%%~si"

if NOT exist "%PSAppDeployPath%" echo.ERROR: PSAppDeployToolkit directory could not be found at %PSAppDeployPath%. && exit /b 1

call :uniqGet uniqueFile1 "%temp%"

goto :continueScript
@rem get unique file name
@rem usage: call :uniqGet VariableName folder
@rem parameter #1=variable name where the filename save to
@rem parameter #2=folder where the file should be about
rem https://stackoverflow.com/questions/32107998/how-to-create-a-unique-temporary-file-path-in-command-prompt-without-external-to 
:uniqGet
@rem in the next line (optional): create the "%~2" folder if does not exist 
md "%~2" 2>NUL
set "_uniqueFileName=%~2\bat~%RANDOM%"
if exist "%_uniqueFileName%" goto :uniqGet
set "%~1=%_uniqueFileName%"
@rem want to create empty file? remove the `@rem` word from next line 
@rem type nul > "%_uniqueFileName%"
exit /B

:RenameFile
@CHCP 65001 >NUL

set "FileName=%~2"
set "FileName=%FileName:Š=S%"
set "FileName=%FileName:Ž=Z%"
set "FileName=%FileName:š=s%"
set "FileName=%FileName:ž=z%"
set "FileName=%FileName:Ÿ=Y%"
set "FileName=%FileName:À=A%"
set "FileName=%FileName:Á=A%"
set "FileName=%FileName:Â=A%"
set "FileName=%FileName:Ã=A%"
set "FileName=%FileName:Ä=A%"
set "FileName=%FileName:Å=A%"
set "FileName=%FileName:Ç=c%"
set "FileName=%FileName:È=E%"
set "FileName=%FileName:É=E%"
set "FileName=%FileName:Ê=E%"
set "FileName=%FileName:Ë=E%"
set "FileName=%FileName:Ì=I%"
set "FileName=%FileName:Í=I%"
set "FileName=%FileName:Î=I%"
set "FileName=%FileName:Ï=I%"
set "FileName=%FileName:Ñ=N%"
set "FileName=%FileName:Ò=O%"
set "FileName=%FileName:Ó=O%"
set "FileName=%FileName:Ô=O%"
set "FileName=%FileName:Õ=O%"
set "FileName=%FileName:Ö=O%"
set "FileName=%FileName:Ù=U%"
set "FileName=%FileName:Ú=U%"
set "FileName=%FileName:Û=U%"
set "FileName=%FileName:Ü=U%"
set "FileName=%FileName:Ý=Y%"
set "FileName=%FileName:à=a%"
set "FileName=%FileName:á=a%"
set "FileName=%FileName:â=a%"
set "FileName=%FileName:ã=a%"
set "FileName=%FileName:ä=a%"
set "FileName=%FileName:å=a%"
set "FileName=%FileName:ç=c%"
set "FileName=%FileName:è=e%"
set "FileName=%FileName:é=e%"
set "FileName=%FileName:ê=e%"
set "FileName=%FileName:ë=e%"
set "FileName=%FileName:ì=i%"
set "FileName=%FileName:í=i%"
set "FileName=%FileName:î=i%"
set "FileName=%FileName:ï=i%"
set "FileName=%FileName:ñ=n%"
set "FileName=%FileName:ò=o%"
set "FileName=%FileName:ó=o%"
set "FileName=%FileName:ô=o%"
set "FileName=%FileName:õ=o%"
set "FileName=%FileName:ö=o%"
set "FileName=%FileName:ù=u%"
set "FileName=%FileName:ú=u%"
set "FileName=%FileName:û=u%"
set "FileName=%FileName:ü=u%"
set "FileName=%FileName:ý=y%"
set "FileName=%FileName:ÿ=y%"

set "%~1=%FileName%"

exit /b

:continueScript

if NOT defined SEVENZSFXPath (
	for %%D in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
		if exist "%%D:\PortableApps\7-ZipPortable\App\7-Zip\7zSD.fx" (
			set SEVENZSFXPath=%%D:\PortableApps\7-ZipPortable\App\7-Zip
		)
	)
)

if NOT defined SEVENZSFXPath set SEVENZSFXPath=%__CD__:~,-1%
set countbackslash=0
for %%a in (%SEVENZSFXPath:\= %) do set /a countbackslash+=1

:SEVENZSFXLoop
if not exist "%SEVENZSFXPath%\7-Zip\7zSD.sfx" set "SEVENZSFXPath=%SEVENZSFXPath%\.."
if %countbackslash% GTR 0 set /a countbackslash-=1 & goto :SEVENZSFXLoop

if exist "%SEVENZSFXPath%\7-Zip\7zSD.sfx" set "SEVENZSFXPath=%SEVENZSFXPath%\7-Zip"

if NOT exist "%SEVENZSFXPath%\7zSD.sfx" echo.ERROR: 7zSD.sfx file could not be found into your system. && exit /b 2

if NOT defined SEVENZPath for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Software\7-Zip" /v Path 2^>^&1^|find "REG_"') do @set SEVENZPath=%%b
if NOT defined SEVENZPath for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Software\7-Zip" /v Path64 2^>^&1^|find "REG_"') do @set SEVENZPath=%%b
if NOT defined SEVENZPath for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\Software\7-Zip" /v Path 2^>^&1^|find "REG_"') do @set SEVENZPath=%%b
if NOT defined SEVENZPath for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\Software\7-Zip" /v Path64 2^>^&1^|find "REG_"') do @set SEVENZPath=%%b
if NOT defined if exist "%SEVENZPath%" @set "SEVENZPath=%ProgramFiles(x86)%\7-Zip"
if NOT defined if exist "%SEVENZPath%" @set "SEVENZPath=%ProgramFiles%\7-Zip"
if NOT defined if NOT exist "%SEVENZPath%" (
	for %%D in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
		if exist "%%D:\PortableApps\7-ZipPortable\App\7-Zip" (
			set SEVENZPath=%%D:\PortableApps\7-ZipPortable\App\7-Zip
		)
	)
)

if NOT defined SEVENZPath set SEVENZPath=%__CD__:~,-1%
set countbackslash=0
for %%a in (%SEVENZPath:\= %) do set /a countbackslash+=1

:SEVENZLoop
if not exist "%SEVENZPath%\7z.exe" set "SEVENZPath=%SEVENZPath%\.."
if %countbackslash% GTR 0 set /a countbackslash-=1 & goto :SEVENZLoop

if exist "%SEVENZPath%\PortableApps\7-ZipPortable\App\7-Zip" set "SEVENZPath=%SEVENZPath%\PortableApps\7-ZipPortable\App\7-Zip"

if NOT exist "%SEVENZPath%" echo.ERROR: 7-Zip could not be found into your system. && popd & exit /b 3
IF %SEVENZPath:~-1%==\ SET SEVENZPath=%SEVENZPath:~0,-1%

mkdir "%uniqueFile1%"
xcopy /cheriky "%PSAppDeployPath%\Toolkit" "%uniqueFile1%"

for %%i in (%InvokedFrom%) do call :ToLowercaseWithFor "%%~nxi" AppPathName
call :RenameFile AppPathName %AppPathName%
echo %AppPathName%

REM cd /d "%uniqueFile1%"
call :uniqGet uniqueFile2 "%temp%"
type NUL > "%uniqueFile2%.tmp"
for /f delims^=^"^ tokens^=1^,3 %%A in (%InvokedFromShort%\sfx_listfile.txt) do (
	REM %%A = "7z1900.msi"
	REM %%B = "Files/7z1900.msi"
	
	REM If %%A is an absolute path
	if exist "%%~A" (
		echo copy /y "%%~A" "%uniqueFile1%\%%~B" >> "%uniqueFile2%.tmp"
	) else (
		echo copy /y "%InvokedFrom%\%%~A" "%uniqueFile1%\%%~B" >> "%uniqueFile2%.tmp"
	)
)
REM execute batch file created above
type "%uniqueFile2%.tmp"|cmd

if exist "%InvokedFrom%\%AppPathName%.7z" del /q /f "%InvokedFrom%\%AppPathName%.7z"
REM "%SEVENZPath%\7z.exe" a -r "%InvokedFrom%\%AppPathName%.7z" *.* -i@"%uniqueFile3%.tmp"
"%SEVENZPath%\7z.exe" a -r "%InvokedFrom%\%AppPathName%.7z" "%uniqueFile1%\*.*"
set SEVENZSFXConfigPath=%InvokedFrom%
if NOT exist "%SEVENZSFXConfigPath%\sfx_config.txt" set SEVENZSFXConfigPath=%~dp0
if NOT exist "%SEVENZSFXConfigPath%\sfx_config.txt" echo.7-Zip SFX config file (sfx_config.txt) file could not be found into your system. && exit /b 4

copy /b "%SEVENZSFXPath%\7zSD.sfx" + "%SEVENZSFXConfigPath%\sfx_config.txt" + "%InvokedFrom%\%AppPathName%.7z" "%InvokedFrom%\%AppPathName%_sfx_setup.exe"
popd

rd "%uniqueFile1%" /s /q
del /f "%uniqueFile2%.tmp"
REM del /f "%uniqueFile3%.tmp"

goto :EOF

:ToLowercaseWithFor
setlocal EnableExtensions EnableDelayedExpansion
  set var_=%~1
  for %%c in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do (
    set var_=!var_:%%c=%%c!
  )
endlocal & set %2=%var_%& goto :EOF

:EOF
