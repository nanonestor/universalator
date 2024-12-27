@ECHO OFF

REM    The Universalator - Modded Minecraft Server Installation / Launching Program.
REM    Copyright (C) <2023>  <Kerry Sherwin>
REM
REM    This program is free software: you can redistribute it and/or modify
REM    it under the terms of the GNU General Public License as published by
REM    the Free Software Foundation, either version 3 of the License, or
REM    (at your option) any later version.
REM
REM    This program is distributed in the hope that it will be useful,
REM    but WITHOUT ANY WARRANTY; without even the implied warranty of
REM    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM    GNU General Public License for more details.
REM
REM    You should have received a copy of the GNU General Public License
REM    along with this program.  If not, see https://www.gnu.org/licenses/.




:: README BELOW -- NOTES -- README -- NOTES
:: ----------------------------------------------
:: INSTRUCTIONS FOR UNIVERSALATOR - MODDED MINECRAFT SERVER INSTALLER / LAUNCHER
:: ----------------------------------------------
  :: -TO USE THIS FILE:
  ::    CREATE A NEW FOLDER SUCH AS (example) C:\MYSERVER
  ::    IN THAT FOLDER PLACE THIS BAT FILE, THE MODS FOLDER AND ANY OTHER SPECIAL FOLDERS/FILES FROM AN EXISTING MODPACK OR CUSTOM PROFILE OR SERVER.
  ::    RUN THIS BAT FILE - EXECUTE NORMALLY, DO NOT RUN AS ADMIN
  ::
  :: 
  :: -TO CREATE A SERVER PACK
  ::    USE THE ZIP MENU FROM WITHIN THE SCRIPT PROGRAM FOR A GUIDE TO CREATING A ZIP FILE CONTAINING NECESSARY FILES
::
:: ------------------------------------------------
:: README ABOVE -- NOTES -- README -- NOTES










:: DO NOT EDIT INFORMATION BELOW - SCRIPT FILE (WILL PROBABLY) BREAK

:: DO NOT EDIT INFORMATION BELOW - SCRIPT FILE (WILL PROBABLY) BREAK

:: DO NOT EDIT INFORMATION BELOW - SCRIPT FILE (WILL PROBABLY) BREAK

















ECHO: & ECHO: & ECHO   Loading ... ... ...

:: BEGIN GENERAL PRE-RUN ITEMS
setlocal enabledelayedexpansion
:: Sets the current directory as the working directory - this should fix attempts to run the script as admin.
PUSHD "%~dp0" >nul 2>&1

:: Gets the version number of the filename of this bat file.
SET "UNIV_VERSION=%~n0"
SET "UNIV_VERSION=%UNIV_VERSION:Universalator-=%"
:: If any a-z are found at this point, user has changed the file name - set the version number variable empty to avoid awkward titles.
ECHO %UNIV_VERSION% | FINDSTR "[a-z] [A-Z]" >nul && SET "UNIV_VERSION="

:: Sets the title and backgound color of the command window
TITLE Universalator %UNIV_VERSION%
color 1E
prompt [universalator]:
::  The defaut JVM arguments that will print out for use in the settings file that gets created.  Users can edit this settings file to edit their JVM arguments to be used for launching.
SET "ARGS=-XX:+UseG1GC -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M"

:: Additional JVM arguments that will always be applied
SET "OTHERARGS=-XX:+IgnoreUnrecognizedVMOptions -XX:+AlwaysActAsServerClassMachine -Dlog4j2.formatMsgNoLookups=true"
:: These variables set to exist as blank in case windows is older than 10 and they aren't assigned otherwise
SET "yellow="
SET "blue="
:: Sets a HERE variable equal to the current directory string.
SET "HERE=%cd%"
:: Makes a powershell specific HERE location, installing backquotes before single quotes - to prevent powershell functions breaking.
SET "HEREPOWERSHELL=%HERE:'=`'%"
:: Sets a variable to the tab character for later use
SET "TABCHAR=	"

SET "DELAY=ping -n 2 127.0.0.1 >nul"

:: TEST LINES FOR WINDOW RESIZING - KIND OF SCREWEY NEEDS FURTHER CHECKS
::mode con: cols=160 lines=55
::powershell -command "&{$H=get-host;$W=$H.ui.rawui;$B=$W.buffersize;$B.width=160;$B.height=9999;$W.buffersize=$B;}

:: WINDOWS VERSION CHECK
:: Versions equal to or older than Windows 8 (internal version number 6.2) will stop the script with warning.
FOR /F "tokens=4-7 delims=[.] " %%i IN ('ver') DO ( IF /I %%i==Version (
    set winmajor=%%j
    set winminor=%%k 
    ) else (
    set winmajor=%%i
    set winminor=%%j
    ))
:: If Windows is older than 10 tells user the sad news that they are not supported.
:: If Windows is greater than or equal to version 10 then set some variables to set console output colors!  Then skip OS warning.
IF %winmajor% LEQ 9 (
    ECHO: & ECHO: & ECHO:
    ECHO   YOUR WINDOWS VERSION IS OLD ENOUGH TO NOT BE SUPPORTED & ECHO:
    ECHO   UPDATING TO WINDOWS 10 OR GREATER IS HIGHLY RECOMMENDED
    ECHO:
    PAUSE & EXIT [\B]
)
:: Sets font colors as handy variables
IF %winmajor% GEQ 10 (
  SET yellow=[34;103m
  SET blue=[93;44m
  SET cyan=[34;106m
  SET green=[93;42m
  SET red=[93;101m
)
:: Gets the license txt file from the Universalator github website if not present yet.  This is primarily done as a test to see if any aggressive antivirus programs or system permissions are not allowing downloaded files to keep.
:: Later on it will be tested to see if it still exists - do other tests in the meantime so that it gives other programs and the OS some time.  Tests for powershell existing first, since the checking of that is handled later.
IF NOT EXIST "%HERE%\univ-utils\license.txt" WHERE powershell >nul && MD univ-utils >nul 2>&1 & powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/nanonestor/universalator/main/LICENSE', 'univ-utils/license.txt')" >nul && SET GOTLICENSE=Y

:: Checks the last character of the folder name the script was run from.  If that last character is found in a FINDSTR to not contain an a-z, A-Z, or 0-9 character then prompt user to change the folder name or move the server files and pause/exit.
:: Handling the character needs to be done carefully because it will be null in some cases without character escaping ^ or echo without entering variables as string.  Special characters at the end of the working folder breaks certain CMD commands.
SET "LASTCHAR=%cd:~-1%"
ECHO ^%LASTCHAR% | FINDSTR "[a-z] [A-Z] [0-9]" >nul || (
  CLS
  ECHO. & ECHO. & ECHO. & ECHO   %yellow% PROBLEM DETECTED %blue% & ECHO. & ECHO      %red% %cd% %blue% & ECHO. & ECHO      THE ABOVE FOLDER LOCATION ENDS IN A SPECIAL CHARACTER - %red% ^!LASTCHAR! %blue% & ECHO:
  ECHO      REMOVE THIS SPECIAL CHARACTER FROM THE END OF OF THE FOLDER NAME OR USE A DIFFERENT FOLDER & ECHO: & ECHO: & ECHO:
  ECHO        ** SPECIAL CHARACTERS AT THE END OF FOLDER NAMES BREAKS CERTAIN COMMAND FUNCTIONS THE SCRIPT USES
  ECHO: & ECHO: & ECHO: & ECHO: & ECHO: & ECHO: & ECHO:
  PAUSE & EXIT [\B]
)

:: Checks to see if an exclamation mark is found anywhere in the folder path, which breaks many commands in the script.  Disabling delayed expansion could be done to detect it a different way.
FOR /F "delims=" %%A IN ('powershell -Command "ECHO (get-location).path | FINDSTR "^^!""') DO SET IS_EXCL_FOUND=%%A
IF DEFINED IS_EXCL_FOUND IF "%CD%"=="!IS_EXCL_FOUND!" (
    setlocal disabledelayedexpansion
    ECHO. & ECHO. & ECHO. & ECHO   %yellow% PROBLEM DETECTED %blue% & ECHO. & ECHO   %red% %cd% %blue% & ECHO. & ECHO   THE ABOVE FOLDER PATH CONTAINS AN EXCLAMATION MARK CHARACTER  - %red% ^! %blue% & ECHO.
    ECHO   INCLUDING THIS CHARACTER IN FOLDER NAMES CAN BREAK THE FUNCTIONS IN THE PROGRAM. & ECHO   CHANGE FOLDER NAMES TO REMOVE THE EXCLAMATION MARK %red% ^! %blue% & ECHO: & ECHO: & ECHO:
    PAUSE & EXIT [/B]
    setlocal enabledelayedexpansion
)

:: Checks to see if there are environmental variables trying to set global ram allocation values!  This is a real thing!

FOR %%X IN (_JAVA_OPTIONS JDK_JAVA_OPTIONS JAVA_TOOL_OPTIONS) DO (
  REM Doing this with ver and silencing the output always resets the current errorlevel to 0
  ver >nul

  REM If the environment variable in this loop exists then search if it has an xmx or xmn term, and if it does report it to the user.
  IF DEFINED %%X (
    ECHO %%X | FINDSTR /i "xmx xmn" 1>NUL

    REM If errorlevel is 0 then the findstr succeeded and it found xmx or xmn in the environment variable being searched.
    IF !ERRORLEVEL!==0 (
    ECHO:
    ECHO  %yellow% WARNING - IT WAS DETECTED THAT YOU HAVE THE WINDOWS ENVIRONMENTAL VARIABLE %blue%
    ECHO  %yellow% NAMED %blue% %%X %yellow% SETTING GLOBAL RAM MEMORY VALUES SUCH AS -Xmx or -Xmn %blue%
    ECHO:
    ECHO  %yellow% PLEASE REMOVE THIS VALUE FROM THE VARIABLE SO THAT YOUR SERVER WILL LAUNCH CORRECTLY! %blue%
    ECHO:
    ECHO  IF YOU DON'T KNOW HOW - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
    ECHO  https://github.com/nanonestor/universalator/wiki
    ECHO:
    PAUSE & EXIT [\B]
    )
  )

)

:: The below SET PATH only applies to this command window launch and isn't permanent to the system's PATH.
:: It's only done if the tests fail to find the entries in the 'System PATH' environment variable, which they should be as default in Windows.
:: Fun fact - in a FINDSTR search string, backslash \ is the special character escape character.

ECHO %PATH% | FINDSTR /L /C:C\:\Windows\System32\; >nul 2>&1 || SET "PATH=%PATH%C:\Windows\System32;"
ECHO %PATH% | FINDSTR /L /C:C\:\Windows\System32\Wbem\; >nul 2>&1 || SET "PATH=%PATH%C:\Windows\System32\Wbem;"
ECHO %PATH% | FINDSTR /L /C:C\:\Windows\SysWOW64\; >nul 2>&1 || SET "PATH=%PATH%C:\Windows\SysWOW64;"
ECHO %PATH% | FINDSTR /L /C:C\:\Windows\System32\WindowsPowerShell\v1.0\\; >nul 2>&1 || SET "PATH=%PATH%C:\Windows\System32\WindowsPowerShell\v1.0\;"

:: Checks to see if CMD is working by checking WHERE for some commands - if the WHERE fails then a variable is set.
FOR %%X IN (FINDSTR CERTUTIL NETSTAT PING CURL TAR) DO (
  WHERE %%X >nul 2>&1 || SET CMDBROKEN=Y
)

IF DEFINED CMDBROKEN IF !CMDBROKEN!==Y (
  ECHO:
  ECHO        %yellow% WARNING - PROBLEM DETECTED %blue%
  ECHO        %yellow% CMD / COMMAND PROMPT FUNCTIONS ARE NOT WORKING CORRECTLY ON YOUR WINDOWS INSTALLATION. %blue%
  ECHO:
  ECHO             FOR REPAIR SOLUTIONS
  ECHO             SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
  ECHO:
  ECHO             %green% https://github.com/nanonestor/universalator/wiki/6-Troubleshooting %blue%
  ECHO:
  ECHO             or
  ECHO             Web search for fixing / repairing Windows Command prompt function.
  ECHO:
  ECHO        %yellow% WARNING - PROBLEM DETECTED %blue%
  ECHO        %yellow% CMD / COMMAND PROMPT FUNCTIONS ARE NOT WORKING CORRECTLY ON YOUR WINDOWS INSTALLATION. %blue%
  ECHO: & ECHO: & ECHO: & ECHO:
  PAUSE & EXIT [\B]
)

:: Checks to see if Powershell is installed.  If the powershell command isn't found then an attempt is made to add it to the path for this command window session.
:: If still not recognized as command user is prompted with a message about the problem.
ver >nul
WHERE powershell >nul 2>&1 || (
  ECHO:
  ECHO   %yellow% Uh oh - POWERSHELL is not detected as installed to your system - %red% or %yellow% is not installed correctly to system PATH. %blue%
  ECHO:          
  ECHO   %yellow% 'Microsoft Powershell' program is required for this program to function. %blue% & ECHO:
  ECHO   %yellow% Web search 'Install Microsoft Powershell' to find an installer for this product! %blue%
  ECHO: & ECHO: & ECHO:
  ECHO   FOR ADDITIONAL INFORMATION - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
  ECHO            https://github.com/nanonestor/universalator/wiki
  ECHO: & ECHO:
  PAUSE & EXIT [\B]
)

:: Checks to see if somehow the installed TAR command being used is the version that does not include zip and standard output functions.
FOR /F "usebackq delims=" %%J IN (`"tar --version 2>&1"`) DO (
  ECHO %%J | FINDSTR /IC:"GNU tar" >nul && (
  ECHO: & ECHO:
  ECHO   %yellow% Uh oh - Somehow the TAR command function you OS is using, is the %red% GNU %yellow% made version. %blue%
  ECHO:
  ECHO   It is possible the OS has installed a program for additional system tools such as 'winAVR'.  & ECHO:
  ECHO   If this seems to be the case you can: & ECHO       - Uninstall the program providing the GNU version of TAR
  ECHO       - Edit the Windows 'PATH' environment variable to ensure that the C:\Windows\System32\ folder & ECHO         is at the top of the PATH list.
  ECHO: & ECHO: & ECHO:
  ECHO   For additional information or possible help if the above methods don't work, visit the wiki and discord through:
  ECHO       https://github.com/nanonestor/universalator/wiki
  ECHO: & ECHO: & ECHO: & ECHO: & ECHO: & ECHO:
  PAUSE & EXIT [\B]
  )
)

:: This is to fix an edge case issue with folder paths containing parentheses messing up echoing the path the warning message below.
SET LOC=%cd:)=]%

SET FOLDER=GOOD
:: Checks folder location this BAT is being run from for various system folders.  Sends appropriate messages if needed.
ECHO %LOC% | FINDSTR /i "onedrive documents desktop downloads .minecraft" >nul 2>&1 && SET FOLDER=BAD
ECHO %LOC% | FINDSTR /i "desktop" >nul 2>&1 && SET DESKTOP=Y
ECHO %LOC% | FINDSTR /C:"Program Files" >nul 2>&1 && SET FOLDER=BAD
IF "%cd%"=="C:\" SET FOLDER=BAD

IF !FOLDER!==BAD (
    CLS
    ECHO:
    ECHO            WARNING %blue% WARNING  WARNING %blue%
    ECHO       %red% DO NOT PUT SERVER FOLDERS INSIDE OF SYSTEM FOLDERS %blue%
    ECHO            WARNING %blue% WARNING  WARNING %blue%
    ECHO: & ECHO:
    ECHO    %red% %LOC% %blue%
  IF NOT DEFINED DESKTOP (
    ECHO    The folder this is being run from ^(shown above^) was detected to be 
    ECHO    inside a folder or subfolder containing one of these names:  & ECHO:
    ECHO   'DESKTOP'  'DOCUMENTS' 'ONEDRIVE' 'PROGRAM FILES' 'DOWNLOADS' '.minecraft'
    ECHO: & ECHO   ---------------------------------------------------------------------- & ECHO:
    ECHO    Servers should not run in these folders because it can cause issues with file access by games, system permissions, 
    ECHO    or could be set as cloud storage. 
    ECHO: & ECHO: & ECHO:
    ECHO         %green% USE FILE EXPLORER TO MAKE A NEW FOLDER OR MOVE THIS FOLDER TO A NON-SYSTEM FOLDER LOCATION. %blue%
  ) ELSE (
    ECHO: & ECHO: & ECHO:
    ECHO   -It was detected that the server folder this script was run from is located on %red% desktop %blue%. & ECHO:
    ECHO   -Do NOT use desktop for programs like this script or Minecraft servers, as doing so can have problems,
    ECHO    such as:  file access by games, system permissions, or could be set as cloud storage.
    ECHO: & ECHO: & ECHO:

  )
    ECHO:
    ECHO   -USE FILE BROWSER to create a new folder, or move this folder - to use in a non-system folder location.
    ECHO    GOOD LOCATION EXAMPLES: & ECHO:
    ECHO         %green% C:\MYNEWSERVER\ %blue%   %green% D:\MYSERVERS\MODDEDSERVERNAME\ %blue%
    ECHO: & ECHO:
    PAUSE & EXIT [\B]
)

ECHO %LOC% | FINDSTR /I "curseforge atlauncher at_launcher gdlauncher gd_launcher prismlauncher modrinthapp" 1>NUL && (
    CLS
    ECHO:
    ECHO            WARNING %blue% WARNING  WARNING %blue%
    ECHO       %red% DO NOT PUT SERVER FOLDERS INSIDE OF LAUNCHER APP OR SYSTEM FOLDERS %blue%
    ECHO            WARNING %blue% WARNING  WARNING %blue%
    ECHO: & ECHO:
    ECHO    %red% %LOC% %blue% & ECHO: & ECHO:
    ECHO   -It was detected that the server folder this script was run from is located inside the folder of a game launcher app.
    ECHO   -Do NOT use this script program from the same folder as client profiles or anywhere inside launcher app folders.
    ECHO: & ECHO    ------------------------------------------- & ECHO: & ECHO:
    ECHO   -DO use a folder location ouside of any launcher app or Windows system folder ^(including desktop^) & ECHO:
    ECHO    GOOD LOCATION EXAMPLES: & ECHO:
    ECHO         %green% C:\MYNEWSERVER\ %blue%   %green% D:\MYSERVERS\MODDEDSERVERNAME\ %blue% & ECHO: & ECHO: & ECHO: & ECHO:
    PAUSE & EXIT [\B]

  PAUSE
)

:: BEGIN CHECKING HARD DRIVE FREE SPACE
:: Returns True if more than the amount of hard drive space is free, False if not
FOR /F "usebackq delims=" %%A IN (`powershell -Command "IF (( Get-WMIObject Win32_Logicaldisk -filter ""deviceID = '%~d0'"""").FreeSpace -gt 20GB) {'True'} ELSE {'False'}"`) DO SET "DISKGBFREE=%%A" & IF "!DISKGBFREE!"=="False" SET DISKWORRY=Y
:: Returns the percent of hard drive space free
FOR /F %%A IN ('powershell -Command "$data = get-psdrive %CD:~0,1%; $result = ($data.used/($data.free+$data.used)); $percent = $result.ToString().SubString(2,2); $percent"') DO SET DISKPERCENT=%%A & IF !DISKPERCENT! GTR 95 SET DISKWORRY=Y

:: If either of the above is of concern then show a bypassable warning message
IF DEFINED DISKWORRY (
  CLS
  ECHO: & ECHO: & ECHO:
  ECHO   %red% DISK SPACE WARNING - DISK SPACE WARNING - DISK SPACE WARNING %blue% & ECHO: & ECHO:
  ECHO       %yellow% IT WAS FOUND THAT THE HARD DRIVE THIS FOLDER LOCATION IS IN, IS LOW ON FREE / AVAILABLE SPACE: %blue% & ECHO:
  IF DEFINED DISKGBFREE IF "!DISKGBFREE!"=="False" ECHO       %red% HARD DRIVE HAS LESS THAN 20gb OF FREE SPACE %blue%
  IF DEFINED DISKPERCENT IF !DISKPERCENT! GTR 95 ECHO       %red% PERCENT OF HARD DRIVE %~d0 USED IS !DISKPERCENT!%% %blue%
  ECHO: & ECHO       %yellow% YOU CAN PRESS ANY KEY TO BYPASS THIS WARNING AND CONTINUE, %blue%
  ECHO       %yellow% HOWEVER YOU SHOULD FREE UP MORE SPACE IF YOU ARE GOING TO BE RUNNING SERVER FILES^^! %blue% & ECHO: & ECHO:
  ECHO   %red% DISK SPACE WARNING - DISK SPACE WARNING - DISK SPACE WARNING %blue% & ECHO: & ECHO: & ECHO:
  PAUSE
)

:: BEGIN CHECKING HOSTS FILE FOR IP REDIRECTS
:: Loops through the lines inside the hosts file and looks for lines with the replacement detection strings
IF EXIST "%WINDIR%\System32\drivers\etc\hosts" FOR /F "delims=" %%A IN ('type "%WINDIR%\System32\drivers\etc\hosts"') DO (
  SET TEMP=%%A
  IF "!TEMP!" NEQ "!TEMP:launchermeta.mojang=x!" SET FOUNDREDIR=Y
  IF "!TEMP!" NEQ "!TEMP:piston-meta.mojang=x!" SET FOUNDREDIR=Y
)
IF DEFINED FOUNDREDIR (
  SET "DNSFLUSH=ipconfig /dnsflush"
  CLS
  ECHO: & ECHO:
  ECHO   %red% IP REDIRECTION FOUND - IP REDIRECTION FOUND %blue% & ECHO:
  ECHO     %yellow% IT WAS FOUND THAT YOUR WINDOWS HOSTS FILE CONTAINS IP ADDRESS REDIRECTION %blue%
  ECHO     %yellow% FOR MOJANG ^(MINECRAFT^) URL FILE SERVER ADDRESSES. %blue% & ECHO:
  ECHO     %yellow% TO CONTACT THE FILE SERVERS CORRECTLY, YOU MUST REMOVE THESE REDIRECTS BY OPENING THE HOSTS %blue%
  ECHO     %yellow% FILE AS ADMINISTRATOR, REMOVING THE URL / IP REDIRECTION LINES, AND SAVING THE FILE WITHOUT THEM. %blue% & ECHO:
  ECHO     THE FILE IS LOCATED AT %WINDIR%\System32\drivers\etc\hosts & ECHO:
  ECHO   %red% IP REDIRECTION FOUND - IP REDIRECTION FOUND %blue% & ECHO: & ECHO: & ECHO: & ECHO: & ECHO:
  ECHO     %yellow% * AFTER SAVING THE HOSTS FILE WITH REDIRECTS REMOVED, IT IS A GOOD IDEA TO DO A DNS FLUSH %blue% & ECHO:
  ECHO     To do a DNS flush, open a CMD ^(Terminal^) window and enter the command %green% !DNSFLUSH! %blue% & ECHO: & ECHO: & ECHO:
  PAUSE & EXIT [\B]
)
:skiphostscheck

IF /I !MODLOADER!==FORGE SET FORGE=!MODLOADERVERSION!
IF /I !MODLOADER!==NEOFORGE SET NEOFORGE=!MODLOADERVERSION!
IF /I !MODLOADER!==FABRIC SET FABRICLOADER=!MODLOADERVERSION!
IF /I !MODLOADER!==QUILT SET QUILTLOADER=!MODLOADERVERSION!
IF DEFINED MAXRAMGIGS SET "MAXRAM=-Xmx!MAXRAMGIGS!G"
SET OVERRIDE=N

:: END GENERAL PRE-RUN ITEMS

:: BEGIN CHECKING server.properties FILE FOR IP ENTRY AND OTHER
:: IF NOT EXIST server.properties SET FLIGHT=allow-flight=true
IF NOT EXIST server.properties (
    ECHO allow-flight=true>server.properties
    GOTO :skipserverproperties
)
:: Constructs a pseudo array list to store the server.properties file info
SET idx=0
IF EXIST server.properties (
  FOR /F "usebackq delims=" %%J IN (server.properties) DO (
    SET "serverprops[!idx!]=%%J"
    SET /a idx+=1
  )

:: Sets a variable to the line number that contains server-ip= , also checks if the full line is only that or also contains additional info (different string value)
FOR /L %%T IN (0,1,!idx!) DO (
    IF "!serverprops[%%T]:~0,10!"=="server-ip=" SET IPLINE=%%T
)
)
IF DEFINED IPLINE IF "!serverprops[%IPLINE%]!" NEQ "server-ip=" SET IS_IP_ENTERED=Y
:: The following must be done outside the IF EXIST server.properties list because you can't tag loop back into an IF loop.
:: If it was found that information was entered after server-ip= checks with user if it's ok to blank the value out or leave it alone.
:confirmip
IF DEFINED IPLINE IF !IS_IP_ENTERED!==Y (
    CLS
    ECHO:
    ECHO   %yellow% WARNING WARNING WARNING %blue%
    ECHO:
    ECHO   IT IS DETECTED THAT THE server.properties FILE HAS AN IP ADDRESS ENTERED AFTER server-ip=
    ECHO:
    ECHO   THIS ENTRY IS ONLY TO BE USED USED IF YOU ARE SETTING UP A CUSTOM DOMAIN
    ECHO   IF YOU ARE NOT SETTING UP A CUSTOM DOMAIN THEN THE SERVER WILL NOT LET PLAYERS CONNECT CORRECTLY
    ECHO:
    ECHO   %yellow% WARNING WARNING WARNING %blue%
    ECHO:
    ECHO   CHOOSE TO CORRECT THIS ENTRY OR IGNORE
    ECHO   ONLY CHOOSE IGNORE IF YOU ARE SETTING UP A CUSTOM DOMAIN
    ECHO:
    ECHO   ENTER YOUR CHOICE:
    ECHO   'CORRECT' or 'IGNORE'
    ECHO:
    SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
    SET /P "CHOOSE_IP="
    :: Trims off any trailing spaces
    IF "!CHOOSE_IP:~-1!"==" " CALL :trim "!CHOOSE_IP!" CHOOSE_IP
    
)
IF DEFINED IPLINE IF !IS_IP_ENTERED!==Y (
    IF /I !CHOOSE_IP! NEQ CORRECT IF /I !CHOOSE_IP! NEQ IGNORE GOTO :confirmip
)
:: If an IP address was entered and user choses to remove then print server.properties with it made blank, also always set allow-flight to be true
IF DEFINED IPLINE IF /I !CHOOSE_IP!==CORRECT (
    FOR /L %%T IN (0,1,!idx!) DO (
        IF %%T NEQ %IPLINE% IF "!serverprops[%%T]!" NEQ "" IF "!serverprops[%%T]!" NEQ "allow-flight=false" IF "!serverprops[%%T]!" NEQ "online-mode=false" ECHO !serverprops[%%T]!>>server.properties2
        IF "!serverprops[%%T]!"=="allow-flight=false" ECHO allow-flight=true>>server.properties2
        IF "!serverprops[%%T]!"=="online-mode=false" ECHO online-mode=true>>server.properties2
        IF %%T==%IPLINE% ECHO server-ip=>>server.properties2
    )
    DEL server.properties
    RENAME server.properties2 server.properties
    :: Skips past the last section since the job is done for this case.
    GOTO :skipserverproperties
)
:: At this point if IPLINE is defined and user chooses Y then scipt has skipped ahead, also skipped ahead if server.properties does not previously exist.
:: This means that all that's left are cases where IPLINE is not defined or user has chosen IGNORE.
:: Below reprints all lines except always setting allow-flight=true
    FOR /L %%T IN (0,1,!idx!) DO (
        IF "!serverprops[%%T]!" NEQ "" IF "!serverprops[%%T]!" NEQ "allow-flight=false" IF "!serverprops[%%T]!" NEQ "online-mode=false" ECHO !serverprops[%%T]!>>server.properties2
        IF "!serverprops[%%T]!"=="allow-flight=false" ECHO allow-flight=true>>server.properties2
        IF "!serverprops[%%T]!"=="online-mode=false" ECHO online-mode=true>>server.properties2
    )
    DEL server.properties
    RENAME server.properties2 server.properties

:skipserverproperties
:: END CHECKING server.properties FILE FOR IP ENTRY AND OTHER

:: BEGIN PORT STUFF CHECKING

:: Tries to find server.properties file port setting
IF EXIST server.properties (
  FINDSTR server-port server.properties 1>nul 2>nul && ( FOR /F "tokens=2 delims==" %%A IN ('FINDSTR server-port server.properties') DO SET CONFIGPORT=%%A )
)
:: If Universalator config isn't present
IF NOT EXIST settings-universalator.txt (
  SET PORT=25565
  SET PORTUDP=24454
)

:: If Universalator config present find stored port numbers and set
IF EXIST settings-universalator.txt (
  FOR /F "delims=" %%A IN ('type settings-universalator.txt') DO (
    SET "TEMP=%%A"
    
    IF "!TEMP:SET PORT=x!" NEQ "!TEMP!" ( 
      REM Trims off trailing spaces using replacement
      SET TEMP=!TEMP:SET PORT=SET;PORT!
      SET TEMP=!TEMP: =!
      SET TEMP=!TEMP:SET;PORT=SET PORT!
      REM This should be a direct SET for the PORT variable
      !TEMP!
    )
      IF "!TEMP:SET PORTUDP=x!" NEQ "!TEMP!" ( 
      REM Trims off trailing spaces using replacement
      SET TEMP=!TEMP:SET PORTUDP=SET;PORTUDP!
      SET TEMP=!TEMP: =!
      SET TEMP=!TEMP:SET;PORTUDP=SET PORTUDP!
      REM This should be a direct SET for the PORTUDP variable
      !TEMP!
    )
  )
  IF NOT DEFINED PORT SET PORT=25565
  IF NOT DEFINED PORTUDP SET PORTUDP=24454
)

:: IF server.properties exists and universalator settings exists, but no sever-port in server.properties
IF EXIST server.properties IF NOT DEFINED CONFIGPORT ECHO server-port=!PORT!>>server.properties

:: If the server.properties port number isn't what's in the Universalator config - edit server.properties to match
IF EXIST server.properties IF DEFINED CONFIGPORT IF !CONFIGPORT! NEQ !PORT! (
  CALL :serverpropsedit server-port !PORT!
)


:: Checks to see if the port is set to some low possibly conflicting numbered port
IF %PORT% LSS 10000 (
  CLS
  ECHO: & ECHO: & ECHO   %red% CURRENT PORT SET IN server.properties FILE - %blue%%yellow% !PORT! %blue%
  ECHO: & ECHO   %red% DO NOT SET THE PORT TO BE USED BELOW 10000 - BELOW THAT NUMBER IS NOT A GOOD IDEA %blue%
  ECHO: & ECHO   %red% OTHER CRITICAL PROCESSES MAY ALREADY USE PORTS BELOW THIS NUMBER %blue% & ECHO:
  PAUSE & EXIT [\B]
)

:: Checks to see if the port is found as currently in-use with netstat
( NETSTAT -aon | FINDSTR %PORT% >nul 2>&1 ) && SET FOUNDOPENPORT=Y

:: If no entry was found SKIP this section entirely
IF NOT DEFINED FOUNDOPENPORT GOTO :skipportclear

:: Sets the PID number
IF DEFINED FOUNDOPENPORT FOR /F "tokens=5 delims= " %%A IN ('NETSTAT -aon ^| FINDSTR %PORT%') DO SET PIDNUM=%%A

:: Gets the relevant information about the found task PID number
FOR /F "tokens=1,3,4 delims= " %%E IN ('TASKLIST /FI "pid eq %PIDNUM%"') DO ( SET IMAGENAME=%%E & SET SESSIONNAME=%%F & SET SESSIONNUM=%%G )

:: If 'system' is found in the session name then skip
( ECHO %SESSIONNAME% | FINDSTR /I "system" >nul 2>&1 ) && GOTO :skipportclear
GOTO :skipportclear
:portwarning
  CLS
  ECHO: & ECHO:
  ECHO   %red% WARNING - PORT ALREADY IN USE - WARNING %blue% & ECHO: & ECHO       %yellow% CURRENT PORT SET = %PORT% %blue% & ECHO:
  ECHO       IT IS DETECTED THAT THE PORT CURRENTLY SET (SHOWN ABOVE),
  ECHO       IN THE SETTINGS FILE server.properties %yellow% IS ALREADY IN USE %blue% & ECHO:
  ECHO       THE FOLLOWING IS THE PROCESS RUNNING THAT APPEARS TO BE USING THE PORT & ECHO:
  ECHO             - IMAGE NAME - %IMAGENAME%
  ECHO             - SESSION NAME - %SESSIONNAME%
  ECHO             - PID NUMBER - %PIDNUM%
  ECHO: &   ECHO       MINECRAFT SERVERS WILL USUALLY CONTAIN THE NAMES java.exe AND/OR Console & ECHO:
  ECHO   %red% WARNING - PORT ALREADY IN USE - WARNING %blue% & ECHO: & ECHO:
  ECHO       %yellow% Enter 'KILL' %blue% to try and let the script close the program already using the port. & ECHO:
  ECHO       %yellow% Enter 'Q' %blue% to close the script program if you'd like to try and solve the issue on your own. & ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P "KILLIT="
  :: Trims off any trailing spaces
  IF "!KILLIT:~-1!"==" " CALL :trim "!KILLIT!" KILLIT

  IF /I !KILLIT! NEQ KILL IF /I !KILLIT! NEQ Q GOTO :portwarning
  IF /I !KILLIT!==Q (
    PAUSE & EXIT [\B]
  )
IF /I !KILLIT!==KILL (
  CLS
  ECHO: & ECHO   ATTEMPTING TO KILL TASK PLEASE WAIT... & ECHO: & ECHO   IF THIS METHOD SEEMS TO FAIL TO CLEAR THE PORT IN USE, & ECHO     TRY RESTARTING YOUR COMPUTER & ECHO:
  TASKKILL /F /PID %PIDNUM%
  ping -n 6 127.0.0.1 >nul
)
ver > nul
NETSTAT -o -n -a | FINDSTR %PORT%
IF %ERRORLEVEL%==0 (
  CLS
  ECHO: & ECHO   %red% OOPS %blue% - THE ATTEMPT TO KILL THE TASK PROCESS USING THE PORT SEEMS TO HAVE FAILED & ECHO: & ECHO   FURTHER OPTIONS:
  ECHO   --SET A DIFFERENT PORT, OR CLOSE KNOWN SERVERS/PROGRAMS USING THIS PORT. & ECHO: & ECHO   --IF YOU THINK PORT IS BEING KEPT OPEN BY A BACKGROUND PROGRAM,
  ECHO     OR WINDOWS IS STUCK SHUTTING DOWN WHATEVER WAS HOLDING THE PORT OPEN%green%:%blue% & ECHO      %green% TRY RESTARTING COMPUTER. %blue% & ECHO: & ECHO: & ECHO: 
  PAUSE & EXIT [\B]
)
IF %ERRORLEVEL%==1 (
  ECHO: & ECHO  %green% SUCCESS^^! %blue% & ECHO: & ECHO   IT SEEMS LIKE KILLING THE PROGRAM WAS SUCCESSFUL IN CLEARING THE PORT^^! & ECHO:
  ping -n 4 127.0.0.1 >nul
)
:: Below line is purely done to guarantee that the current ERRORLEVEL is reset to 0
:skipportclear
ver > nul
:: END PORT STUFF CHECKING

:: BEGIN PUBLIC IP DETECTION

:: Obtains the computer's public IP address by poking a website API service which specifically exists for this purpose - api.bigdatacloud.net stopped sending ipv4 publicly and now sends only ipv6, so primary is ip-api.com now.
FOR /F %%B IN ('powershell -Command "$data = ((New-Object System.Net.WebClient).DownloadString('http://ip-api.com/json/?fields=query') | Out-String | ConvertFrom-Json); $data.query"') DO SET PUBLICIP=%%B
:: If trying api-api.com failed to get the public IP then try this different web service at ip-api.com
IF NOT DEFINED PUBLICIP FOR /F %%B IN ('powershell -Command "$data = ((New-Object System.Net.WebClient).DownloadString('https://api.ipify.org?format=json') | Out-String | ConvertFrom-Json); $data.ip"') DO SET PUBLICIP=%%B

IF NOT DEFINED PUBLICIP SET "PUBLICIP=NOT DETECTED"

:: BEGIN LOCAL IPV4 ADDRESS DETECTION

REM Use ipconfig to get the local IP address
IF NOT DEFINED LOCALIP (
  FOR /F "tokens=1,2 delims=:" %%G IN ('ipconfig') DO (
    SET "LOOKFORIPV4=%%G"
    REM If ethernet and WiFi are both active then the first entry recorded will be ethernet which is probably preferred
    REM Ethernet is listed first always in ipconfig - so if LOCALIP becomes defined the loop gets exited by going to the exitlocalipset label
    IF "!LOOKFORIPV4!" NEQ "!LOOKFORIPV4:IPv4 Address=replace!" (
      SET "FOUNDLOCALIP=%%H"
      SET "LOCALIP=!FOUNDLOCALIP: =!"
      GOTO :exitlocalipset
    )
  )
)
:exitlocalipset
:: END GETTING LOCAL IPV4 ADDRESS TO BE USED

:: If license.txt didn't exist and was downloaded with a successful errorlevel earlier, test to see that it still exists - if not something is forcefully deleting downloaded files.
IF DEFINED GOTLICENSE IF NOT EXIST "%HERE%\univ-utils\license.txt" (
  CLS
  ECHO: & ECHO: & ECHO: & ECHO   %red% OOPS %blue% - %yellow% IT LOOKS LIKE SOMETHING ON YOUR COMPUTER IS NOT ALLOWING THE SCRIPT TO DOWNLOAD FILES AND KEEP THEM. %blue% & ECHO:
  ECHO            ^(The license.txt for the project downloaded but something on the computer removed it^)  & ECHO:
  ECHO   %yellow% DOWNLOADING FILES IS NECESSARY TO SET UP YOUR SERVER. %blue% & ECHO   %yellow% THIS PROBLEM NEEDS TO BE RESOLVED FOR THE UNIVERSALATOR TO WORK. %blue% & ECHO:
  ECHO   %yellow% POSSIBLE REASONS COULD BE ANTIVIRUS PROGRAMS OR WINDOWS USER PERMISSIONS. %blue% & ECHO: & ECHO: & ECHO: & ECHO:
  PAUSE & EXIT [\B]
)

:: If no settings file exists yet then go directly to entering settings (first setting being Minecraft version)
IF NOT EXIST settings-universalator.txt GOTO :startover

:: BEGIN MAIN MENU
:mainmenu

TITLE Universalator %UNIV_VERSION%

:: The settings file should always exist if we get here, but check anyways.
IF EXIST settings-universalator.txt (
  :: Reads off the contents of the settings file if it's present, to set current setting values.  Doing it this way avoids needing to rename the file to a .bat or .cmd to perform a CALL.
  FOR /F "delims=" %%A IN (settings-universalator.txt) DO SET "TEMP=%%A" & IF "!TEMP:~0,2!" NEQ "::" (
    CLS
    SET "TEMP=%%A"
    REM Uses a trim function to remove spaces at the ends of any line.
    IF "!TEMP:~-1!"==" " CALL :trim "!TEMP!" TEMP
    !TEMP!
  )

  :: Sets a string variable for passing -Xmx JVM startup argument to java launches, based on the integer entered for number of gigs.
  IF DEFINED MAXRAMGIGS IF [!MAXRAMGIGS!] NEQ [] SET MAXRAM=-Xmx!MAXRAMGIGS!G
  :: The settings txt file has one entry for MODLOADER version.  Depending on the value of MODLOADER, set the variable for whichever modloader type is set equal to the MODLOADERVERSION.
  IF /I !MODLOADER!==FORGE SET FORGE=!MODLOADERVERSION!
  IF /I !MODLOADER!==NEOFORGE SET NEOFORGE=!MODLOADERVERSION!
  IF /I !MODLOADER!==FABRIC SET FABRICLOADER=!MODLOADERVERSION!
  IF /I !MODLOADER!==QUILT SET QUILTLOADER=!MODLOADERVERSION!
)

:: Sets some things with default values in case they don't exist yet
IF NOT EXIST univ-utils MD univ-utils
IF NOT DEFINED PROTOCOL SET PROTOCOL=TCP
IF DEFINED PROTOCOL IF !PROTOCOL! NEQ TCP IF NOT EXIST "%HERE%\univ-utils\Portforwarded\Portforwarded.Server.exe" (
  SET PROTOCOL=TCP
  CALL :univ_settings_edit PROTOCOL TCP
)

:: RESTARTCOUNT for auto rebooting is reset to 0 if the script gets back here after launching before.
SET /a RESTARTCOUNT=0

SET "MAINMENU="
CLS
ECHO:%yellow%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO    Welcome to the Universalator - A modded Minecraft server installer / launcher    
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%blue%
ECHO:
ECHO   %yellow% CURRENT SETTINGS %blue%
ECHO:
ECHO:
IF DEFINED MINECRAFT ECHO   %yellow% MINECRAFT VERSION %blue% !MINECRAFT!
IF NOT DEFINED MINECRAFT ECHO   %yellow% MINECRAFT VERSION %blue% %red% ENTER SETTINGS - 'S' %blue%
IF DEFINED  MODLOADER ECHO   %yellow% MODLOADER %blue%         !MODLOADER!
IF NOT DEFINED MODLOADER ECHO   %yellow% MODLOADER %blue%         %red% ENTER SETTINGS - 'S' %blue%
IF DEFINED MODLOADER IF DEFINED NEOFORGE IF /I !MODLOADER!==NEOFORGE ECHO   %yellow% NEOFORGE VERSION %blue%  !NEOFORGE!
IF DEFINED MODLOADER IF DEFINED FORGE IF /I !MODLOADER!==FORGE ECHO   %yellow% FORGE VERSION %blue%     !FORGE!
IF DEFINED MODLOADER IF DEFINED FABRICLOADER IF /I !MODLOADER!==FABRIC ECHO   %yellow% FABRIC LOADER %blue%     !FABRICLOADER!
IF DEFINED MODLOADER IF DEFINED QUILTLOADER IF /I !MODLOADER!==QUILT ECHO   %yellow% FABRIC LOADER %blue%     !QUILTLOADER!
IF DEFINED JAVAVERSION IF !OVERRIDE! NEQ Y ECHO   %yellow% JAVA VERSION %blue%      !JAVAVERSION!
IF DEFINED OVERRIDE IF !OVERRIDE!==Y ECHO   %yellow% JAVA VERSION %blue%   %green% * CUSTOM OVERRIDE - OS JAVA PATH * %blue% & ECHO                       !CUSTOMJAVA!
IF NOT DEFINED JAVAVERSION ECHO   %yellow% JAVA VERSION %blue%      %red% ENTER SETTINGS - 'S' %blue%
IF NOT DEFINED MAXRAMGIGS ECHO   %yellow% MAX RAM / MEMORY %blue%  %red% ENTER SETTINGS - 'S' %blue%
ECHO: & ECHO:
IF DEFINED MAXRAMGIGS ECHO   %yellow% MAX RAM / MEMORY %blue%  !MAXRAMGIGS!
ECHO:
ECHO:
IF DEFINED PORT IF NOT DEFINED USEPORTFORWARDED ECHO   %yellow% CURRENT PORT SET %blue%  TCP !PORT!
IF DEFINED PORT IF !USEPORTFORWARDED!==N ECHO   %yellow% CURRENT PORT SET %blue%  TCP !PORT!
IF !USEPORTFORWARDED!==Y IF DEFINED PORT IF DEFINED PROTOCOL IF "!PROTOCOL!"=="TCP" ECHO   %yellow% CURRENT PORT SET %blue%  TCP !PORT!
IF !USEPORTFORWARDED!==Y IF DEFINED PORT IF DEFINED PORTUDP IF DEFINED PROTOCOL IF "!PROTOCOL!"=="BOTH" ECHO   %yellow% CURRENT PORTS SET %blue%  TCP !PORT! / UDP !PORTUDP!
IF !USEPORTFORWARDED!==Y IF DEFINED PORTUDP IF DEFINED PROTOCOL IF "!PROTOCOL!"=="UDP" ECHO   %yellow% CURRENT PORT SET %blue%  UDP !PORTUDP!
ECHO                                                             %green% MENU OPTIONS %blue%
IF DEFINED USEPORTFORWARDED IF EXIST "%HERE%\univ-utils\Portforwarded\Portforwarded.Server.exe" (
  IF !USEPORTFORWARDED!==Y ECHO   %yellow% UPNP PORT FORWARDING %blue% - %green% ENABLED %blue%
  IF !USEPORTFORWARDED!==N ECHO   %yellow% UPNP PORT FORWARDING %blue% - %red% DISABLED %blue%
)
IF EXIST settings-universalator.txt ECHO                                                        %green% L %blue%    = LAUNCH SERVER & ECHO:
IF NOT EXIST settings-universalator.txt ECHO                                                        %green% S %blue%    = SETTINGS ENTRY
IF EXIST settings-universalator.txt ECHO                                                        %green% S %blue%    = RE-ENTER ALL SETTINGS
ECHO                                                        %green% R %blue%    = RAM MAX SETTING
ECHO                                                        %green% UPNP %blue% = UPNP PORT FORWARDING MENU
ECHO                                                        %green% SCAN %blue% = SCAN MOD FILES FOR CLIENT MODS & ECHO:
ECHO                                                        %green% A %blue%    = (LIST) ALL POSSIBLE MENU OPTIONS
:allcommandsentry
SET /P SCRATCH="%blue%  %green% ENTER A MENU OPTION:%blue% " <nul
SET /P "MAINMENU="
IF "!MAINMENU:~-1!"==" " CALL :trim "!MAINMENU!" MAINMENU

IF /I !MAINMENU!==Q COLOR 07 & CLS & EXIT [\B]
IF /I !MAINMENU!==UPNP GOTO :upnpmenu
IF /I !MAINMENU!==R GOTO :justsetram
IF /I !MAINMENU!==S GOTO :startover
IF /I !MAINMENU!==J GOTO :setjava
IF /I !MAINMENU!==L IF EXIST settings-universalator.txt IF DEFINED MINECRAFT IF DEFINED MODLOADER IF DEFINED JAVAVERSION GOTO :actuallylaunch
IF /I !MAINMENU!==SCAN GOTO :getmcmajor
IF /I !MAINMENU!==OVERRIDE GOTO :override
IF /I !MAINMENU!==MCREATOR IF EXIST "%HERE%\mods" GOTO :mcreator
IF /I !MAINMENU!==MCREATOR IF NOT EXIST "%HERE%\mods" GOTO :mainmenu
IF /I !MAINMENU!==A GOTO :allcommands
IF /I !MAINMENU!==ZIP GOTO :zipit
IF /I !MAINMENU!==PORT GOTO :portedit
IF /I !MAINMENU!==PROPS GOTO :editserverprops
IF /I !MAINMENU!==FIREWALL GOTO :firewallcheck
IF /I !MAINMENU!==RESTART GOTO :restarttoggle

:: If no recognized entries were made then go back to main menu

GOTO :mainmenu

:allcommands
CLS
ECHO:%yellow%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO    Welcome to the Universalator - A modded Minecraft server installer / launcher    
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%blue%
ECHO: & ECHO: & ECHO:
ECHO:    %green% M %blue% = MAIN MENU
ECHO:    %green% S %blue% = RE-ENTER ALL SETTINGS
ECHO:    %green% L %blue% = LAUNCH SERVER
ECHO:    %green% R %blue% = SET RAM MAXIMUM AMOUNT
ECHO:    %green% J %blue% = SET JAVA VERSION
ECHO:    %green% Q %blue% = QUIT
ECHO:
ECHO:    %green% SCAN %blue%     = SCAN MOD FILES FOR CLIENT ONLY MODS
ECHO:    %green% PORT %blue%     = CHANGE THE PORT NUMBER USED
ECHO:    %green% PROPS %blue%    = CHANGE SERVER PROPERTIES
ECHO:    %green% RESTART %blue% = TOGGLE AUTOMATIC RESTART ON UNPLANNED SHUTDOWN
ECHO:    %green% FIREWALL %blue% = CHECK FOR A VALID FIREWALL RULE SETTING FOR JAVA
ECHO:    %green% UPNP %blue%     = UPNP PORT FORWARDING MENU
ECHO:    %green% MCREATOR %blue% = SCAN MOD FILES FOR MCREATOR MADE MODS
ECHO:    %green% OVERRIDE %blue% = USE CURRENTLY SET SYSTEM JAVA PATH INSTEAD OF ADOPTIUM JAVA
ECHO:    %green% ZIP %blue%      = MENU FOR CREATING SERVER PACK ZIP FILE & ECHO: & ECHO: & ECHO:
GOTO :allcommandsentry

:: END MAIN MENU

:startover
:: User entry for Minecraft version
CLS
IF NOT EXIST settings-universalator.txt (
ECHO:%yellow%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO    Welcome to the Universalator - A modded Minecraft server installer / launcher    
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%blue%
ECHO: & ECHO:
ECHO    %green% Settings can be changed from main menu once all initial settings have been entered %blue%
) ELSE (
  ECHO: & ECHO:
)
ECHO: & ECHO: & ECHO: & ECHO:
ECHO   %yellow% ENTER THE MINECRAFT VERSION %blue%
ECHO:
ECHO    example: 1.7.10
ECHO    example: 1.16.5
ECHO    example: 1.19.2
ECHO:
ECHO   %yellow% ENTER THE MINECRAFT VERSION %blue%
ECHO: & ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P MINECRAFT=
:: Trims off any trailing spaces
IF "!MINECRAFT:~-1!"==" " CALL :trim "!MINECRAFT!" MINECRAFT

:: Goes to do the check to get a game manifest from Mojang.
SET "SMODE=SETTINGS"
GOTO :getmcmanifest
:backmcmanifest
SET "SMODE="
:: Only do this test if a manifest was successfully obtained.
IF EXIST "%HERE%\univ-utils\version_manifest_v2.json" (
  SET FOUNDMC=IDK

  FOR /F "delims=" %%A IN ('powershell -Command "$data=(Get-Content -Raw -Path 'univ-utils/version_manifest_v2.json' | Out-String | ConvertFrom-Json); $stuff=($data.versions | Where-Object -Property type -Value release -EQ); $stuff.id"') DO (
    IF "%%A"=="!MINECRAFT!" SET FOUNDMC=Y
  )
  IF !FOUNDMC! NEQ Y (
    ECHO: & ECHO   %red% THE ENTERED VERSION - %yellow% !MINECRAFT! %red% - WAS NOT FOUND TO BE A VALID RELEASE VERSION OF THE GAME %blue%
    ECHO   %yellow% PLEASE TRY AGAIN^! %blue% & ECHO:
    PAUSE
    GOTO :startover
  )
)

:: IF running SCAN from main menu it gets placed here first to get values for MC major and minor versions.
:getmcmajor

:: Stores the major and minor Minecraft version numbers in their own variables as integers.
SET "MCMINOR="
FOR /F "tokens=2,3 delims=." %%E IN ("!MINECRAFT!") DO (
    SET /a MCMAJOR=%%E
    SET /a MCMINOR=%%F >nul 2>&1
)
IF NOT DEFINED MCMINOR SET /a MCMINOR=0

:: IF running SCAN from main menu now goto actual scan section

IF /I !MAINMENU!==SCAN GOTO :actuallyscanmods

:reentermodloader
:: User entry for Modloader version
CLS
IF NOT EXIST settings-universalator.txt (
ECHO:%yellow%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO    Welcome to the Universalator - A modded Minecraft server installer / launcher    
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%blue%
ECHO: & ECHO:
ECHO    %green% Settings can be changed from main menu once all settings have been entered %blue%
) ELSE (
  ECHO: & ECHO: & ECHO:
)
ECHO: & ECHO: & ECHO: & ECHO:
ECHO   %yellow% ENTER THE MODLOADER TYPE %blue%
ECHO:
ECHO    Valid entries - %green% FORGE %blue%
ECHO                    %green% NEOFORGE %blue%
ECHO                    %green% FABRIC %blue%
ECHO                    %green% QUILT %blue%
ECHO                    %green% VANILLA %blue%
ECHO:
ECHO   %yellow% ENTER THE MODLOADER TYPE %blue%
ECHO: & ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P "MODLOADER="
:: Trims off any trailing spaces
IF "!MODLOADER:~-1!"==" " CALL :trim "!MODLOADER!" MODLOADER

:: Corrects entry to be all capital letters if not already entered by user.
IF /I !MODLOADER!==FORGE SET MODLOADER=FORGE
IF /I !MODLOADER!==FABRIC SET MODLOADER=FABRIC
IF /I !MODLOADER!==QUILT SET MODLOADER=QUILT
IF /I !MODLOADER!==NEOFORGE SET MODLOADER=NEOFORGE
IF /I !MODLOADER!==VANILLA SET MODLOADER=VANILLA
IF /I !MODLOADER! NEQ FORGE IF /I !MODLOADER! NEQ FABRIC IF /I !MODLOADER! NEQ NEOFORGE IF /I !MODLOADER! NEQ QUILT IF /I !MODLOADER! NEQ VANILLA GOTO :reentermodloader

:: At this point, since a modloader type is entered and the script will be getting the maven metadata file next, see if DNS can find the maven repository IP.
IF /I !MODLOADER!==FORGE SET "MAVENURL=maven.minecraftforge.net"
IF /I !MODLOADER!==FABRIC SET "MAVENURL=maven.fabricmc.net"
IF /I !MODLOADER!==QUILT SET "MAVENURL=maven.quiltmc.org"
IF /I !MODLOADER!==NEOFORGE SET "MAVENURL=maven.neoforged.net"

:: Uses a powershell command to see if the DNS resolves the URL for whichever modloader.  Can't just use it to grab an IP address to use later, using DNS 1.1.1.1 etc, 
:: because cloudflare blocks using the websites with direct IPs and they could not be used later on.
IF !MODLOADER! NEQ VANILLA FOR /F %%A IN ('powershell -Command "Resolve-DnsName -Name !MAVENURL!; $?"') DO SET DIDMODLOADERRESOLVE=%%A
IF !DIDMODLOADERRESOLVE!==False SET DNSFAIL=Y & SET DNSFAILMODLOADER=Y

:: If these tests have already passed before in this script session, then bypass checking vanilla DNS again to speed things up.
IF DEFINED DNSANDPINGPASSEDBEFORE GOTO :skipvanilladnstest

:: Checks to see if the Mojang servers are showing up.
FOR /F %%A IN ('powershell -Command "Resolve-DnsName -Name 'launchermeta.mojang.com'; $?"') DO SET DIDLAUNCHERMETARESOLVE=%%A
IF !DIDLAUNCHERMETARESOLVE!==False SET DNSFAIL=Y & SET DNSFAILMOJ1=Y

FOR /F %%A IN ('powershell -Command "Resolve-DnsName -Name 'piston-meta.mojang.com'; $?"') DO SET DIDPISTONMETARESOLVE=%%A
IF !DIDPISTONMETARESOLVE!==False SET DNSFAIL=Y & SET DNSFAILMOJ2=Y

:skipvanilladnstest

:: Tells the user the bad news if any of the tests fail.
IF DEFINED DNSFAIL (
  CLS
  ECHO: & ECHO: & ECHO:
  ECHO   %red% OOPS - THE FOLLOWING WEBSITE IP ADDRESSES COULD NOT BE FOUND USING YOUR CURRENTLY SET DNS SERVER %blue% & ECHO:
  IF DEFINED DNSFAILMODLOADER ECHO   %yellow% !MAVENURL! %blue%
  IF DEFINED DNSFAILMOJ1 ECHO   %yellow% launchermeta.mojang.com %blue%
  IF DEFINED DNSFAILMOJ2 ECHO   %yellow% piston-meta.mojang.com %blue% 
  ECHO:
  ECHO   %red% THE SOLUTION IS CHANGING YOUR COMPUTER SETTINGS TO USE A PUBLIC DNS SERVER. %blue% 
  ECHO   %red% THIS IS EASILY DONE, FOR INSTRUCTIONS ON WHERE TO FIND THIS SETTING, SEARCH THE INTERNET %blue% 
  ECHO   %red% FOR: ^"windows change dns server^" %blue% & ECHO: & ECHO: & ECHO:
  ECHO   %yellow% SUGGESTEED PUBLIC DNS SERVERS TO USE: %blue%
  ECHO   %yellow% 1.1.1.1 ^(Cloudflare^) %blue%
  ECHO   %yellow% 8.8.8.8 ^(Google^) %blue% & ECHO: & ECHO:
  PAUSE & EXIT [\B]
)

:: Try pinging the file server for whichever modloader type.  The mojang file servers are pinged for later on installation of either VANILLA, FABRIC, or QUILT.
:pingmodloaderagain
IF /I !MODLOADER!==FORGE ping -n 1 maven.minecraftforge.net >nul ||  ping -n 6 maven.minecraftforge.net >nul
IF /I !MODLOADER!==FABRIC ping -n 1 maven.fabricmc.net >nul || ping -n 6 maven.fabricmc.net >nul
IF /I !MODLOADER!==QUILT ping -n 1 maven.quiltmc.org >nul || ping -n 6 maven.quiltmc.org >nul
IF /I !MODLOADER!==NEOFORGE ping -n 1 maven.neoforged.net >nul || ping -n 6 maven.neoforged.net >nul
IF /I !MODLOADER!==VANILLA ver >nul

IF !ERRORLEVEL! NEQ 0 (
  CLS
  ECHO: & ECHO: & ECHO:
  ECHO   %red% PING FAIL - - - PING FAIL - - - PING FAIL %blue% & ECHO:
  ECHO   %yellow% A PING TO THE !MODLOADER! FILE SERVER HAS FAILED %blue%
  ECHO   %yellow% EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE %blue%
  ECHO   %yellow% PRESS ANY KEY TO TRY TO PING FILESERVER AGAIN %blue% & ECHO: & ECHO:
  PAUSE
  GOTO :pingmodloaderagain
) ELSE (
  SET DNSANDPINGPASSEDBEFORE=Y
)

:: Skips to different modloader version entry if type is not Fabric or Quilt, or just go to java setup for Vanilla
IF /I !MODLOADER!==FORGE GOTO :enterforge
IF /I !MODLOADER!==NEOFORGE GOTO :enterforge
IF /I !MODLOADER!==VANILLA GOTO :setjava


:: If a maven metadata file for whichever modloader type is present - test its age.  Set a default value first so that if no file is found the default will be the same as if the file was returned as being old.
  SET XMLAGE=True

  If !MODLOADER!==FABRIC (
    SET "METADATAFILE=maven-fabric-metadata.xml"
    SET "METADATAURL=https://maven.fabricmc.net/net/fabricmc/fabric-loader/maven-metadata.xml"
  )
  IF !MODLOADER!==QUILT (
    SET "METADATAFILE=maven-quilt-metadata.xml"
    SET "METADATAURL=https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-loader/maven-metadata.xml"
  )

  IF EXIST "%HERE%\univ-utils\!METADATAFILE!" FOR /F %%G IN ('powershell -Command "Test-Path '%HEREPOWERSHELL%\univ-utils\!METADATAFILE!' -OlderThan (Get-Date).AddHours(-6)"') DO SET XMLAGE=%%G

:: If XMLAGE is True then a new maven metadata file is obtained.  Any existing is silently deleted.  If the maven is unreachable by ping then no file delete and download is done, so any existing old file is preserved.
IF /I !XMLAGE!==True (
    DEL "%HERE%\univ-utils\!METADATAFILE!" >nul 2>&1
    curl -sLfo "%HERE%\univ-utils\!METADATAFILE!" !METADATAURL! >nul 2>&1
    IF NOT EXIST "%HERE%\univ-utils\!METADATAFILE!"  powershell -Command "(New-Object Net.WebClient).DownloadFile('!METADATAURL!', 'univ-utils\!METADATAFILE!')" >nul
)

:: Skips over the oops message if a maven metadata file was found
IF EXIST "%HERE%\univ-utils\!METADATAFILE!" GOTO :skipmavenoopsfabric

:: If script gets here then either no maven metadata file ever existed, or an old file was deleted, and none was obtained from the maven either due to download problems or because the maven is offline.
CLS
ECHO: & ECHO: & ECHO: & ECHO   %red% OOPS %blue% - %yellow% A DOWNLOAD OF THE MAVEN METADATA FILE WAS ATTEMPTED FOR THE %green% !MODLOADER! %yellow% FILE SERVER %blue% & ECHO:
ECHO   %yellow% BUT THE FILE WAS NOT FOUND AFTER THE DOWNLOAD ATTEMPT. %blue%
ECHO   %yellow% MAYBE YOUR WINDOWS USER DOES NOT HAVE SUFFIENT PERMISSIONS?  OR YOU MAY HAVE AN OVERLY AGGRESSIVE ANTIVIRUS PROGRAM. %blue% & ECHO: & ECHO   %yellow% PRESS ANY KEY TO START OVER. %blue% & ECHO: & ECHO: & ECHO:
PAUSE
GOTO :startover

:skipmavenoopsfabric

IF /I !MODLOADER!==QUILT GOTO :enterquilt

:: If Fabric modloader ask user to enter version or Y for newest detected.
:redofabricloader
IF /I !MODLOADER!==FABRIC (
:: Gets the newest release version available from the current maven mavendata file.
FOR /F %%A IN ('powershell -Command "$data = [xml](Get-Content -Path '%HEREPOWERSHELL%\univ-utils\!METADATAFILE!'); $data.metadata.versioning.release"') DO SET FABRICLOADER=%%A
  CLS
  IF NOT EXIST settings-universalator.txt (
  ECHO:%yellow%
  ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ECHO    Welcome to the Universalator - A modded Minecraft server installer / launcher    
  ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%blue%
  ECHO: & ECHO:
  ECHO    %green% Settings can be changed from main menu once all settings have been entered %blue%
    ) ELSE (
        ECHO: & ECHO:
      )
  ECHO: & ECHO: & ECHO: & ECHO:
  ECHO   %yellow% FABRIC LOADER - FABRIC LOADER %blue%
  ECHO:
  ECHO    DO YOU WANT TO USE THE NEWEST PUBLISHED VERSION OF THE FABRIC %yellow% LOADER %blue% FILE? & ECHO:
  ECHO    VERSION %yellow% !FABRICLOADER! %blue%
  ECHO:
  ECHO    UNLESS YOU KNOW A SPECIFIC OLDER FABRIC LOADER IS REQUIRED FOR YOUR MODS - ENTER %green% 'Y' %blue%
  ECHO:
  ECHO   %yellow% FABRIC LOADER - FABRIC LOADER %blue%
  ECHO: & ECHO: & ECHO: & ECHO:
  ECHO    ENTER %green% 'Y' %blue% to use %yellow% !FABRICLOADER! %blue% & ECHO           OR & ECHO          %red% 'N' %blue% to enter a custom version number & ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P "ASKFABRICLOADER="
)
IF /I !ASKFABRICLOADER! NEQ Y IF /I !ASKFABRICLOADER! NEQ N GOTO :redofabricloader
IF /I !ASKFABRICLOADER!==Y GOTO :setjava
IF /I !ASKFABRICLOADER!==N (
  ECHO   %yellow% ENTER A CUSTOM SET FABRIC LOADER VERSION: %blue% & ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P FABRICLOADER=
)
:: Trims off any trailing spaces
IF "!FABRICLOADER:~-1!"==" " CALL :trim "!FABRICLOADER!" FABRICLOADER

:: If custom Fabric Loader was entered check on the maven XML file that it is a valid version
FOR /F %%A IN ('powershell -Command "$data = [xml](Get-Content -Path '%HEREPOWERSHELL%\univ-utils\!METADATAFILE!'); $data.metadata.versioning.versions.version"') DO (
  IF %%A==!FABRICLOADER! GOTO :setjava
)
:: If this point is reached then no valid Fabric Loader version was found on the maven - go to the oops message
GOTO :oopsnovalidfabricqulit

:: If Quilt modloader ask user to enter version or Y for newest detected.
:enterquilt
:: Gets the newest release version available from the current maven mavendata file.
FOR /F %%A IN ('powershell -Command "$data = [xml](Get-Content -Path '%HEREPOWERSHELL%\univ-utils\!METADATAFILE!'); $data.metadata.versioning.release"') DO SET QUILTLOADER=%%A
  :redoenterquilt
  CLS
  IF NOT EXIST settings-universalator.txt (
  ECHO:%yellow%
  ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ECHO    Welcome to the Universalator - A modded Minecraft server installer / launcher    
  ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%blue%
  ECHO: & ECHO:
  ECHO    %green% Settings can be changed from main menu once all settings have been entered %blue%
    ) ELSE (
        ECHO: & ECHO:
      )
  ECHO: & ECHO: & ECHO: & ECHO:
  ECHO   %yellow% QUILT LOADER - QUILT LOADER %blue%
  ECHO:
  ECHO    DO YOU WANT TO USE THE NEWEST PUBLISHED VERSION OF THE QUILT %yellow% LOADER %blue% FILE? & ECHO:
  ECHO    VERSION %green% !QUILTLOADER! %blue%
  ECHO:
  ECHO    UNLESS YOU KNOW A SPECIFIC OLDER FABRIC LOADER IS REQUIRED FOR YOUR MODS - ENTER %green% 'Y' %blue%
  ECHO:
  ECHO   %yellow% QUILT LOADER - QUILT LOADER %blue%
  ECHO: & ECHO: & ECHO: & ECHO:
  ECHO    ENTER %green% 'Y' %blue% to use %green% !QUILTLOADER! %blue% & ECHO           OR & ECHO          %red% 'N' %blue% to enter a custom version number & ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P "ASKQUILTLOADER="

IF /I !ASKQUILTLOADER! NEQ Y IF /I !ASKQUILTLOADER! NEQ N GOTO :redoenterquilt
IF /I !ASKQUILTLOADER!==N (
  ECHO   %yellow% ENTER A CUSTOM SET QUILT LOADER VERSION: %blue% & ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P QUILTLOADER=
)
:: Trims off any trailing spaces
IF "!QUILTLOADER:~-1!"==" " CALL :trim "!QUILTLOADER!" QUILTLOADER

:: If custom Quilt Loader was entered check on the maven XML file that it is a valid version
FOR /F %%A IN ('powershell -Command "$data = [xml](Get-Content -Path '%HEREPOWERSHELL%\univ-utils\!METADATAFILE!'); $data.metadata.versioning.versions.version"') DO (
  IF %%A==!QUILTLOADER! GOTO :setjava
)
:oopsnovalidfabricqulit
:: If this point is reached then no valid Fabric Loader version was found on the maven - go to the oops message
CLS
ECHO: & ECHO: & ECHO: & ECHO: & ECHO: & 
IF !MODLOADER!==FABRIC ECHO   %red% OOPS - THE VERSION OF %yellow% !MODLOADER! %red% ENTERED : %yellow% %FABRICLOADER% %blue%
IF !MODLOADER!==QUILT ECHO   %red% OOPS - THE VERSION OF %yellow% !MODLOADER! %red% ENTERED : %yellow% %QUILTLOADER% %blue%
ECHO: & ECHO   %red% DOES NOT SEEM TO EXIST ON THE !MODLOADER! FILE SERVER %blue% & ECHO:
ECHO   %red% ENTER A DIFFERENT VERSION NUMBER THAT IS KNOWN TO EXIST %blue% & ECHO: & ECHO:
PAUSE
IF !MODLOADER!==FABRIC GOTO :redofabricloader
IF !MODLOADER!==QUILT GOTO :enterquilt

:enterforge
:: BEGIN SETTING VERSION FOR FORGE OR NEOFORGE

:: If a maven metadata file for whichever modloader type is present - test its age.  Set a default value first so that if no file is found the default will be the same as if the file was returned as being old.
SET XMLAGE=True

IF !MODLOADER!==FORGE (
  SET "METADATAFILE=maven-forge-metadata.xml"
  SET "METADATAURL=https://maven.minecraftforge.net/net/minecraftforge/forge/maven-metadata.xml"
)
IF !MODLOADER!==NEOFORGE IF !MINECRAFT!==1.20.1 (
  SET "METADATAFILE=maven-neoforge-1.20.1-metadata.xml"
  SET "METADATAURL=https://maven.neoforged.net/releases/net/neoforged/forge/maven-metadata.xml"
)
IF !MODLOADER!==NEOFORGE IF !MINECRAFT! NEQ 1.20.1 (
  SET "METADATAFILE=maven-neoforge-metadata.xml"
  SET "METADATAURL=https://maven.neoforged.net/releases/net/neoforged/neoforge/maven-metadata.xml"
)

:: Does an age test to see if the file is older than some amount of time.
IF EXIST "%HERE%\univ-utils\!METADATAFILE!" FOR /F %%G IN ('powershell -Command "Test-Path '%HEREPOWERSHELL%\univ-utils\!METADATAFILE!' -OlderThan (Get-Date).AddHours(-2)"') DO SET XMLAGE=%%G
 
:: If XMLAGE is True then a new maven metadata file is obtained.  Any existing is silently deleted.  If the maven is unreachable by ping then no file delete and download is done, so any existing old file is preserved.
IF /I !XMLAGE!==True (
    DEL "%HERE%\univ-utils\!METADATAFILE!" >nul 2>&1
    curl -sLfo "%HERE%\univ-utils\!METADATAFILE!" !METADATAURL! >nul 2>&1
    IF NOT EXIST "%HERE%\univ-utils\!METADATAFILE!"  powershell -Command "(New-Object Net.WebClient).DownloadFile('!METADATAURL!', 'univ-utils\!METADATAFILE!')" >nul
)

:: Skips over the oops message if a maven metadata file was found
IF EXIST "%HERE%\univ-utils\!METADATAFILE!" GOTO :skipmavenoopsforge

:: If script gets here then either no maven metadata file ever existed, or an old file was deleted, and none was obtained from the maven either due to download problems or because the maven is offline.
CLS
ECHO: & ECHO: & ECHO: & ECHO   %red% OOPS %blue% - %yellow% A DOWNLOAD OF THE MAVEN METADATA FILE WAS ATTEMPTED FOR THE %green% !MODLOADER! %yellow% FILE SERVER %blue% & ECHO:
ECHO   %yellow% BUT THE FILE WAS NOT FOUND AFTER THE DOWNLOAD ATTEMPT. %blue%
ECHO   %yellow% MAYBE YOUR WINDOWS USER DOES NOT HAVE SUFFIENT PERMISSIONS?  OR YOU MAY HAVE AN OVERLY AGGRESSIVE ANTIVIRUS PROGRAM. %blue% & ECHO: & ECHO   %yellow% PRESS ANY KEY TO START OVER. %blue% & ECHO: & ECHO: & ECHO:
PAUSE
GOTO :startover

:skipmavenoopsforge
:: Scanning each type of maven metadata file is different.
SET MAVENISSUE=IDK
:: If Forge get newest version available of the selected minecraft version.
IF /I !MODLOADER!==FORGE (
  SET /a idx=0
  SET "ARRAY[!idx!]="
  FOR /F "tokens=1,2 delims=-" %%A IN ('powershell -Command "$data = [xml](Get-Content -Path '%HEREPOWERSHELL%\univ-utils\maven-forge-metadata.xml'); $data.metadata.versioning.versions.version"') DO (
    IF %%A==!MINECRAFT! (
        SET ARRAY[!idx!]=%%B
        SET /a idx+=1
    )
  )
  SET NEWESTFORGE=!ARRAY[0]!
  IF [!ARRAY[0]!] EQU [] SET MAVENISSUE=Y
)

REM If Neoforge get newest version available of the selected minecraft version.
IF /I !MODLOADER!==NEOFORGE (
  SET "NEWESTNEOFORGE="
  REM This is the initial versions maven that Neoforge used - only for MC 1.20.1
  IF !MINECRAFT!==1.20.1 FOR /F "tokens=1,2 delims=-" %%A IN ('powershell -Command "$data = [xml](Get-Content -Path '%HEREPOWERSHELL%\univ-utils\maven-neoforge-1.20.1-metadata.xml'); $data.metadata.versioning.versions.version"') DO (
    IF %%A==!MINECRAFT! (
        SET NEWESTNEOFORGE=%%B
    )
  )
  REM Neoforge changed how they version number their installer files starting with MC 1.20.2 - this is the new system.
  IF !MINECRAFT! NEQ 1.20.1 FOR /F "tokens=1-4 delims=.-" %%A IN ('powershell -Command "$data = [xml](Get-Content -Path '%HEREPOWERSHELL%\univ-utils\maven-neoforge-metadata.xml'); $data.metadata.versioning.versions.version"') DO (
    REM If the current Minecraft version contains a minor version
    IF %%A==!MCMAJOR! IF %%B==!MCMINOR! (
        SET NEWESTNEOFORGE=%%A.%%B.%%C
        IF [%%D] NEQ [] SET NEWESTNEOFORGE=!NEWESTNEOFORGE!-%%D
    )
  )
  REM If looking through the maven xml file results in NEWESTNEOFORGE being blank then it found no matches with the current minecraft version.
  IF [!NEWESTNEOFORGE!] EQU [] SET MAVENISSUE=Y
)

IF !MAVENISSUE!==Y (
  CLS
  ECHO: & ECHO: & ECHO: & ECHO   %red% OOPS %blue% - NO %yellow% !MODLOADER! %blue% VERSIONS WERE FOUND IN THE MAVEN FILE FOR THIS MINECRAFT VERSION %yellow% - !MINECRAFT! %blue% & ECHO:
  ECHO      OR - OR - OR & ECHO: & ECHO   %red% THE MAVEN FILE %blue% IS SOMEHOW INCOMPLETE / CORRUPTED & ECHO: & ECHO: & ECHO: & ECHO: 
  ECHO      %yellow% PRESS ANY KEY TO START OVER AND TRY AGAIN.%blue% & ECHO      THE EXISTING MAVEN METADATA FILE WILL BE DELETED TO GET RE-DOWNLOADED NEXT TRY & ECHO:
  PAUSE
  DEL "%HERE%\univ-utils\!METADATAFILE!" >nul 2>&1

  GOTO :startover
)

:redoenterforge
CLS
IF NOT EXIST settings-universalator.txt (
  ECHO:%yellow%
  ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ECHO    Welcome to the Universalator - A modded Minecraft server installer / launcher    
  ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%blue%
  ECHO: & ECHO:
  ECHO    %green% Settings can be changed from main menu once all settings have been entered %blue%
  ) ELSE (
      ECHO: & ECHO: & ECHO:
    )
  ECHO   %yellow% !MODLOADER! VERSION - !MODLOADER! VERSION %blue% & ECHO:

ECHO     THE NEWEST VERSION OF !MODLOADER! FOR MINECRAFT VERSION !MINECRAFT!
ECHO     WAS DETECTED TO BE:
IF /I !MODLOADER!==FORGE ECHO                      %green% !NEWESTFORGE! %blue%
IF /I !MODLOADER!==NEOFORGE ECHO                      %green% !NEWESTNEOFORGE! %blue%
ECHO:
ECHO     -ENTER %green% 'Y' %blue% TO USE THIS NEWEST VERSION & ECHO: & ECHO      %yellow% OR %blue% & ECHO:
ECHO     -ENTER A VERSION NUMBER TO USE INSTEAD
ECHO        example: 14.23.5.2860
ECHO        example: 47.1.3
ECHO: & ECHO   %yellow% !MODLOADER! VERSION - !MODLOADER! VERSION %blue% & ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P "FROGEENTRY="
IF NOT DEFINED FROGEENTRY GOTO :redoenterforge
:: Skips ahead if Y to select the already found newest version was entered
IF /I !FROGEENTRY!==Y (
  IF !MODLOADER!==FORGE SET FORGE=!NEWESTFORGE!
  IF !MODLOADER!==NEOFORGE SET NEOFORGE=!NEWESTNEOFORGE!
  GOTO :setjava
)
:: Trims off any trailing spaces
IF "!FROGEENTRY:~-1!"==" " CALL :trim "!FROGEENTRY!" FROGEENTRY

:: Checks to see if there were any a-z or A-Z characters in the entry - but only for Forge because Neoforge has some versions with -beta in the name now.
ECHO:
SET FORGEENTRYCHECK=IDK
IF !MODLOADER!==FORGE ECHO !FROGEENTRY! | FINDSTR "[a-z] [A-Z]" && SET FORGEENTRYCHECK=LETTER
 IF !FORGEENTRYCHECK!==IDK (
    IF /I !MODLOADER!==FORGE SET FORGE=!FROGEENTRY!
    IF /I !MODLOADER!==NEOFORGE SET NEOFORGE=!FROGEENTRY!
) ELSE (
  ECHO: & ECHO OOPS NOT A VALID ENTRY MADE - PRESS ANY KEY AND TRY AGAIN & ECHO:
  PAUSE
  GOTO :redoenterforge
)

:: Checks maven metadata file to determine if any manually entered version entered does in fact exist
IF /I !MODLOADER!==FORGE (
  FOR /F "tokens=1,2 delims=-" %%A IN ('powershell -Command "$data = [xml](Get-Content -Path '%HEREPOWERSHELL%\univ-utils\maven-forge-metadata.xml'); $data.metadata.versioning.versions.version"') DO (
    IF %%A==!MINECRAFT! IF %%B==!FROGEENTRY! GOTO :foundvalidforgeversion
    )
)
IF /I !MODLOADER!==NEOFORGE IF !MINECRAFT!==1.20.1 (
  FOR /F "tokens=1,2 delims=-" %%A IN ('powershell -Command "$data = [xml](Get-Content -Path '%HEREPOWERSHELL%\univ-utils\maven-neoforge-1.20.1-metadata.xml'); $data.metadata.versioning.versions.version"') DO (
    IF %%A==!MINECRAFT! IF %%B==!FROGEENTRY! GOTO :foundvalidforgeversion
  )
)

IF /I !MODLOADER!==NEOFORGE IF !MINECRAFT! NEQ 1.20.1 (
  FOR /F "tokens=1-4 delims=.-" %%A IN ('powershell -Command "$data = [xml](Get-Content -Path '%HEREPOWERSHELL%\univ-utils\maven-neoforge-metadata.xml'); $data.metadata.versioning.versions.version"') DO (
    IF [%%D]==[] IF %%A==!MCMAJOR! IF %%B==!MCMINOR! IF !FROGEENTRY!==%%A.%%B.%%C  GOTO :foundvalidforgeversion
    IF [%%D] NEQ [] IF %%A==!MCMAJOR! IF %%B==!MCMINOR! IF !FROGEENTRY!==%%A.%%B.%%C-%%D  GOTO :foundvalidforgeversion
  )
)

:: If no valid version was detected on the maven file server XML list then no skip ahead was done to the foundvalidforgeversion label - display error and go back to enter another version
CLS
ECHO: & ECHO: & ECHO: & ECHO: & ECHO: & 
ECHO   %red% OOPS - THE VERSION OF %yellow% !MODLOADER! %red% ENTERED : %yellow% %MINECRAFT% - %FROGEENTRY% %blue% & ECHO:
ECHO   %red% DOES NOT SEEM TO EXIST ON THE !MODLOADER! FILE SERVER %blue% & ECHO:
ECHO   %red% ENTER A DIFFERENT VERSION NUMBER THAT IS KNOWN TO EXIST FOR YOUR ENTERED MINECRAFT VERSION !MINECRAFT! %blue% & ECHO: & ECHO:
PAUSE
GOTO :redoenterforge

:foundvalidforgeversion

:: Pre-sets Java versions as default set versions in case any funny business happens later
:setjava

IF NOT DEFINED MCMAJOR (
  SET "MCMINOR="
  FOR /F "tokens=2,3 delims=." %%E IN ("!MINECRAFT!") DO SET /a MCMAJOR=%%E & SET /a MCMINOR=%%F >nul 2>&1
  IF NOT DEFINED MCMINOR SET /a MCMINOR=0
)

IF NOT DEFINED MAINMENU ( 
  IF !MCMAJOR! LEQ 15 SET "JAVAVERSION=8" & GOTO :justsetram
  IF !MCMAJOR! LEQ 16 IF !MCMINOR! LEQ 4 SET "JAVAVERSION=8" & GOTO :justsetram
  IF !MCMAJOR! LEQ 16 IF !MCMINOR! GEQ 5 SET "JAVAVERSION=8"
  IF !MCMAJOR!==17 SET "JAVAVERSION=16" & GOTO :justsetram
  IF !MCMAJOR! GEQ 18 SET "JAVAVERSION=17"
  IF !MCMAJOR!==20 IF !MCMINOR! GEQ 6 SET "JAVAVERSION=21" & GOTO :justsetram
  IF !MCMAJOR! GEQ 21 SET "JAVAVERSION=21" & GOTO :justsetram
)

:: Skips java selection screen if settings S is how the script is passing by, for Minecraft versions that only have 1 valid type of java to pick from.
:: If java J is the MAINMENU option, user will still get to the selection screen and see that there is only 1 option.
IF DEFINED MAINMENU IF /I !MAINMENU!==S ( 
  IF !MCMAJOR! LEQ 15 SET "JAVAVERSION=8" & GOTO :justsetram
  IF !MCMAJOR! LEQ 16 IF !MCMINOR! LEQ 4 SET "JAVAVERSION=8" & GOTO :justsetram
  IF !MCMAJOR! LEQ 16 IF !MCMINOR! GEQ 5 SET "JAVAVERSION=8"
  IF !MCMAJOR!==17 SET "JAVAVERSION=16" & GOTO :justsetram
  IF !MCMAJOR! GEQ 18 SET "JAVAVERSION=17"
  IF !MCMAJOR!==20 IF !MCMINOR! GEQ 6 SET "JAVAVERSION=21" & GOTO :justsetram
  IF !MCMAJOR! GEQ 21 SET "JAVAVERSION=21" & GOTO :justsetram
)

:javaselect
CLS
ECHO: & ECHO: & ECHO: & ECHO:
ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
ECHO:
ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
ECHO:
IF !MCMAJOR! LSS 16 ECHO   THE ONLY OPTION FOR MINECRAFT !MINECRAFT! BASED LAUNCHING IS %green% 8 %blue%
IF !MCMAJOR! EQU 16 IF !MCMINOR! LEQ 4 ECHO   THE ONLY OPTION FOR MINECRAFT !MINECRAFT! BASED LAUNCHING IS %green% 8 %blue%
IF !MCMAJOR! EQU 16 IF !MCMINOR! EQU 5 ECHO   THE OPTIONS FOR MINECRAFT !MINECRAFT! BASED LAUNCHING ARE %green% 8 %blue% AND %green% 11 %blue%
IF !MCMAJOR! EQU 17 ECHO   THE ONLY OPTION FOR MINECRAFT !MINECRAFT! BASED LAUNCHING IS %green% 16 %blue%
IF !MCMAJOR! GEQ 18 IF !MCMAJOR! LEQ 19 ECHO   THE OPTIONS FOR MINECRAFT !MINECRAFT! BASED LAUNCHING ARE %green% 17 %blue% AND %green% 21 %blue%
IF !MCMAJOR!==20 IF !MCMINOR! LEQ 5 ECHO   THE OPTIONS FOR MINECRAFT !MINECRAFT! BASED LAUNCHING ARE %green% 17 %blue% AND %green% 21 %blue%
IF !MCMAJOR!==20 IF !MCMINOR! GEQ 6 ECHO   THE ONLY OPTION FOR MINECRAFT !MINECRAFT! BASED LAUNCHING IS %green% 21 %blue%
IF !MCMAJOR! GEQ 21 ECHO   THE ONLY OPTION FOR MINECRAFT !MINECRAFT! BASED LAUNCHING IS %green% 21 %blue%
ECHO:
ECHO   * USING THE NEWER VERSION OPTION IF GIVEN A CHOICE %green% MAY %blue% OR %red% MAY NOT %blue% WORK DEPENDING ON MODS BEING LOADED
ECHO   * IF A SERVER FAILS TO LAUNCH, YOU SHOULD CHANGE BACK TO THE LOWER DEFAULT VERSION^^! & ECHO: & ECHO:
ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P JAVAVERSION=
:: Trims off any trailing spaces
IF "!JAVAVERSION:~-1!"==" " CALL :trim "!JAVAVERSION!" JAVAVERSION

IF !MCMAJOR! LSS 16 IF !JAVAVERSION! NEQ 8 GOTO :javaselect
IF !MCMAJOR! EQU 16 IF !MCMINOR! LEQ 4 IF !JAVAVERSION! NEQ 8 GOTO :javaselect
IF !MCMAJOR! EQU 16 IF !MCMINOR! EQU 5 IF !JAVAVERSION! NEQ 8 IF !JAVAVERSION! NEQ 11 GOTO :javaselect
IF !MCMAJOR! EQU 17 IF !JAVAVERSION! NEQ 16 GOTO :javaselect
IF !MCMAJOR! GEQ 18  IF !MCMAJOR! LEQ 19 IF !JAVAVERSION! NEQ 17 IF !JAVAVERSION! NEQ 21 GOTO :javaselect
IF !MCMAJOR!==20 IF !MCMINOR! LEQ 5  IF !JAVAVERSION! NEQ 17 IF !JAVAVERSION! NEQ 21 GOTO :javaselect
IF !MCMAJOR!==20 IF !MCMINOR! GEQ 6 IF !JAVAVERSION! NEQ 21 GOTO :javaselect
IF !MCMAJOR! GEQ 21 IF !JAVAVERSION! NEQ 21 GOTO :javaselect

IF DEFINED MAINMENU IF /I !MAINMENU!==J (
  CALL :univ_settings_edit JAVAVERSION !JAVAVERSION!
  GOTO :mainmenu
)

:: BEGIN RAM / MEMORY SETTING
:justsetram
:: Uses the systeminfo command to get the total and available/free ram/memory on the computer.
FOR /F "delims=" %%D IN ('systeminfo') DO (
    SET INFO=%%D
    IF "!INFO!" NEQ "!INFO:Total Physical Memory=tot!" SET RAWTOTALRAM=%%D
    IF "!INFO!" NEQ "!INFO:Available Physical Memory=free!" SET RAWFREERAM=%%D
)
FOR /F "tokens=4,5 delims=, " %%E IN ("!RAWTOTALRAM!") DO (
    SET /a TOTALRAM=%%E
    SET AFTERCOMMATOTAL=%%F
    SET /a DECIMALTOTAL=!AFTERCOMMATOTAL:~0,1!
)
FOR /F "tokens=4,5 delims=, " %%E IN ("!RAWFREERAM!") DO (
    SET /a FREERAM=%%E
    SET AFTERCOMMAFREE=%%F
    SET /a DECIMALFREE=!AFTERCOMMAFREE:~0,1!
)
:badramentry
:: Ram / Memory setting amount entry menu
  CLS
  ECHO: & ECHO:
  ECHO %yellow%    Computer Total Total Memory/RAM     %blue% = %yellow% !TOTALRAM!.!DECIMALTOTAL! Gigabytes (GB) %blue%
  ECHO %yellow%    Current Available (Free) Memory/RAM %blue% = %yellow% !FREERAM!.!DECIMALFREE! Gigabytes (GB) %blue%
  ECHO:
  ECHO: & ECHO:
  ECHO: & ECHO: & ECHO: & ECHO:
  ECHO   %yellow% ENTER MAXIMUM RAM / MEMORY THAT THE SERVER WILL RUN - IN GIGABYTES (GB) %blue%
  ECHO:
  ECHO    BE SURE TO USE A VALUE THAT LEAVES AT LEAST SEVERAL GB AVAILABLE IF ALL USED
  ECHO    (Refer to the total and available RAM found above)
  ECHO:
  ECHO    TYPICAL VALUES FOR MODDED MINECRAFT SERVERS ARE BETWEEN 4 AND 10
  ECHO:
  ECHO    ONLY ENTER A WHOLE NUMBER - %red% MUST NOT %blue% INCLUDE ANY LETTERS.
  ECHO    %green% Example - 6 %blue%
  ECHO:
  ECHO   %yellow% ENTER MAXIMUM RAM / MEMORY THAT THE SERVER WILL RUN - IN GIGABYTES (GB) %blue%
  ECHO: & ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P MAXRAMGIGS=
:: Trims off any trailing spaces
IF "!MAXRAMGIGS:~-1!"==" " CALL :trim "!MAXRAMGIGS!" MAXRAMGIGS

:: Checks if there are any decimal points in the entry
IF "!MAXRAMGIGS!" NEQ "!MAXRAMGIGS:.=!" GOTO :badramentry

:: Tests to see if the entered value is an integer or not.  If it is a string and not an integer (letters etc) - trying to set TEST1 as an integer with SET /a will fail.
SET TEST1=w
SET /a TEST1=!MAXRAMGIGS!
IF !MAXRAMGIGS! NEQ !TEST1! GOTO :badramentry

:: Sets the actual MAXRAM variable to launch the server with now that tests have passed.
SET "MAXRAM=-Xmx!MAXRAMGIGS!G"

:: END RAM / MEMORY SETTING

:actuallylaunch

IF /I !MAINMENU!==L SET ASKMODSCHECK=N
IF NOT EXIST settings-universalator.txt (
  SET MAINMENU=S
  SET ASKMODSCHECK=Y
)
:setconfig

IF NOT DEFINED USEPORTFORWARDED SET USEPORTFORWARDED=N
IF NOT DEFINED PROTOCOL SET PROTOCOL=TCP

:: Generates settings-universalator.txt file according to the current settings values.  The first value only having one > overwrites any existing file text with one single line

    ECHO :: To reset this file - delete and run launcher again.>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Minecraft version - example: MINECRAFT=1.18.2>>settings-universalator.txt
    ECHO SET MINECRAFT=!MINECRAFT!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Modloader type - FORGE / NEOFORGE / FABRIC / QUILT / VANILLA>>settings-universalator.txt
    ECHO SET MODLOADER=!MODLOADER!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Enter the version number of the modloader type set above>>settings-universalator.txt
    IF /I !MODLOADER!==FORGE ECHO SET MODLOADERVERSION=!FORGE!>>settings-universalator.txt
    IF /I !MODLOADER!==NEOFORGE ECHO SET MODLOADERVERSION=!NEOFORGE!>>settings-universalator.txt
    IF /I !MODLOADER!==FABRIC ECHO SET MODLOADERVERSION=!FABRICLOADER!>>settings-universalator.txt
    IF /I !MODLOADER!==QUILT ECHO SET MODLOADERVERSION=!QUILTLOADER!>>settings-universalator.txt
    IF /I !MODLOADER!==VANILLA ECHO SET MODLOADERVERSION=>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Java version - do not edit - this is set by the script>>settings-universalator.txt
    ECHO SET JAVAVERSION=!JAVAVERSION!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Ram maximum value in gigabytes - example: 6 >>settings-universalator.txt
    ECHO SET MAXRAMGIGS=!MAXRAMGIGS!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Java additional startup args - DO NOT INCLUDE -Xmx THAT IS ABOVE ENTRY>>settings-universalator.txt
    ECHO SET ARGS=!ARGS!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Whether or not the next settings menu entry done asks to scan for client only mods>>settings-universalator.txt
    ECHO SET ASKMODSCHECK=!ASKMODSCHECK!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: TCP protocol port.  This is the protocol that the game uses>>settings-universalator.txt
    ECHO SET PORT=!PORT!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: UDP protocol port.  This is what some voice chat mods use>>settings-universalator.txt
    ECHO SET PORTUDP=!PORTUDP!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Which types to use for port forwarding using UPNP - only enter TCP, UDP, or BOTH>>settings-universalator.txt
    ECHO SET PROTOCOL=!PROTOCOL!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Whether or not to remember auto port forwarding using UPnP with Portforwarded>>settings-universalator.txt
    ECHO SET USEPORTFORWARDED=!USEPORTFORWARDED!>>settings-universalator.txt


SET "MAXRAM=-Xmx!MAXRAMGIGS!G"
IF /I !MAINMENU!==R GOTO :mainmenu

:: Returns to main menu if asking to scan mods is flagged as done previously once before
:: Otherwise if Y goes to the mod scanning section for each modloader
IF /I !MAINMENU!==S IF NOT EXIST "%HERE%\mods" GOTO :mainmenu
IF /I !MAINMENU!==S IF /I !ASKMODSCHECK!==N GOTO :mainmenu
IF /I !MAINMENU!==S IF /I !ASKMODSCHECK!==Y (
  SET ASKMODSCHECK=N
  GOTO :actuallyscanmods
)

:: Checks to see if the mods folder even exists yet
:nommodsfolder
IF /I !MODLOADER! NEQ VANILLA IF NOT EXIST "%HERE%\mods" (
  CLS
  ECHO: & ECHO: & ECHO: & ECHO:
  ECHO   %yellow% NO 'mods' FOLDER OR NO MOD FILES INSIDE AN EXISTING 'mods' FOLDER WERE DETECTED IN THIS DIRECTORY YET %blue%
  ECHO   %yellow% ARE YOU SURE YOU WANT TO CONTINUE? %blue%
  ECHO: & ECHO:
  ECHO    --- IF "Y" PROGRAM WILL INSTALL CORE SERVER FILES AND LAUNCH BUT THERE ARE NO MODS THAT WILL BE LOADED.
  ECHO:
  ECHO    --- IF "N" PROGRAM WILL RETURN TO MAIN MENU
  ECHO:
  ECHO:
  ECHO   %yellow% TYPE YOUR RESPONSE AND PRESS ENTER: %blue%
  ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  set /P "NEWRESPONSE=" 
  IF /I !NEWRESPONSE! NEQ N IF /I !NEWRESPONSE! NEQ Y GOTO :nommodsfolder
  IF /I !NEWRESPONSE!==N (
    GOTO :mainmenu
  )
)

CLS
ECHO:
REM BEGIN JAVA SETUP SECTION
REM Presets a variable to use as a search string versus java folder names.

:javaupnp

IF !JAVAVERSION!==8 SET FINDFOLDER=jdk8u
IF !JAVAVERSION!==11 SET FINDFOLDER=jdk-11
IF !JAVAVERSION!==16 SET FINDFOLDER=jdk-16
IF !JAVAVERSION!==17 SET FINDFOLDER=jdk-17
IF !JAVAVERSION!==21 SET FINDFOLDER=jdk-21

:checkforjava
IF NOT EXIST "%HERE%\univ-utils\java" MD "%HERE%\univ-utils\java"
ver >nul

FOR /F "delims=" %%A IN ('DIR /B univ-utils\java') DO (
  ECHO "%%A" | FINDSTR "!FINDFOLDER!" >nul
  IF !ERRORLEVEL!==0 (
    SET "JAVAFOLDER=%%A"
    ECHO   Found existing Java !JAVAVERSION! folder - %%A & ECHO:
    ping -n 1 127.0.0.1 >nul
    :: Runs a FOR loop with a powershell command to check the age of the found java folder.  If it's older than 3 months result is 'True'.  If it's newer than 3 months result is 'False'.
    FOR /F %%G IN ('powershell -Command "Test-Path '%HEREPOWERSHELL%\univ-utils\java\%%A' -OlderThan (Get-Date).AddMonths(-2.5)"') DO (
      :: If False then that means the folder is newer than 3 months - go ahead and use that folder for java, then move on!
      IF %%G==False (
        SET "JAVAFILE=univ-utils\java\%%A\bin\java.exe"
        GOTO :javafileisset
      )
      :: If True that means that it is older than 2.5 months old and is marked as OLD and folder value stored for testing vs the current published release later.
      IF %%G==True (
        ECHO   Java folder is older than 3 months - checking for newer available versions for Java !JAVAVERSION! & ECHO:
        ping -n 1 127.0.0.1 >nul
        SET FOUNDJAVA=OLD

        GOTO :javaold
      )
    )
  )
)
:: If script has not skipped ahead by now then a Java folder was not found for the major Java version searched for.
ECHO   Universalator Java folder not found - Getting Java - !JAVAVERSION! - from Adoptium. & ECHO:
%DELAY%

:javaold

:: Skips rest of java setup if a good version is found and set.
IF !FOUNDJAVA!==Y GOTO :javafileisset

:: Java 16 is not a LTS version and never had JRE releases so this is just being set as a variable because of that... Thanks Minecraft 1.17.
IF !JAVAVERSION!==16 SET "IMAGETYPE=jdk"
IF !JAVAVERSION! NEQ 16 SET "IMAGETYPE=jre"

:: If the old flag was put on FOUNDJAVA then test the the folder name of the existing old version found versus what the adoptium API says the newest release is for that Java version.
IF !FOUNDJAVA!==OLD (
  REM Uses the Adoptium URL Api to return the JSON for the parameters specified, and then the FOR loop pulls the last value printed which is that value in the JSON variable that got made.
  REM Java 8 used a bit of a different format for it's version information so a different value is used form the JSON.

  IF !JAVAVERSION!==8 FOR /F %%A IN ('powershell -Command "$data=(((New-Object System.Net.WebClient).DownloadString('https://api.adoptium.net/v3/assets/feature_releases/8/ga?architecture=x64&heap_size=normal&image_type=jre&jvm_impl=hotspot&os=windows&page_size=1&project=jdk&sort_method=DEFAULT&sort_order=DESC&vendor=eclipse') | Out-String | ConvertFrom-Json)); $data.release_name"') DO SET NEWESTJAVA=%%A
  IF !JAVAVERSION! NEQ 8 FOR /F %%A IN ('powershell -Command "$data=(((New-Object System.Net.WebClient).DownloadString('https://api.adoptium.net/v3/assets/feature_releases/!JAVAVERSION!/ga?architecture=x64&heap_size=normal&image_type=!IMAGETYPE!&jvm_impl=hotspot&os=windows&page_size=1&project=jdk&sort_method=DEFAULT&sort_order=DESC&vendor=eclipse') | Out-String | ConvertFrom-Json)); $data.version_data.openjdk_version"') DO SET NEWESTJAVA=%%A

  :: Strips out the extraneous parts of version strings so that just the number remains
  SET "NEWESTJAVANUM=!NEWESTJAVA:-jdk=!"
  SET "NEWESTJAVA=!NEWESTJAVA:jdk-=!"
  SET "NEWESTJAVA=!NEWESTJAVA:-jre=!"
  SET "NEWESTJAVA=!NEWESTJAVA:-LTS=!"

  :: Test if the found newest relaease is found in the folder name then test passes and the JAVAFILE is set to that found.
  ECHO !JAVAFOLDER! | FINDSTR "!NEWESTJAVA!" >nul
  :: If test passes then java folder version is current - use it and move on!
  IF !ERRORLEVEL!==0 (
    ECHO   Java folder !JAVAFOLDER! is in fact the newest version available - using it for Java !JAVAVERSION! & ECHO:
    %DELAY%
    SET "JAVAFILE=%HERE%\univ-utils\java\!JAVAFOLDER!\bin\java.exe"
    GOTO :javafileisset
  ) ELSE (
    :: Removes the old java folder if the test failed and the newest release was not found in the folder name.
    ECHO   Java folder !JAVAFOLDER! is not the newest version available.  & ECHO   Replacing with the newest Java !JAVAVERSION! version from Adoptium^^! & ECHO:
    RD /s /q "%HERE%\univ-utils\java\!JAVAFOLDER!" >nul
  ) 
)

:: At this point Java was either not found or was old with a newer version available as release from Adoptium.
PUSHD "%HERE%\univ-utils\java"

:javaretry
ECHO   Downloading Java !JAVAVERSION! newest version from Adoptium & ECHO:

:: Sets a variable for the URL string to use to use the Adoptium URL Api - it just makes the actual command later easier deal with.
SET "ADOPTIUMDL=https://api.adoptium.net/v3/assets/feature_releases/!JAVAVERSION!/ga?architecture=x64&heap_size=normal&image_type=!IMAGETYPE!&jvm_impl=hotspot&os=windows&page_size=1&project=jdk&sort_method=DEFAULT&sort_order=DESC&vendor=eclipse"
ver >nul
:: Gets the download URL for the newest release binaries ZIP using the URL Api and then in the same powershell command downloads it.  This avoids having to manipulate URL links with % signs in them in the CMD environment which is tricky.
powershell -Command "$data=(((New-Object System.Net.WebClient).DownloadString('!ADOPTIUMDL!') | Out-String | ConvertFrom-Json)); (New-Object Net.WebClient).DownloadFile($data.binaries.package.link, '%HEREPOWERSHELL%\univ-utils\java\javabinaries.zip')"

IF NOT EXIST "%HERE%\univ-utils\java\javabinaries.zip" (
  ECHO: & ECHO: & ECHO   JAVA BINARIES ZIP FILE FAILED TO DOWNLOAD - PRESS ANY KEY TO TRY AGAIN! & ECHO: & ECHO:
  ECHO: & ECHO   Retrying Adoptium Java download... & ping -n 2 127.0.0.1 > nul & ECHO   Retrying  Adoptium Java download.. & ping -n 2 127.0.0.1 > nul & ECHO   Retrying  Adoptium Java download. & ECHO:
  GOTO :javaretry
)

:: Gets the SHA256 checksum hash of the downloaded java binary file using the Adoptium URL Api.
FOR /F %%A IN ('powershell -Command "$data=(((New-Object System.Net.WebClient).DownloadString('https://api.adoptium.net/v3/assets/feature_releases/!JAVAVERSION!/ga?architecture=x64&heap_size=normal&image_type=!IMAGETYPE!&jvm_impl=hotspot&os=windows&page_size=1&project=jdk&sort_method=DEFAULT&sort_order=DESC&vendor=eclipse') | Out-String | ConvertFrom-Json)); $data.binaries.package.checksum"') DO SET JAVACHECKSUM=%%A

:: Compares a checksum of the actual downloaded file to the one obtained above as the correct value to have.
set idx=0 
FOR /F %%F IN ('certutil -hashfile javabinaries.zip SHA256') DO (
  SET OUT[!idx!]=%%F
  SET /a idx+=1
)
SET FILECHECKSUM=!OUT[1]!

:: Checks to see if the calculated checksum hash is the same as stored value above - unzips file if valid
IF !JAVACHECKSUM!==!FILECHECKSUM! (
  tar -xf javabinaries.zip
  DEL javabinaries.zip
  ECHO   The downloaded Java binary and hashfile value match - file downloaded correctly is valid & ECHO:
  %DELAY%
)
IF !JAVACHECKSUM! NEQ !FILECHECKSUM! (
  CLS
  ECHO: & ECHO:
  ECHO   %yellow% THE JAVA INSTALLATION FILE DID NOT DOWNLOAD CORRECTLY - PESS ANY KEY TO TRY AGAIN %blue% & ECHO: & ECHO:
  PAUSE
  DEL javabinaries.zip
)
POPD

REM Sends the script back to the beginning of the java section to check for and set as JAVAFILE the hopefully unzipped new java folder - if passes then comes back to javafileisset
GOTO :checkforjava
:javafileisset

SET "JAVANUM=!JAVAFOLDER:jdk-=!"
SET "JAVANUM=!JAVANUM:-jdk=!"
SET "JAVANUM=!JAVANUM:-jre=!"
SET "JAVANUM=!JAVANUM:-LTS=!"

IF DEFINED GETUPNPJAVA GOTO :returnjavaupnp

:: END JAVA SETUP SECTION

SET "MCMINOR="
FOR /F "tokens=2,3 delims=." %%E IN ("!MINECRAFT!") DO (
    SET /a MCMAJOR=%%E
    SET /a MCMINOR=%%F >nul 2>&1
)
IF NOT DEFINED MCMINOR SET /a MCMINOR=0

:: BEGIN SPLIT BETWEEN SETUP FOR DIFFERENT MODLOADERS - SENDS SCRIPT TO THE NEXT PLACE DEPENDING ON WHICH
IF /I !MODLOADER!==FABRIC GOTO :preparefabric
IF /I !MODLOADER!==QUILT GOTO :preparequilt
IF /I !MODLOADER!==VANILLA GOTO :preparevanilla
:: BEGIN FORGE SPECIFIC SETUP AND LAUNCH
:detectforge

:: Checks to see if the specific JAR file or libraries folder exists for this modloader & version.  If found we'll assume it's installed correctly and move to the foundforge label.
IF /I !MODLOADER!==NEOFORGE IF !MINECRAFT!==1.20.1 IF EXIST libraries/net/neoforged/forge/!MINECRAFT!-!NEOFORGE!/. GOTO :foundforge
IF /I !MODLOADER!==NEOFORGE IF !MINECRAFT! NEQ 1.20.1 IF EXIST libraries/net/neoforged/neoforge/!NEOFORGE!/. GOTO :foundforge

IF /I !MODLOADER!==FORGE (
  REM Sets variables for different file names that different versions of Forge have.
  SET "FORGEFILENAMEORDER=!MINECRAFT!-!FORGE!"
  IF !MCMAJOR! GEQ 7 IF !MCMAJOR! LEQ 9 SET "FORGEFILENAMEORDER=!MINECRAFT!-!FORGE!-!MINECRAFT!"
 
  REM Checks if installation of Forge is detected, different configurations depend on version.  Very old versions just checks for JAR file, old versions both the JAR file and libraries folder, newer style just the libraries folder.
  SET FOUNDFORGEINST=N

  IF !MCMAJOR! LEQ 6 IF EXIST "minecraftforge-universal-!FORGEFILENAMEORDER!.jar" SET FOUNDFORGEINST=Y
  IF !MCMAJOR! GEQ 7 IF !MCMAJOR! LEQ 12 IF EXIST "forge-!FORGEFILENAMEORDER!-universal.jar" SET FOUNDFORGEINST=Y
  IF !MCMAJOR! GEQ 11 IF !MCMAJOR! LEQ 12 IF EXIST "forge-!FORGEFILENAMEORDER!.jar" SET FOUNDFORGEINST=Y
  IF !MCMAJOR! GEQ 13 IF !MCMAJOR! LEQ 16 IF EXIST "forge-!FORGEFILENAMEORDER!.jar" IF EXIST "libraries\net\minecraftforge\forge\!MINECRAFT!-!FORGE!\." SET FOUNDFORGEINST=Y
  IF !MCMAJOR! GEQ 17 IF EXIST "libraries\net\minecraftforge\forge\!MINECRAFT!-!FORGE!\." SET FOUNDFORGEINST=Y

  IF !FOUNDFORGEINST!==Y GOTO :foundforge
)

:: At this point assume the JAR file or libaries folder does not exist and installation is needed.
IF /I !MODLOADER!==FORGE ECHO   Existing Forge !FORGE! files installation not detected. & ECHO:
IF /I !MODLOADER!==NEOFORGE ECHO   Existing Neoforge !NEOFORGE! files installation not detected. & ECHO:
%DELAY%
ECHO   Beginning !MODLOADER! !MODLOADERVERSION! installation & ECHO:
%DELAY%

:: Deletes existing JAR files and libraries folder to prevent mash-up of various versions installing on top of each other, and then moves on
DEL *.jar >nul 2>&1
IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
ECHO   !MODLOADER! !MODLOADERVERSION! server files not found - any existing JAR files and modloader folders deleted for cleanup & ECHO:

:: Downloads the Minecraft server JAR if version is 1.16 and older.  Some old Forge installer files point to dead URL links for this file.  This gets ahead of that and gets the vanilla server JAR first.
:: Sends the script to the vanilla server section to get, then gets returned back here after.
IF !MCMAJOR! LEQ 16 IF EXIST minecraft_server.!MINECRAFT!.jar (
  ECHO   Minecraft server JAR file found! & ECHO:
  %DELAY%
)
IF !MCMAJOR! LEQ 16 IF NOT EXIST minecraft_server.!MINECRAFT!.jar GOTO :getvanillajar
:returnfromgetvanillajar

:pingforgeagain
:: Pings the Forge files server to see it can be reached - decides to ping if forge file not present - accounts for extremely annoyng changes in filenames depending on OLD version names.
ECHO   Pinging !MODLOADER! file server... & ECHO:
IF /I !MODLOADER!==FORGE ping -n 2 maven.minecraftforge.net >nul || ping -n 6 maven.minecraftforge.net >nul
IF /I !MODLOADER!==NEOFORGE ping -n 2 maven.neoforged.net >nul || ping -n 6 maven.neoforged.net >nul
IF %ERRORLEVEL% NEQ 0 (
  CLS
  ECHO:
  ECHO A PING TO THE !MODLOADER! FILE SERVER HAS FAILED
  ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
  ECHO PRESS ANY KEY TO TRY TO PING FILESERVER AGAIN
  PAUSE
  GOTO :pingforgeagain
)

:: Skips ahead if Neoforge instead of Forge
IF /I !MODLOADER!==NEOFORGE GOTO :downloadneoforge

:: Forge detect if specific version folder is present - if not delete all JAR files and 'install' folder to guarantee no files of different versions conflicting on later install.  Then downloads installer file.
IF /I !MODLOADER!==FORGE (
  ECHO   Downloading !MINECRAFT! - Forge - !FORGE! installer file & ECHO:
  %DELAY%
  curl -sLfo forge-installer.jar https://maven.minecraftforge.net/net/minecraftforge/forge/!FORGEFILENAMEORDER!/forge-!FORGEFILENAMEORDER!-installer.jar >nul 2>&1
  IF NOT EXIST forge-installer.jar (
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!FORGEFILENAMEORDER!/forge-!FORGEFILENAMEORDER!-installer.jar', 'forge-installer.jar')" >nul 2>&1
  )
)
:: Downloads the Neoforge installer file if modloader is Neoforge
:downloadneoforge
IF /I !MODLOADER!==NEOFORGE (
  ECHO   Downloading !MINECRAFT! - Neoforge - !NEOFORGE! installer file!
  %DELAY%
  IF !MINECRAFT!==1.20.1 curl -sLfo forge-installer.jar https://maven.neoforged.net/releases/net/neoforged/forge/!MINECRAFT!-!NEOFORGE!/forge-!MINECRAFT!-!NEOFORGE!-installer.jar >nul 2>&1
  IF !MINECRAFT! NEQ 1.20.1 curl -sLfo forge-installer.jar https://maven.neoforged.net/releases/net/neoforged/neoforge/!NEOFORGE!/neoforge-!NEOFORGE!-installer.jar >nul 2>&1
  IF NOT EXIST forge-installer.jar (
    IF !MINECRAFT!==1.20.1 powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.neoforged.net/releases/net/neoforged/forge/!MINECRAFT!-!NEOFORGE!/forge-!MINECRAFT!-!NEOFORGE!-installer.jar', 'forge-installer.jar')" >nul 2>&1
    IF !MINECRAFT! NEQ 1.20.1 powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.neoforged.net/releases/net/neoforged/neoforge/!NEOFORGE!/neoforge-!NEOFORGE!-installer.jar', 'forge-installer.jar')" >nul 2>&1
  )
)

:: Checks if installer file was successfully obtained.  If test not passed then error message and goes back to the pingforgeagain label to try downloading process again.
IF EXIST "%HERE%\forge-installer.jar" GOTO :useforgeinstaller
CLS
ECHO:
ECHO   forge-installer.jar %red% not found or downloaded. %blue% Maybe the Forge servers are having trouble.
ECHO   Please try again in a couple of minutes.
ECHO:
ECHO   %yellow% THIS COULD ALSO MEAN YOU HAVE ENTERED A %red% MINECRAFT OR !MODLOADER! VERSION NUMBER WHICH DOES NOT EXIST %blue%%
ECHO   %yellow% CHECK THE VALUES ENTERED ARE VALID AND EXIST  %blue% & ECHO:
ECHO         MINECRAFT --- !MINECRAFT!
IF /I !MODLOADER!==FORGE ECHO         FORGE ----- !FORGE!
IF /I !MODLOADER!==NEOFORGE ECHO         NEOFORGE ----- !NEOFORGE!
ECHO:
ECHO   Press any key to try to download forge installer file again. & ECHO:
ECHO   If the settings modloader or Minecraft version does not exist - 
ECHO   Close the program and enter new settings. & ECHO: & ECHO:
PAUSE
GOTO :pingforgeagain

:: Runs the Forge/Neoforge installer file to attempt install, then goes to the detectforge label to check if the version JAR file / libaries foler exists.
:useforgeinstaller
IF EXIST forge-installer.jar (
  ECHO   Installer downloaded. Installing... & ECHO:
  %DELAY%
  "%JAVAFILE%" -Djava.net.preferIPv4Stack=true -XX:+UseG1GC -jar forge-installer.jar --installServer
  DEL forge-installer.jar >nul 2>&1
  DEL forge-installer.jar.log >nul 2>&1
  %DELAY%
  CLS
  ECHO: & ECHO   !MODLOADER! !MODLOADERVERSION! Installation complete. Installer file deleted. & ECHO:
  %DELAY%
  GOTO :detectforge

)

:foundforge
IF /I !MODLOADER!==FORGE ECHO   Detected Installed Forge !FORGE!. Moving on... & ECHO:
IF /I !MODLOADER!==NEOFORGE ECHO   Detected Installed Neoforge !NEOFORGE!. Moving on... & ECHO:
%DELAY%

:: Forge was found to exist at this point - delete the not needed script files that newer Forge/Neoforge installs that the Universalator BAT replaces.
IF !MCMAJOR! GEQ 17 (
  DEL "%HERE%\run.*" >nul 2>&1
  IF EXIST "%HERE%\user_jvm_args.txt" DEL "%HERE%\user_jvm_args.txt"
)

:eula
::If eula.txt doens't exist yet user prompted to agree and sets the file automatically to eula=true.  The only entry that gets the user further is 'agree'.
SET GETEULA=N
IF NOT EXIST eula.txt SET GETEULA=Y
IF EXIST eula.txt FOR /F "delims=" %%A IN ('type eula.txt') DO (
  :: Does string substitution using powershell repalce =, which is obnoxious to deal with in pure batch.
  FOR /F "delims=" %%A IN ('powershell -Command "$oldstring ='%%A'; $newstring = $oldstring -replace '=', '#'; $newstring"') DO SET "TEMP=%%A"
  :: Sets GETEULA if found string lines with 'eula' don't also contain true - the vanilla eula.txt file has comments with 'TRUE' instead of 'true' - so this works for any case.
  IF "!TEMP!" NEQ "!TEMP:eula#=x!" IF NOT "!TEMP!" NEQ "!TEMP:eula#true=x!" SET GETEULA=Y
)
IF !GETEULA!==N GOTO :skipeula
%DELAY%
:eulaentry
  CLS
  ECHO: & ECHO:
  ECHO   Mojang's EULA has not yet been accepted. In order to run a Minecraft server, you must accept Mojang's EULA.
  ECHO   Mojang's EULA is available to read at https://account.mojang.com/documents/minecraft_eula
  ECHO:
  ECHO     %yellow% If you agree to Mojang's EULA then type 'AGREE' %blue% & ECHO:
  ECHO     %yellow% ENTER YOUR RESPONSE %blue% & ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P RESPONSE=
  :: Trims off any trailing spaces
  IF "!RESPONSE:~-1!"==" " CALL :trim "!RESPONSE!" RESPONSE

  IF /I !RESPONSE!==AGREE (
    ECHO:
    ECHO   User agreed to Mojang's EULA. & ECHO:
    %DELAY%
    ECHO eula=true> eula.txt
  ) ELSE (
    GOTO :eulaentry
  )
:skipeula

IF /I !MODLOADER!==VANILLA GOTO :launchvanilla
IF /I !MODLOADER!==FABRIC GOTO :eulafabricreturn
IF /I !MODLOADER!==QUILT GOTO :eulaquiltreturn

:: Moves any nuisance client mods that should never be placed on a server - for every launch of any version.
IF EXIST "%HERE%\mods" (
  MOVE "%HERE%\mods\?pti?ine*.jar" "%HERE%\CLIENTMODS\" >nul 2>&1
  MOVE "%HERE%\mods\optifabric*.jar" "%HERE%\CLIENTMODS\" >nul 2>&1
  MOVE "%HERE%\mods\?pti?orge*.jar" "%HERE%\CLIENTMODS\" >nul 2>&1
  MOVE "%HERE%\mods\Essential??orge*.jar" "%HERE%\CLIENTMODS\" >nul 2>&1
  MOVE "%HERE%\mods\Essential??abric*.jar" "%HERE%\CLIENTMODS\" >nul 2>&1
  MOVE "%HERE%\mods\?ssential.jar" "%HERE%\CLIENTMODS\" >nul 2>&1
)

:: If launching L then skip to launching sections
IF /I !MAINMENU!==L IF /I !MODLOADER!==NEOFORGE GOTO :launchneoforge
IF /I !MAINMENU!==L IF /I !MODLOADER!==FORGE GOTO :launchforge
IF /I !MAINMENU!==L IF /I !MODLOADER!==FABRIC GOTO :fabricmain

:: MODULE TO CHECK FOR CLIENT SIDE MODS
:actuallyscanmods

IF NOT EXIST mods (
  CLS
  ECHO: & ECHO: & ECHO: & ECHO   %yellow% CLIENT MOD SCANNING - CLIENT MOD SCANNING %blue% & ECHO: & ECHO:
  ECHO     No folder named 'mods' was found in the directory that the Universalator program was run from! & ECHO:
  ECHO     Either you have forgotten to copy a 'mods' folder to this folder location,
  ECHO     or you did not copy and run this program to the server folder with the server files. & ECHO: & ECHO:
  ECHO   %yellow% CLIENT MOD SCANNING - CLIENT MOD SCANNING %blue% & ECHO: & ECHO: & ECHO:
  PAUSE
  GOTO :mainmenu
)

DIR /b "mods\*.jar" 2>nul | FINDSTR .>nul || (
  CLS
  ECHO: & ECHO: & ECHO: & ECHO   %yellow% CLIENT MOD SCANNING - CLIENT MOD SCANNING %blue% & ECHO: & ECHO:
  ECHO      A folder named 'mods' was found but it is empty! & ECHO: & ECHO:
  ECHO   %yellow% CLIENT MOD SCANNING - CLIENT MOD SCANNING %blue% & ECHO: & ECHO: & ECHO:
  PAUSE
  GOTO :mainmenu
)

SET ASKMODSCHECK=N
  CLS
  ECHO: & ECHO:
  ECHO   %yellow% CLIENT MOD SCANNING - CLIENT MOD SCANNING %blue% & ECHO:
  ECHO:
  ECHO       --MANY CLIENT MODS ARE NOT CODED TO SELF DISABLE ON SERVERS AND MAY CRASH THEM & ECHO:
  ECHO       --THE UNIVERSALATOR SCRIPT CAN SCAN THE MODS FOLDER AND SEE IF ANY ARE PRESENT & ECHO:
  ECHO         For an explanation of how the script scans files - visit the official wiki at:
  ECHO         https://github.com/nanonestor/universalator/wiki
  ECHO:
  ECHO   %yellow% CLIENT MOD SCANNING - CLIENT MOD SCANNING %blue% & ECHO:
  ECHO:
  ECHO      %green% WOULD YOU LIKE TO SCAN THE MODS FOLDER FOR MODS THAT ARE NEEDED ONLY ON CLIENTS? %blue%
  ECHO      %green% FOUND CLIENT MODS CAN BE AUTOMATICALLY MOVED TO A DIFFERENT FOLDER FOR STORAGE. %blue%
  ECHO: & ECHO: & ECHO:
  ECHO             %yellow% Please choose 'Y' or 'N' %blue%
  ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P DOSCAN=
  IF /I !DOSCAN! NEQ N IF /I !DOSCAN! NEQ Y GOTO :actuallyscanmods
  IF /I !DOSCAN!==N GOTO :mainmenu
 
  ECHO: & ECHO   Searching for client only mods... & ECHO: & ECHO   Please wait... & ECHO:
IF NOT EXIST "%HERE%\univ-utils" MD "univ-utils"
  :: Goes to mods folder and gets file names lists.  FINDSTR prints only files with .jar found

:: Creates list of all mod file names.  Sends the working dir to the mods folder and uses a loop and the 'dir' command to create an array list of file names.
:: A For loop is used with delayedexpansion turned off with a funciton called to record each filename because this allows capturing
:: filenames with exclamation marks in the name.  eol=| ensures that filenames with some weird characters aren't ignored.

SET /a SERVERMODSCOUNT=0
PUSHD mods
setlocal enableextensions
setlocal disabledelayedexpansion
 FOR /F "eol=| delims=" %%J IN ('"dir *.jar /b /a-d"') DO (
  IF %%J NEQ [] SET "FILENAME=%%J"
    CALL :functionfilenames
    )
setlocal enabledelayedexpansion
POPD

GOTO :skipfunctionfilenames
:functionfilenames
    SET "SERVERMODS[%SERVERMODSCOUNT%].file=%FILENAME%"
    SET /a SERVERMODSCOUNT+=1
    GOTO :EOF
:skipfunctionfilenames

:: CORRECTS THE MOD COUNT TO NOT INCLUDE THE LAST COUNT NUMBER ADDED
SET /a SERVERMODSCOUNT-=1

:: ACTUALMODSCOUNT is just to set a file count number that starts the count at 1 for the printout progress ECHOs.
SET ACTUALMODSCOUNT=!SERVERMODSCOUNT!
SET /a ACTUALMODSCOUNT+=1


IF /I !MODLOADER!==FABRIC GOTO :scanfabric
IF /I !MODLOADER!==QUILT GOTO :scanfabric

:: BEGIN CLIENT MOD SCANNING FORGE
IF EXIST univ-utils\foundclients.txt DEL univ-utils\foundclients.txt
IF EXIST univ-utils\allmodidsandfiles.txt DEL univ-utils\allmodidsandfiles.txt


  REM Checks to see if clientonlymods.txt exists, if it does check the age and delete to refresh if older than 1 day.  Then downloads file if it does not exist.
  IF EXIST "univ-utils\clientonlymods.txt" (
    FOR /F %%G IN ('powershell -Command "Test-Path '%HEREPOWERSHELL%\univ-utils\clientonlymods.txt' -OlderThan (Get-Date).AddHours(-1)"') DO ( IF %%G==True DEL "univ-utils\clientonlymods.txt" )
  )
  IF NOT EXIST "univ-utils\clientonlymods.txt" powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/nanonestor/utilities/main/clientonlymods.txt', 'univ-utils/clientonlymods.txt')" >nul

  REM Checks if the file is empty.
  IF EXIST "univ-utils\clientonlymods.txt" SET /P EMPTYCHECK=<"univ-utils\clientonlymods.txt"
  IF NOT EXIST "univ-utils\clientonlymods.txt" SET EMPTYCHECK=""
  IF [!EMPTYCHECK!]==[] (
    CLS
    ECHO:
    ECHO:
    ECHO   SOMETHING WENT WRONG DOWNLOADING THE MASTER CLIENT-ONLY LIST FROM THE GITHUB HOSTED LIST
    ECHO   CHECK THAT YOU HAVE NO ANTIVIRUS PROGRAM OR WINDOWS DEFENDER BLOCKING THE DOWNLOAD FROM -
    ECHO:
    ECHO   https://raw.githubusercontent.com/nanonestor/utilities/main/clientonlymods.txt
    ECHO:
    PAUSE & EXIT [\B]
  )

:: If MC version is old (MC <1.12.2) then skips ahead to old mod info file.
IF !MCMAJOR! LEQ 12 GOTO :scanmcmodinfo

:: BEGIN SCANNING NEW STYLE (MC >1.12.2) mods.toml FILES IN MODS

:: Set a variable for which name the mod ID file should be to read.  Neoforge 1.20.4 and older still used mods.toml
IF /I !MODLOADER!==FORGE SET "MODIDFILENAME=mods.toml"
IF /I !MODLOADER!==NEOFORGE SET "MODIDFILENAME=neoforge.mods.toml"
IF /I !MODLOADER!==NEOFORGE IF !MCMAJOR!==20 IF !MCMINOR! LEQ 4 SET "MODIDFILENAME=mods.toml"

:: For each found jar file - uses tar command to output using STDOUT the contents of the mods.toml.  For each line in the STDOUT output the line is checked.
:: First a trigger is needed to determine if the [mods] section has been detected yet in the JSON.  Once that trigger variable has been set to Y then 
:: the script scans to find the modID line.  A fancy function replaces the = sign with _ for easier string comparison to determine if the modID= line was found.
:: This should ensure that no false positives are recorded.

FOR /L %%T IN (0,1,!SERVERMODSCOUNT!) DO (
   SET COUNT=%%T
   SET /a COUNT+=1
   ECHO SCANNING !COUNT!/!ACTUALMODSCOUNT! - !SERVERMODS[%%T].file!
   SET /a MODIDLINE=0
   SET MODID[0]=x
   SET FOUNDMODPLACE=N
   REM Sends the mod ID file to standard output using the tar command in order to set the ERRORLEVEL - actual output and error output silenced
   REM This is for the purpose of confirming that there is actually an ID file inside to be read by setting an errorlevel
   
    tar -xOf "mods\!SERVERMODS[%%T].file!" *\!MODIDFILENAME! >nul 2>&1 && FOR /F "delims=" %%X IN ('tar -xOf "mods\!SERVERMODS[%%T].file!" *\!MODIDFILENAME!') DO (
    SET "TEMP=%%X"

    IF !FOUNDMODPLACE!==Y IF "!TEMP!" NEQ "!TEMP:modId=x!" (
      SET "TEMP=!TEMP: =!"
      SET "TEMP=!TEMP:%TABCHAR%=!"
      SET "TEMP=!TEMP:#mandatory=!"
      SET "TEMP=!TEMP:^==!"
      REM Old replacement function CALL for replacing equals, above is faster.
      REM CALL :l_replace "!TEMP!" "=" ";" "TEMP"
        
      REM Uses special carats to allow using double quotes " as delimiters, to find the modID value. It will probably break all syntax higlighters :)
      FOR /F delims^=^"^ tokens^=2 %%Y IN ("!TEMP!") DO (
      SET "MODID[!MODIDLINE!]=%%Y"
      SET /a MODIDLINE+=1
      SET FOUNDMODPLACE=DONE
    )

  )
  REM Detects if the current line has the [mods] string.  If it does then record to a varaible which will trigger checking for the string modId_ to detect the real modId of this mod file.
  IF "!TEMP!" NEQ "!TEMP:[mods]=x!" SET FOUNDMODPLACE=Y

  REM  Detects if the mod file has a value marking the mod as client side or not, this was added to Forge ID files at some point.
  IF /I "!TEMP!" NEQ "!TEMP:clientSideOnly=x!" IF /I "!TEMP!" NEQ "!TEMP:true=x!" SET SERVERMODS[%%T].clientmarked=Y
  )
  IF DEFINED MODID[0] ( SET "SERVERMODS[%%T].id=!MODID[0]!" ) ELSE ( SET "SERVERMODS[%%T].id=x" )
  
  REM Resets the errorlevel
  ver >nul
  REM Checks to see if the mod is the 'Essential Mod' - which is a jarmod with no regular ID file, so it will never be picked up by the client scan method.
  tar -xOf "mods\!SERVERMODS[%%T].file!" *\essential-loader.properties >nul 2>&1 && ( del "mods\!SERVERMODS[%%T].file!" >nul 2>&1 )
  
)
REM If your syntax highlighter thinks the syntax is broken - the above ) is the real end of the servermods FOR /L loop, because of the special delims handling syntax above.

:: Below skips to finishedscan label skipping the next section which is file scanning for old MC versions (1.12.2 and older).
IF !MCMAJOR! GEQ 13 GOTO :finishedscan


:: END SCANNING NEW STYLE MODS.TOML / NEOFORGE.MODS.TOML
:: BEGIN SCANNING OLD STYLE MCMOD.INFO


:scanmcmodinfo
:: For each found jar file - uses tar command to output using STDOUT the contents of the mods.toml.  For each line in the STDOUT output the line is checked.
:: First a trigger is needed to determine if the [mods] section has been detected yet in the JSON.  Once that trigger variable has been set to Y then 
:: the script scans to find the modID line.  A fancy function replaces the = sign with _ for easier string comparison to determine if the modID= line was found.
:: This should ensure that no false positives are recorded.

FOR /L %%t IN (0,1,!SERVERMODSCOUNT!) DO (
  SET COUNT=%%t
  SET /a COUNT+=1
  ECHO SCANNING !COUNT!/!ACTUALMODSCOUNT! - !SERVERMODS[%%t].file!

  REM Sends the mcmod.info to standard output using the tar command in order to set the ERRORLEVEL - actual output and error output silenced

  tar -xOf "mods\!SERVERMODS[%%t].file!" mcmod.info >nul 2>&1 && FOR /F "delims=" %%X IN ('tar -xOf "mods\!SERVERMODS[%%t].file!" mcmod.info') DO (
    REM Sets a temp variable equal to the current line for processing, and replaces " with ; for easier loop delimiting later.
    SET "TEMP=%%X"
    SET "TEMP=!TEMP:"=;!"
    REM If the line contains the modid then further process line and then set ID equal to the actual modid entry.
    IF "!TEMP!" NEQ "!TEMP:;modid;=x!" (
            SET "TEMP=!TEMP:%TABCHAR%=!"
            SET "TEMP=!TEMP: =!"
            SET "TEMP=!TEMP:[=!"
            SET "TEMP=!TEMP:{=!"
      FOR /F "tokens=3 delims=;" %%Y IN ("!TEMP!") DO (
        SET "SERVERMODS[%%t].id=%%Y"
      )
    )
  )
  REM If ID was found record it to the array entry of the current mod number, otherwise set the ID of that mod equal to a dummy string x.
  IF NOT DEFINED SERVERMODS[%%t].id SET "SERVERMODS[%%t].id=x"
)
:: END SCANNING OLD STYLE MCMOD.INFO
:finishedscan

:: This is it! Checking each server modid versus the client only mods list text file.  Starts with a loop through each server modID found.
SET /a NUMCLIENTS=0
FOR /L %%b IN (0,1,!SERVERMODSCOUNT!) DO (

  REM IF - Looks to see if the mods ID file was labeled by the author as clientSideOnly=true
  REM ELSE - run detection of client mods based on the Universalator curated client mods list.

  IF !SERVERMODS[%%b].clientmarked!==Y (
    SET /a NUMCLIENTS+=1
    SET "FOUNDCLIENTS[!NUMCLIENTS!].id=!SERVERMODS[%%b].id!"
    SET "FOUNDCLIENTS[!NUMCLIENTS!].file=!SERVERMODS[%%b].file!""
  ) ELSE (

    REM Runs a FINDSTR to see if the string of the modID is found on a line.  This needs further checks to guarantee the modID is the entire line and not just part of it.
    
  
    REM If errorlevel is 0 then the FINDSTR above found the modID.  The line returned by the FINDSTR can be captured into a variable by using a FOR loop.
    REM That variable is compared to the server modID in question.  If they are equal then it is a definite match and the modID and filename are recorded to a list of client only mods found.
    FINDSTR /I /C:"!SERVERMODS[%%b].id!" univ-utils\clientonlymods.txt >nul && (
      FOR /F "delims=" %%A IN ('FINDSTR /I /R /C:"!SERVERMODS[%%b].id!" univ-utils\clientonlymods.txt') DO (

        IF /I !SERVERMODS[%%b].id!==%%A (
          SET /a NUMCLIENTS+=1
          SET "FOUNDCLIENTS[!NUMCLIENTS!].id=!SERVERMODS[%%b].id!"
          SET "FOUNDCLIENTS[!NUMCLIENTS!].file=!SERVERMODS[%%b].file!"
        )
      )
    )
  )
)
pause
:: If foundclients.txt isn't found then assume none were found and GOTO section stating none found.
REM IF NOT EXIST univ-utils\foundclients.txt GOTO :noclients
IF !NUMCLIENTS!==0 GOTO :noclients

  :: Prints report to user - showing client mod file names and corresponding modid's.
  CLS
  ECHO:
  ECHO:
  ECHO   %yellow% THE FOLLOWING CLIENT ONLY MODS WERE FOUND %blue%
  ECHO:
  IF !MCMAJOR! LEQ 12 (
  ECHO    *NOTE - IT IS DETECTED THAT YOUR MINECRAFT VERSION STORES ITS ID NUMBER IN THE OLD WAY*
  ECHO     SOME CLIENT ONLY MODS MAY NOT BE DETECTED BY THE SCAN - I.E. MODS THAT DO NOT USE A MCMOD.INFO FILE
  )
  ECHO:
  ECHO    ------------------------------------------------------


:: The purpose of the following code is to echo the modIDs and filenames to view but do so with auto-formatted columns depending on the maximum size of the modID.
:: It determines this first entry column width with a funciton.

:: First iterate through the list to find the length of the longest modID string
SET COLUMNWIDTH=0
FOR /L %%p IN (1,1,!NUMCLIENTS!) DO (
	CALL :GetMaxStringLength COLUMNWIDTH "!FOUNDCLIENTS[%%p].id!"
)
:: The equal sign is followed by 80 spaces and a doublequote
SET "EightySpaces=                                                                                "
FOR /L %%D IN (1,1,!NUMCLIENTS!) DO (
	:: Append 80 spaces after the modID value
	SET "Column=!FOUNDCLIENTS[%%D].id!%EightySpaces%"
	:: Chop at maximum column width, using a FOR loop as a kind of "super delayed" variable expansion
	FOR %%W IN (!COLUMNWIDTH!) DO (
    SET "Column=!Column:~0,%%W!"
  )
  :: Finally echo the actual line for display using the now-length-formatted modID which is now the Column variable.
	ECHO   !Column!  -   !FOUNDCLIENTS[%%D].file!
)


  ECHO    ------------------------------------------------------ & ECHO: & ECHO:
  ECHO   %green% *** DO YOU WANT TO MOVE THESE CLIENT MODS TO A DIFFERENT FOLDER FOR SAFE KEEPING? *** %blue%
  ECHO:
  ECHO         If 'Y' they will NOT be deleted - they WILL be moved to a new folder in the server named %green% CLIENTMODS %blue%
  ECHO         SOME CLIENT MODS ARE NOT CODED TO SELF DISABLE AND WILL CRASH SERVERS IF LEFT IN THE MODS FOLDER
  ECHO: & ECHO:
  ECHO      - IF YOU THINK THE CURRENT MASTER LIST IS INNACURATE OR HAVE FOUND A MOD TO ADD -
  ECHO         PLEASE CONTACT THE LAUNCHER AUTHOR OR
  ECHO         FILE AN ISSUE AT https://github.com/nanonestor/universalator/issues !
  ECHO:
  :typo
  ECHO    ------------------------------------------------------ & ECHO:
  ECHO       %yellow% ENTER YOUR RESPONSE - 'Y' OR 'N' %blue%
  ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P MOVEMODS=
  IF /I !MOVEMODS!==N (
    GOTO :mainmenu
  )
  IF /I !MOVEMODS!==Y (
    IF NOT EXIST "%HERE%\CLIENTMODS" (
      MD CLIENTMODS
    )
  ) ELSE GOTO :typo
  :: Moves files if MOVEMODS is Y.  Checks to see if the value of the array is null for each spot.
  CLS
  ECHO:
  ECHO:
  FOR /L %%L IN (1,1,!NUMCLIENTS!) DO (
    IF DEFINED FOUNDCLIENTS[%%L].file (
      MOVE "%HERE%\mods\!FOUNDCLIENTS[%%L].file!" "%HERE%\CLIENTMODS\!FOUNDCLIENTS[%%L].file!" >nul 2>&1
      ECHO   MOVED - !FOUNDCLIENTS[%%L].file!
  ) ) 
  
  ECHO:
  ECHO      %yellow%   CLIENT MODS MOVED TO THIS FOLDER AS STORAGE:     %blue%
  ECHO      %yellow%   "%HERE%\CLIENTMODS"    %blue%
  ECHO: & ECHO:
  ECHO      %yellow% -PRESS ANY KEY TO CONTINUE- %blue%
  ECHO:
  DEL univ-utils\foundclients.txt >nul 2>&1
  DEL univ-utils\allmodidsandfiles.txt >nul 2>&1
  PAUSE
  
GOTO :mainmenu

:noclients
CLS
ECHO: & ECHO:
ECHO   %yellow% ----------------------------------------- %blue%
ECHO   %yellow%     NO CLIENT ONLY MODS FOUND             %blue%
ECHO   %yellow% ----------------------------------------- %blue%
ECHO:
ECHO    PRESS ANY KEY TO CONTINUE...
ECHO:
DEL univ-utils\foundclients.txt >nul 2>&1
DEL univ-utils\allmodidsandfiles.txt >nul 2>&1
PAUSE
GOTO :mainmenu

:: BEGIN FORGE / NEOFORGE LAUNCH SECTION
:launchforge
:launchneoforge
CLS
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO            %yellow%   Universalator - Server launcher script    %blue%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ & ECHO:
ECHO   %yellow% READY TO LAUNCH !MODLOADER! SERVER! %blue%
ECHO:
ECHO        CURRENT SERVER SETTINGS:
ECHO        MINECRAFT - !MINECRAFT!
IF /I !MODLOADER!==FORGE ECHO        FORGE - !FORGE!
IF /I !MODLOADER!==NEOFORGE ECHO        NEOFORGE - !NEOFORGE!
IF !OVERRIDE!==N ECHO        JAVA - !JAVAVERSION! / Adoptium !JAVANUM!
IF !OVERRIDE!==Y ECHO        JAVA - CUSTOM OVERRIDE
ECHO: & ECHO ============================================
ECHO   %yellow% CURRENT NETWORK SETTINGS:%blue%
ECHO:
ECHO    PUBLIC IPv4 AND PORT      - %green% %PUBLICIP%:%PORT% %blue%
ECHO    LAN IPv4 AND PORT         - %green% !LOCALIP!:%PORT% %blue%
ECHO    TO CONNECT ON SAME PC USE - %green% localhost %blue% ^< This text
ECHO:
ECHO ============================================ & ECHO: & ECHO:
ECHO   %yellow% READY TO LAUNCH FORGE SERVER! %blue%
ECHO:
ECHO            %yellow% ENTER 'M' FOR MAIN MENU %blue%
ECHO            %yellow% ENTER ANY OTHER KEY TO START SERVER LAUNCH %blue%
ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P "FORGELAUNCH="
IF /I !FORGELAUNCH!==M GOTO :mainmenu

ECHO: & ECHO   Launching... & ping -n 2 127.0.0.1 > nul & ECHO   Launching.. & ping -n 2 127.0.0.1 > nul & ECHO   Launching. & ECHO:
:: Starts forge depending on what java version is set.  Only correct combinations will launch - others will crash.

IF !OVERRIDE!==Y SET "JAVAFILE=java"

:: If the ARGS setting has not been changed by the user, use no default args for Java 17+.  Newer Java versions are much better at being self-optimizing than older versions.
:: The user can still totally enter their own custom args if they want!  Or these with literally any tiny number change.
If !JAVAVERSION! GEQ 17 (
  IF "!ARGS!"=="-XX:+UseG1GC -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M" ( SET "USEARGS=" ) ELSE ( SET "USEARGS=!ARGS!" )
) ELSE ( SET "USEARGS=!ARGS!" )
:: Makes a final combined args.
IF DEFINED USEARGS ( SET "USEARGS=!USEARGS! !OTHERARGS!" ) ELSE ( SET "USEARGS=!OTHERARGS!" )

TITLE Universalator %UNIV_VERSION% - !MINECRAFT! !MODLOADER!
ver >nul

:: Launching Forge for MC 1.16 and older.  Each IF EXIST tries to find the launch JAR using the various naming schemes that Forge has used over time.
IF !MCMAJOR! LEQ 16 (
  SET "FORGEFILE="
  IF EXIST "minecraftforge-universal-!MINECRAFT!-!FORGE!.jar" SET "FORGEFILE=minecraftforge-universal-!MINECRAFT!-!FORGE!.jar"
  IF EXIST "forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar" SET "FORGEFILE=forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar"
  If EXIST "forge-!MINECRAFT!-!FORGE!-universal.jar" SET "FORGEFILE=forge-!MINECRAFT!-!FORGE!-universal.jar"
  IF EXIST "forge-!MINECRAFT!-!FORGE!.jar" SET "FORGEFILE=forge-!MINECRAFT!-!FORGE!.jar"

  IF NOT DEFINED FORGEFILE (
    ECHO: & ECHO   %yellow% A FORGE LAUNCH JAR FILE WAS NOT FOUND BY THE SCRIPT %blue% & ECHO:
    PAUSE
    GOTO :mainmenu
  )
  REM Sets the launch line for all MC  1.16 and older
  SET "LAUNCHLINE=!MAXRAM! !USEARGS! -jar !FORGEFILE! nogui"
)
 
:: Launching Minecraft versions 1.17 and newer.  As of 1.20.4 Forge went back to an executable JAR file that gets put in the main directory.
IF !MCMAJOR! GEQ 17 SET LAUNCHFORGE=NEWOLD
IF !MCMAJOR! EQU 20 IF !MCMINOR! GEQ 4 SET LAUNCHFORGE=NEWNEW
IF !MCMAJOR! GEQ 21 SET LAUNCHFORGE=NEWNEW

IF !LAUNCHFORGE!==NEWOLD SET "LAUNCHLINE=!MAXRAM! !USEARGS! @libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/win_args.txt nogui %%*"

IF !LAUNCHFORGE!==NEWNEW SET "LAUNCHLINE=!MAXRAM! !USEARGS! @libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/win_args.txt nogui %%*"

IF /I !MODLOADER!==NEOFORGE (
  IF !MINECRAFT!==1.20.1 SET "LAUNCHLINE=!MAXRAM! !USEARGS! @libraries/net/neoforged/forge/!MINECRAFT!-!NEOFORGE!/win_args.txt nogui %%*"
  IF !MINECRAFT! NEQ 1.20.1 SET "LAUNCHLINE=!MAXRAM! !USEARGS! @libraries/net/neoforged/neoforge/!NEOFORGE!/win_args.txt nogui %%*"
)

REM The launch method depends on whether to use UPNP port forwarding or not.  Strongly tests we really want to do it that way or not.
IF !USEPORTFORWARDED!==Y SET LAUNCH=UPNP
IF NOT EXIST "univ-utils\Portforwarded\Portforwarded.Server.exe" SET LAUNCH=NORMAL
IF !USEPORTFORWARDED!==N SET LAUNCH=NORMAL

IF "!LAUNCH!"=="UPNP" (
  IF /I "!PROTOCOL!"=="TCP" univ-utils\Portforwarded\Portforwarded.Server.exe executable:file="!JAVAFILE!" executable:workingdirectory="!HERE!" executable:parameters="!LAUNCHLINE!" upnp:0:Protocol="Tcp" upnp:0:LocalPort=!PORT! upnp:0:PublicPort=!PORT!
  IF /I "!PROTOCOL!"=="BOTH" univ-utils\Portforwarded\Portforwarded.Server.exe executable:file="!JAVAFILE!" executable:workingdirectory="!HERE!" executable:parameters="!LAUNCHLINE!" upnp:0:Protocol="Tcp" upnp:0:LocalPort=!PORT! upnp:0:PublicPort=!PORT! upnp:1:Protocol="Udp" upnp:1:LocalPort=!PORTUDP! upnp:1:PublicPort=!PORTUDP!
  IF /i "!PROTOCOL!"=="UDP" univ-utils\Portforwarded\Portforwarded.Server.exe executable:file="!JAVAFILE!" executable:workingdirectory="!HERE!" executable:parameters="!LAUNCHLINE!" upnp:1:Protocol="Udp" upnp:1:LocalPort=!PORTUDP! upnp:1:PublicPort=!PORTUDP!
)

REM If not using the UPNP port forwarding, launch the normal way
IF "!LAUNCH!"=="NORMAL" "!JAVAFILE!" !LAUNCHLINE!

REM Resets console color back to Univ colors
color 1E

:: If auto restart is enabled, check if server was purposely shut down or if should restart
IF DEFINED RESTART IF !RESTART!==Y IF EXIST "logs\latest.log" FINDSTR /I "Stopping the server" "logs\latest.log" || (
  SET /a RESARTCOUNT+=1
  IF !RESTARTCOUNT! GEQ 6 GOTO :logsscan
  GOTO :launchneoforge
)

:: Go to common scan logs section
GOTO :logsscan

:: END LAUNCH FORGE / NEOFORGE SECTION

:: BEGIN FABRIC INSTALLATION SECTION
:preparefabric

IF !MCMINOR!==0 SET "FABRICMCNAME=1.!MCMAJOR!"
IF !MCMINOR! NEQ 0 SET "FABRICMCNAME=!MINECRAFT!"

:: Skips installation if already present, if either file is not present then assume a reinstallation is needed.
IF EXIST fabric-server-launch-!FABRICMCNAME!-!FABRICLOADER!.jar IF EXIST "libraries\net\fabricmc\fabric-loader\!FABRICLOADER!\fabric-loader-!FABRICLOADER!.jar" GOTO :launchfabric

:: Deletes existing core files and folders if this specific desired Fabric launch file not present.  This forces a fresh installation and prevents getting a mis-match of various minecraft and/or fabric version files conflicting.
IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
DEL *.jar >nul 2>&1

:: Pings the Fabric file server
:fabricserverpingagain
 ping -n 2 maven.fabricmc.net >nul || ping -n 6 maven.fabricmc.net >nul
IF %ERRORLEVEL% NEQ 0 (
  CLS
  ECHO:
  ECHO A PING TO THE FABRIC FILE SERVER HAS FAILED
  ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
  ECHO PRESS ANY KEY TO TRY AGAIN
  PAUSE
  GOTO :fabricserverpingagain
)

:: Downloads Fabric installer and SHA256 hash value file
IF EXIST fabric-installer.jar DEL fabric-installer.jar
IF EXIST fabric-installer.jar.sha256 DEL fabric-installer.jar.sha256

FOR /F %%A IN ('powershell -Command "$url = 'https://maven.fabricmc.net/net/fabricmc/fabric-installer/maven-metadata.xml'; $data =[xml](New-Object System.Net.WebClient).DownloadString($url); $data.metadata.versioning.release"') DO SET FABRICINSTALLER=%%A
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.fabricmc.net/net/fabricmc/fabric-installer/!FABRICINSTALLER!/fabric-installer-!FABRICINSTALLER!.jar', 'fabric-installer.jar')" >nul
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.fabricmc.net/net/fabricmc/fabric-installer/!FABRICINSTALLER!/fabric-installer-!FABRICINSTALLER!.jar.sha256', 'fabric-installer.jar.sha256')" >nul


:: Sends script execution back if no installer file found.
  IF NOT EXIST fabric-installer.jar (
    ECHO:
    ECHO    Something went wrong downloading the Fabric Installer file.
    ECHO    Press any key to try again.
    PAUSE
    GOTO :preparefabric
  )

:: Sets variable equal to the value in the sha256 file.
IF EXIST fabric-installer.jar.sha256 (
  SET /P INSTALLERVAL=<fabric-installer.jar.sha256
)
set /a idf=0 
IF EXIST fabric-installer.jar (
  for /f %%F  in ('certutil -hashfile fabric-installer.jar SHA256') do (
      set FOUT[!idf!]=%%F
      set /a idf+=1
  )
)
IF EXIST fabric-installer.jar (
SET fabricinstallerhecksum=!FOUT[1]!
) ELSE (
    SET fabricinstallerhecksum=0a
  )

:: Checks to see if the calculated checksum hash is the same as the value from the downloaded SHA256 file value
:: IF yes then install fabric server files
IF EXIST fabric-installer.jar (
    IF /I !INSTALLERVAL!==!fabricinstallerhecksum! (
      "%JAVAFILE%" -XX:+UseG1GC -jar fabric-installer.jar server -loader !FABRICLOADER! -mcversion !FABRICMCNAME! -downloadMinecraft
    ) ELSE (
      DEL fabric-installer.jar
      ECHO:
      ECHO   FABRIC INSTALLER FILE CHECKSUM VALUE DID NOT MATCH THE CHECKSUM IT WAS SUPPOSED TO BE
      ECHO   THIS LIKELY MEANS A CORRUPTED DOWNLOAD.
      ECHO:
      ECHO   PRESS ANY KEY TO TRY DOWNLOADING AGAIN!
      PAUSE
      GOTO :preparefabric
    )
)
IF EXIST fabric-installer.jar DEL fabric-installer.jar
IF EXIST fabric-installer.jar.sha256 DEL fabric-installer.jar.sha256
IF EXIST fabric-server-launch.jar (
  RENAME fabric-server-launch.jar fabric-server-launch-!FABRICMCNAME!-!FABRICLOADER!.jar
)

:: Go to eula checking
GOTO :eula
:eulafabricreturn

IF EXIST fabric-server-launch-!FABRICMCNAME!-!FABRICLOADER!.jar (
  GOTO :launchfabric 
) ELSE (
  GOTO :preparefabric
)
:: END FABRIC INSTALLATION SECTION

:: BEGIN QUILT INSTALLATION SECTION
:preparequilt

IF !MCMINOR!==0 SET "QUILTMCNAME=1.!MCMAJOR!"
IF !MCMINOR! NEQ 0 SET "QUILTMCNAME=!MINECRAFT!"

:: Skips installation if already present
IF EXIST quilt-server-launch-!QUILTMCNAME!-!QUILTLOADER!.jar IF EXIST "libraries\org\quiltmc\quilt-loader\!QUILTLOADER!\quilt-loader-!QUILTLOADER!.jar" GOTO :launchquilt

:: Deletes existing core files and folders if this specific desired Fabric launch file not present.  This forces a fresh installation and prevents getting a mis-match of various minecraft and/or fabric version files conflicting.
IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
DEL *.jar >nul 2>&1

:: Pings the Quilt file server
:quiltserverpingagain
 ping -n 2 maven.quiltmc.org >nul || ping -n 6 maven.quiltmc.org >nul
IF %ERRORLEVEL% NEQ 0 (
  CLS
  ECHO:
  ECHO A PING TO THE QUILT FILE SERVER HAS FAILED
  ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
  ECHO PRESS ANY KEY TO TRY AGAIN
  PAUSE
  GOTO :quiltserverpingagain
)

:: Downloads Quilt installer and SHA256 hash value file
IF EXIST quilt-installer.jar DEL quilt-installer.jar
IF EXIST quilt-installer.jar.sha256 DEL quilt-installer.jar.sha256

FOR /F %%A IN ('powershell -Command "$url = 'https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml'; $data =[xml](New-Object System.Net.WebClient).DownloadString($url); $data.metadata.versioning.release"') DO SET QUILTINSTALLER=%%A
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/!QUILTINSTALLER!/quilt-installer-!QUILTINSTALLER!.jar', 'quilt-installer.jar')" >nul
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/!QUILTINSTALLER!/quilt-installer-!QUILTINSTALLER!.jar.sha256', 'quilt-installer.jar.sha256')" >nul


:: Sends script execution back if no installer file found.
  IF NOT EXIST quilt-installer.jar (
    ECHO:
    ECHO    Something went wrong downloading the Quilt Installer file.
    ECHO    Press any key to try again.
    PAUSE
    GOTO :preparequilt
  )

:: Sets variable equal to the value in the sha256 file.
IF EXIST quilt-installer.jar.sha256 (
  SET /P INSTALLERVAL=<quilt-installer.jar.sha256
)
set /a idf=0 
IF EXIST quilt-installer.jar (
  FOR /F %%F  IN ('certutil -hashfile quilt-installer.jar SHA256') DO (
      set FOUT[!idf!]=%%F
      set /a idf+=1
  )
  set quiltinstallerhecksum=!FOUT[1]!
) ELSE (
    set quiltinstallerhecksum=0a
)

:: Checks to see if the calculated checksum hash is the same as the value from the downloaded SHA256 file value
:: IF yes then install quilt server files
IF "%HERE%" NEQ "%HERE: =%" (
  CLS
  ECHO: & ECHO:
  ECHO   UH OH - THE QUILT INSTALL COMMAND DOES NOT LIKE FOLDER PATH LOCATIONS WITH BLANK SPACES IN ANY OF THE FOLDER NAMES.
  ECHO: & ECHO   MOVE THE SERVER FOLDER TO SOME FOLDER LOCATION WITH NO SPACES IN THE FOLDER NAMES.
  ECHO   OR CHANGE THE FOLDER NAMES TO REMOVE BLANK SPACES
  ECHO: & ECHO:
  PAUSE
  GOTO :mainmenu
)
IF EXIST quilt-installer.jar (
    IF /I !INSTALLERVAL!==!quiltinstallerhecksum! (
      "%JAVAFILE%" -XX:+UseG1GC -jar quilt-installer.jar install server !QUILTMCNAME! !QUILTLOADER! --download-server --install-dir=%cd%
    ) ELSE (
      DEL quilt-installer.jar
      ECHO:
      ECHO   QUILT INSTALLER FILE CHECKSUM VALUE DID NOT MATCH THE CHECKSUM IT WAS SUPPOSED TO BE
      ECHO   THIS LIKELY MEANS A CORRUPTED DOWNLOAD.
      ECHO:
      ECHO   PRESS ANY KEY TO TRY DOWNLOADING AGAIN!
      PAUSE
      GOTO :preparequilt
    )
)

IF EXIST quilt-installer.jar DEL quilt-installer.jar
IF EXIST quilt-installer.jar.sha256 DEL quilt-installer.jar.sha256
IF EXIST quilt-server-launch.jar (
  RENAME quilt-server-launch.jar quilt-server-launch-!QUILTMCNAME!-!QUILTLOADER!.jar
)

:: Go to eula checking
GOTO :eula
:eulaquiltreturn

IF EXIST quilt-server-launch-!QUILTMCNAME!-!QUILTLOADER!.jar GOTO :launchquilt
GOTO :preparequilt

:: END QUILT INSTALLATION SECTION

:: BEGIN FABRIC client only mods scanning section
:scanfabric

ECHO:

:: This variable is for a trigger to determine at the end if any client mods at all were found.
SET FOUNDFABRICCLIENTS=N
 
REM The powershell line before changing it to not require double quotes in the string
REM $files = Get-ChildItem -Path .\mods -Filter *.jar; foreach ($f in $files) { try { $content = tar xOf $f.FullName '*fabric.mod.json' 2>null | Out-String; if ([string]::IsNullOrWhiteSpace($content)) { throw 'No fabric.mod.json' }; $json = $content | ConvertFrom-Json; $id = if ($json.id) { $json.id } else { 'x' }; $env = if ($json.environment) { $json.environment } else { 'x' }; $deps = if ($json.depends) { ($json.depends | Get-Member -MemberType NoteProperty).Name -join '#' } else { 'x' }; "$($f.Name);$id;$env;$deps" } catch { "$($f.Name);x;x;x" }}"

REM The working powershell command which returns a ; delimited list, so A,B,C,D for filename, modID, environment, depends
REM FOR /F "delims=" %%A IN ('powershell -Command "$files = Get-ChildItem -Path .\mods -Filter *.jar; foreach ($f in $files) { try { $content = tar xOf $f.FullName *fabric.mod.json 2>null | Out-String; if ([string]::IsNullOrWhiteSpace($content)) { throw 'No fabric.mod.json' }; $json = $content | ConvertFrom-Json; $id = if ($json.id) { $json.id } else { 'x' }; $env = if ($json.environment) { $json.environment } else { 'x' }; $deps = if ($json.depends) { ($json.depends | Get-Member -MemberType NoteProperty).Name -join '#' } else { 'x' }; [string]::Concat($f.Name, ';', $id, ';', $env, ';', $deps) } catch { [string]::Concat($f.Name, ';x;x;x') }}"') DO ( ECHO %%A>>list.txt )
REM FOR /F "delims=" %%A IN ('powershell -Command "$files = Get-ChildItem -Path .\mods -Filter *.jar; foreach ($f in $files) { try { $content = tar xOf $f.FullName *fabric.mod.json 2>null | Out-String; if ([string]::IsNullOrWhiteSpace($content)) { throw 'No fabric.mod.json' }; $json = $content | ConvertFrom-Json; $id = if ($json.id) { $json.id } else { 'x' }; $env = if ($json.environment) { $json.environment } else { 'x' }; $deps = if ($json.depends) { ($json.depends | Get-Member -MemberType NoteProperty).Name -join '#' } else { 'x' }; [string]::Concat($f.Name, ';', $id, ';', $env, ';', $deps) } catch { [string]::Concat($f.Name, ';x;x;x') }}"') DO ECHO %%A

REM Works - *IF* mods actually have fabric.mod.json inside :)
REM FOR /F "tokens=1-5 delims=;" %A IN ('powershell -Command "$i=1; $files = Get-ChildItem -Path .\mods -Filter *.jar; foreach ($f in $files) { try { $content = (tar xOf $f.FullName '*fabric.mod.json' 2>$null); if (-not $content) { throw 'No fabric.mod.json' }; $json = ($content | Out-String | ConvertFrom-Json); if (-not $json) { throw 'Invalid JSON' }; $id = if ($json.id) { $json.id } else { 'x' }; $env = if ($json.environment) { $json.environment } else { 'x' }; $deps = if ($json.depends) { ($json.depends | Get-Member -MemberType NoteProperty).Name -join '#' } else { 'x' }; [string]::Concat($f.Name, ';', $id, ';', $env, ';', $deps, ';', $i++)} catch { [string]::Concat($f.Name, ';x;x;x;', $i++) }}"') DO ( ECHO %A & ECHO %B & ECHO %C & ECHO %D & ECHO %E )

REM Working line above, but changed to set variables
IF !MODLOADER!==FABRIC FOR /F "tokens=1-5 delims=;" %%A IN ('powershell -Command "$i=0; $files = Get-ChildItem -Path .\mods -Filter *.jar; foreach ($f in $files) { try { $content = (tar xOf $f.FullName '*fabric.mod.json' 2>$null); if (-not $content) { throw 'No fabric.mod.json' }; $json = ($content | Out-String | ConvertFrom-Json); if (-not $json) { throw 'Invalid JSON' }; $id = if ($json.id) { $json.id } else { 'x' }; $env = if ($json.environment) { $json.environment } else { 'x' }; $deps = if ($json.depends) { ($json.depends | Get-Member -MemberType NoteProperty).Name -join '#' } else { 'x' }; [string]::Concat($f.Name, ';', $id, ';', $env, ';', $deps, ';', $i++)} catch { [string]::Concat($f.Name, ';x;x;x;', $i++) }}"') DO ( SET SERVERMODS[%%E].file=%%A & SET SERVERMODS[%%E].id=%%B & SET SERVERMODS[%%E].environ=%%C & SET SERVERMODS[%%E].deps=%%D )

IF !MODLOADER!==QUILT FOR /F "tokens=1-5 delims=;" %%A IN ('powershell -Command "$i=0; $files = Get-ChildItem -Path .\mods -Filter *.jar; foreach ($f in $files) { try { $content = (tar xOf $f.FullName '*quilt.mod.json' 2>$null); if (-not $content) { $content = (tar xOf $f.FullName '*fabric.mod.json' 2>$null) }; if (-not $content) { throw 'No mod json found' }; $json = ($content | Out-String | ConvertFrom-Json); if (-not $json) { throw 'Invalid JSON' }; $id = if ($json.id) { $json.id } else { 'x' }; $env = if ($json.environment) { $json.environment } else { 'x' }; $deps = if ($json.depends) { ($json.depends | Get-Member -MemberType NoteProperty).Name -join '#' } else { 'x' }; [string]::Concat($f.Name, ';', $id, ';', $env, ';', $deps, ';', $i++)} catch { [string]::Concat($f.Name, ';x;x;x;', $i++) }}"') DO ( SET SERVERMODS[%%E].file=%%A & SET SERVERMODS[%%E].id=%%B & SET SERVERMODS[%%E].environ=%%C & SET SERVERMODS[%%E].deps=%%D )

:: Loops through each number up to the total mods count, sanitizes the saved variable contents by removing spaces, triggers FOUNDFABRICCLIENTS if any mod has client environ
FOR /L %%f IN (0,1,!SERVERMODSCOUNT!) DO (
  SET "SERVERMODS[%%f].id=!SERVERMODS[%%f].id: =!"
  SET "SERVERMODS[%%f].environ=!SERVERMODS[%%f].environ: =!"
  SET "SERVERMODS[%%f].deps=!SERVERMODS[%%f].deps: =!"
  IF /I !SERVERMODS[%%f].environ!==client SET FOUNDFABRICCLIENTS=Y
)

REM Goes to the no clients found message.  If any environment client mods were found this trigger variable will be Y instead.
IF !FOUNDFABRICCLIENTS!==N GOTO :noclientsfabric

ECHO: & ECHO   Cross-checking found client-side mods with all required dependency mods... .. . & ECHO:

:: Makes a txt file to use for cross-referencing.
:: Using a FINDSTR on the txt file vs looping through all variables is at least 2 orders of magnitude faster.  And combining together all .deps variables could be greater than the max variable character limit...
ECHO fabricdeps>fabricdeps.txt
FOR /L %%A IN (0,1,!SERVERMODSCOUNT!) DO (
  IF "!SERVERMODS[%%A].deps!" NEQ "x" ECHO #!SERVERMODS[%%A].deps!#>>fabricdeps.txt
)

:: Loops through each modID and checks to see if its needed by another mod in the fabricdeps.txt.  Searching the modID surrounded in semicolons guarantees it only matches that exact ID.
SET /a CLIENTSCOUNT=0
FOR /L %%r IN (0,1,!SERVERMODSCOUNT!) DO (
  REM If the mod is tagged as client enrironment
  IF /I "!SERVERMODS[%%r].environ!"=="client" (

    FINDSTR "#!SERVERMODS[%%r].id!#" "fabricdeps.txt" >nul 2>&1 || SET INCLUDE=Y

    REM If set to include, add the mod to the list of mods that can be safely removed with no other mod requiring it as dependency.
    IF !INCLUDE!==Y (
      SET "FABRICCLIENTS[!CLIENTSCOUNT!].file=!SERVERMODS[%%r].file!"
      SET "FABRICCLIENTS[!CLIENTSCOUNT!].id=!SERVERMODS[%%r].id!"
      SET /a CLIENTSCOUNT+=1
    )
  )
)

DEL fabricdeps.txt >nul 2>&1

  :: Prints report to user - echos all entries without the modID name = forge
  CLS
  ECHO:
  ECHO:
  ECHO   %yellow% THE FOLLOWING FABRIC - CLIENT MARKED MODS WERE FOUND %blue%
  ECHO:
  ECHO    ------------------------------------------------------

:: The purpose of the following code is to echo the modIDs and filenames to view but do so with auto-formatted columns depending on the maximum size of the modID.
:: It determines this first entry column width with a funciton.

:: First iterate through the list to find the length of the longest modID string
SET COLUMNWIDTH=0
FOR /L %%p IN (0,1,!CLIENTSCOUNT!) DO (
  IF /I "!FABRICCLIENTS[%%p].file!" NEQ "" CALL :GetMaxStringLength COLUMNWIDTH "!FABRICCLIENTS[%%p].id!"
)

:: The equal sign is followed by 80 spaces and a doublequote
SET "EightySpaces=                                                                                "
FOR /L %%D IN (0,1,!CLIENTSCOUNT!) DO (
  :: Append 80 spaces after the modID value
  SET "Column=!FABRICCLIENTS[%%D].id!%EightySpaces%"
  :: Chop at maximum column width, using a FOR loop as a kind of "super delayed" variable expansion
  FOR %%W IN (!COLUMNWIDTH!) DO (
    SET "Column=!Column:~0,%%W!"
  )
  :: Finally echo the actual line for display using the now-length-formatted modID which is now the Column variable.
  IF "!FABRICCLIENTS[%%D].file!" NEQ "" ECHO   !Column!  -   !FABRICCLIENTS[%%D].file!
)

  ECHO    ------------------------------------------------------ & ECHO: & ECHO:
  ECHO   %green% *** DO YOU WANT TO MOVE THESE CLIENT MODS TO A DIFFERENT FOLDER FOR SAFE KEEPING? *** %blue%
  ECHO:
  ECHO         If 'Y' they will NOT be deleted - they WILL be moved to a new folder in the server named %green% CLIENTMODS %blue%
  ECHO         SOME CLIENT MODS ARE NOT CODED TO SELF DISABLE AND WILL CRASH SERVERS IF LEFT IN THE MODS FOLDER
  ECHO:
  :typo
  ECHO:
  ECHO    ------------------------------------------------------ & ECHO:
  ECHO       %yellow% ENTER YOUR RESPONSE - 'Y' OR 'N' %blue%
  ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P MOVEMODS=
  IF /I !MOVEMODS!==N GOTO :mainmenu
  IF /I !MOVEMODS!==Y (
    IF NOT EXIST "%HERE%\CLIENTMODS" (
      MD CLIENTMODS
    )
  ) ELSE GOTO :typo
  :: Moves files if MOVEMODS is Y.  Checks to see if the value of the array is null for each spot.
  CLS
  ECHO:
  ECHO:
  FOR /L %%L IN (0,1,!CLIENTSCOUNT!) DO (
    IF DEFINED FABRICCLIENTS[%%L].file (
      MOVE "%HERE%\mods\!FABRICCLIENTS[%%L].file!" "%HERE%\CLIENTMODS\!FABRICCLIENTS[%%L].file!" >nul 2>&1
      ECHO   MOVED - !FABRICCLIENTS[%%L].file!
    )
  )
  ECHO:
  ECHO      %yellow%   CLIENT MODS MOVED TO THIS FOLDER AS STORAGE:     %blue%
  ECHO      %yellow%   "%HERE%\CLIENTMODS" %blue%
  ECHO:
  ECHO:
  ECHO      %yellow% -PRESS ANY KEY TO CONTINUE- %blue%
  ECHO:
  PAUSE
  GOTO :mainmenu

:noclientsfabric
CLS
ECHO:
ECHO:
ECHO   %yellow% ----------------------------------------- %blue%
ECHO   %yellow%     NO CLIENT ONLY MODS FOUND             %blue%
ECHO   %yellow% ----------------------------------------- %blue%
ECHO:
ECHO    PRESS ANY KEY TO CONTINUE...
ECHO:
PAUSE
GOTO :mainmenu

:: END FABRIC CLIENT ONLY MODS SCANNING

:: BEGIN VANILLA INSTALLATION SECTION

:preparevanilla
:: Downloads the Minecraft server JAR if version is 1.16 and older.  Some old Forge installer files point to dead URL links for this file.  This gets ahead of that and gets the vanilla server JAR first.

IF EXIST minecraft_server.!MINECRAFT!.jar (
  ECHO   Minecraft !MINECRAFT! server JAR found. & ECHO:
  %DELAY%
  GOTO :skipvanillainstall
)
:getvanillajar
ECHO   Minecraft server JAR not found - attempting to download from Mojang servers & ECHO:
%DELAY%

:: As of May 17th 2024 it seems like Mojang may have ICMP blocked pinging the mojang server locations, so ping checks are currently disabled.
:: Tries to ping the Mojang file server to check that it is online and responding
:: SET /a pingmojang=1
:: :pingmojangagain

:: ECHO   Pinging Mojang file server - Attempt # !pingmojang! ... & ECHO:
:: SET PINGMOJANG=IDK
:: ping -n 2 launchermeta.mojang.com >nul || ping -n 6 launchermeta.mojang.com >nul || SET PINGMOJANG=F
:: ping -n 2 piston-meta.mojang.com >nul || ping -n 6 piston-meta.mojang.com >nul || SET PINGMOJANG=F
:: IF !PINGMOJANG!==F (
::   SET pingmojang+=1
::   CLS
::   ECHO:
::   ECHO A PING TO THE MOJANG FILE SERVER HAS FAILED
::   ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
::   ECHO PRESS ANY KEY TO TRY TO PING FILESERVER AGAIN
::   PAUSE
::   GOTO :pingmojangagain
:: )

ECHO   Downloading Minecraft server JAR file... .. . & ECHO:

:getmcmanifest
:upnpgetjar
:: Tests for whether to download missing manifest file
SET GETMANIFEST=U
IF NOT EXIST "univ-utils\version_manifest_v2.json" SET GETMANIFEST=Y
:: If the manifest file already exists then evaluate whether it's older than the set age - delete/reinstall if older than
IF EXIST "univ-utils\version_manifest_v2.json" (
  FOR /F %%G IN ('powershell -Command "Test-Path '%HERE%\univ-utils\version_manifest_v2.json' -OlderThan (Get-Date).AddDays(-1)"') DO (
    IF %%G==True (
      DEL "univ-utils\version_manifest_v2.json"
      SET GETMANIFEST=Y
    )
  )
)
IF !GETMANIFEST!==Y (
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://launchermeta.mojang.com/mc/game/version_manifest_v2.json', 'univ-utils\version_manifest_v2.json')" >nul
  :: If the download failed to get a file then try again.  Only do this part if settings file exists - skips this if this is the first time running with no settings.  Just fail gracefully.
  IF NOT EXIST "univ-utils\version_manifest_v2.json" IF EXIST settings-universalator.txt (
    ECHO: & ECHO   OOPS - THE MINECRAFT VERSION MANIFEST FILE FAILED TO DOWNLOAD & ECHO: & ECHO   PRESS ANY KEY TO TRY DOWNLOADING AGAIN & ECHO: & ECHO:
    PAUSE
    GOTO :preparevanilla
  )
)
IF DEFINED SMODE IF !SMODE!==SETTINGS GOTO :backmcmanifest

:: Tests if the version.json file needs to be obtained
IF NOT EXIST "univ-utils\versions" MD "univ-utils\versions"
IF NOT EXIST "univ-utils\versions\!MINECRAFT!.json" (
  :: Uses powershell to get the version file URL from the version manifest JSON file
  FOR /F "delims=" %%A IN ('powershell -Command "$data=(Get-Content -Raw -Path 'univ-utils/version_manifest_v2.json' | Out-String | ConvertFrom-Json); $stuff=($data.versions | Where-Object -Property id -Value !MINECRAFT! -EQ); $stuff.url"') DO SET "MCVERSIONURL=%%A"
  ver >nul
  powershell -Command "(New-Object Net.WebClient).DownloadFile('!MCVERSIONURL!', 'univ-utils\versions\!MINECRAFT!.json')" >nul
)

:: Gets the JAR download URL and checksum value from the version.json file
FOR /F "delims=" %%A IN ('powershell -Command "$data=(Get-Content -Raw -Path '%HEREPOWERSHELL%\univ-utils/versions/!MINECRAFT!.json' | Out-String | ConvertFrom-Json); $data.downloads.server.url"') DO SET "MCJARURL=%%A"
FOR /F "delims=" %%A IN ('powershell -Command "$data=(Get-Content -Raw -Path '%HEREPOWERSHELL%\univ-utils/versions/!MINECRAFT!.json' | Out-String | ConvertFrom-Json); $data.downloads.server.sha1"') DO SET "MCJARCHECKSUM=%%A"

:: Downloads the vanilla Minecraft server JAR from the Mojang file server, using the obtained MCJARURL
powershell -Command "(New-Object Net.WebClient).DownloadFile('!MCJARURL!', 'minecraft_server.!MINECRAFT!.jar')" >nul

:: If the download failed to get a file then try again
IF NOT EXIST minecraft_server.!MINECRAFT!.jar (
  ECHO: & ECHO   OOPS - THE MINECRAFT SERVER JAR FAILED TO DOWNLOAD & ECHO: & ECHO   PRESS ANY KEY TO TRY DOWNLOADING AGAIN & ECHO: & ECHO:
  PAUSE
  GOTO :preparevanilla
)

:: Gets the SHA1 checksum for the downloaded server JAR.
SET /a idm=0 
FOR /F %%F  IN ('certutil -hashfile minecraft_server.!MINECRAFT!.jar SHA1') DO (
      SET SHA1VAL[!idm!]=%%F
      SET /a idm+=1
)
SET SERVERJARSHA1=!SHA1VAL[1]!
  
:: Checks to see if the calculated checksum is the same as the value specified from Mojang information
IF !MCJARCHECKSUM! NEQ !SERVERJARSHA1! (
  DEL minecraft_server.!MINECRAFT!.jar
  ECHO: & ECHO: & ECHO:
  ECHO   THE MINECRAFT SERVER JAR FILE CHECKSUM VALUE DID NOT MATCH THE CHECKSUM IT WAS SUPPOSED TO BE
  ECHO   THIS LIKELY MEANS A CORRUPTED DOWNLOAD.
  ECHO:
  ECHO   PRESS ANY KEY TO TRY DOWNLOADING AGAIN! & ECHO: & ECHO:
  PAUSE
  GOTO :preparevanilla
)

IF DEFINED UPNPGETMCJAR GOTO :returnupnpgetjar

ECHO   Checksum values of downloaded server JAR and expected value match - file is valid & ECHO:
%DELAY%
IF /I !MODLOADER!==FORGE GOTO :returnfromgetvanillajar
IF /I !MODLOADER!==NEOFORGE GOTO :returnfromgetvanillajar

:skipvanillainstall
:: Goes to the EULA section, after that it goes directly to the launchvanilla label
GOTO :eula

:: END VANILLA INSTALLATION SECTION

:: BEGIN LAUNCH FABRIC / QUILT / VANILLA SECTION
:launchvanilla
:launchfabric
:launchquilt
CLS
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO            %yellow%   Universalator - Server launcher script    %blue%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO:
ECHO   %yellow% READY TO LAUNCH !MODLOADER! SERVER! %blue%
ECHO:
ECHO      CURRENT SERVER SETTINGS:
ECHO        MINECRAFT ----- !MINECRAFT!
IF !MODLOADER!==FABRIC ECHO        !MODLOADER! LOADER - !FABRICLOADER!
IF !MODLOADER!==QUILT ECHO        !MODLOADER! LOADER - !QUILTLOADER!
IF !OVERRIDE!==N ECHO        JAVA - !JAVAVERSION! / Adoptium !JAVANUM!
IF !OVERRIDE!==Y ECHO        JAVA - CUSTOM OVERRIDE
ECHO:
ECHO ============================================
ECHO   %yellow% CURRENT NETWORK SETTINGS:%blue%
ECHO:
ECHO    PUBLIC IPv4 AND PORT      - %green% %PUBLICIP%:%PORT% %blue%
ECHO    LAN IPv4 AND PORT         - %green% !LOCALIP!:%PORT% %blue%
ECHO    TO CONNECT ON SAME PC USE - %green% localhost %blue% ^< This text
ECHO:
ECHO ============================================ & ECHO: & ECHO:
ECHO   %yellow% READY TO LAUNCH !MODLOADER! SERVER! %blue%
ECHO:
ECHO            ENTER %green% 'M' %blue% FOR MAIN MENU
ECHO            ENTER %green% ANY OTHER %blue% KEY TO START SERVER LAUNCH 
ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P "FABRICLAUNCH="
IF /I !FABRICLAUNCH!==M GOTO :mainmenu

ECHO: & ECHO   Launching... & ping -n 2 127.0.0.1 >nul & ECHO   Launching.. & ping -n 2 127.0.0.1 >nul & ECHO   Launching. & ECHO:

IF !OVERRIDE!==Y SET "JAVAFILE=java"

:: If the ARGS setting has not been changed by the user, use no default args for Java 17+.  Newer Java versions are much better at being self-optimizing than older versions.
:: The user can still totally enter their own custom args if they want!  Or these with literally any tiny number change.
If !JAVAVERSION! GEQ 17 (
  IF "!ARGS!"=="-XX:+UseG1GC -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M" ( SET "USEARGS=" ) ELSE ( SET "USEARGS=!ARGS!" )
) ELSE ( SET "USEARGS=!ARGS!" )
:: Makes a final combined args.
IF DEFINED USEARGS ( SET "USEARGS=!USEARGS! !OTHERARGS!" ) ELSE ( SET "USEARGS=!OTHERARGS!" )

TITLE Universalator %UNIV_VERSION% - !MINECRAFT! !MODLOADER!

:: Actually launch the server!

REM Sets the different launch methods for each type of modloader.
IF /I !MODLOADER!==FABRIC SET "LAUNCHLINE=!MAXRAM! !USEARGS! -jar fabric-server-launch-!FABRICMCNAME!-!FABRICLOADER!.jar nogui"
IF /I !MODLOADER!==QUILT SET "LAUNCHLINE=!MAXRAM! !USEARGS! -jar quilt-server-launch-!QUILTMCNAME!-!QUILTLOADER!.jar nogui"
IF /I !MODLOADER!==VANILLA SET "LAUNCHLINE=!MAXRAM! !USEARGS! -jar minecraft_server.!MINECRAFT!.jar nogui"

REM The launch method depends on whether to use UPNP port forwarding or not.  Strongly tests we really want to do it that way or not.
IF DEFINED USEPORTFORWARDED IF !USEPORTFORWARDED!==Y SET LAUNCH=UPNP
IF NOT EXIST "univ-utils\Portforwarded\Portforwarded.Server.exe" SET LAUNCH=NORMAL
IF !USEPORTFORWARDED!==N SET LAUNCH=NORMAL

IF "!LAUNCH!"=="UPNP" (
  IF /I "!PROTOCOL!"=="TCP" univ-utils\Portforwarded\Portforwarded.Server.exe executable:file="!JAVAFILE!" executable:workingdirectory="!HERE!" executable:parameters="!LAUNCHLINE!" upnp:0:Protocol="Tcp" upnp:0:LocalPort=!PORT! upnp:0:PublicPort=!PORT!
  IF /I "!PROTOCOL!"=="BOTH" univ-utils\Portforwarded\Portforwarded.Server.exe executable:file="!JAVAFILE!" executable:workingdirectory="!HERE!" executable:parameters="!LAUNCHLINE!" upnp:0:Protocol="Tcp" upnp:0:LocalPort=!PORT! upnp:0:PublicPort=!PORT! upnp:1:Protocol="Udp" upnp:1:LocalPort=!PORTUDP! upnp:1:PublicPort=!PORTUDP!
  IF /i "!PROTOCOL!"=="UDP" univ-utils\Portforwarded\Portforwarded.Server.exe executable:file="!JAVAFILE!" executable:workingdirectory="!HERE!" executable:parameters="!LAUNCHLINE!" upnp:1:Protocol="Udp" upnp:1:LocalPort=!PORTUDP! upnp:1:PublicPort=!PORTUDP!
)

REM If not using the UPNP port forwarding, launch the normal way
IF "!LAUNCH!"=="NORMAL" "!JAVAFILE!" !LAUNCHLINE!


REM Resets console color back to Univ colors
color 1E

:: If auto restart is enabled, check if server was purposely shut down or if should restart
IF DEFINED RESTART IF !RESTART!==Y IF EXIST "logs\latest.log" FINDSTR /I "Stopping the server" "logs\latest.log" || (
  SET /a RESARTCOUNT+=1
  IF !RESTARTCOUNT! GEQ 6 GOTO :logsscan
  GOTO :launchfabric
)

GOTO :logsscan

:: END LAUNCH FABRIC / QUILT / VANILLA SECTION

:: BEGIN UPNP SECTION
:upnpmenu
:: First check to see if LOCALIP was found previously on launch or not.  If miniUPnP was just installed during this program run it needs to be done!

:: Sets a variable to toggle so that IP addresses can be shown or hidden
IF NOT DEFINED SHOWIP SET SHOWIP=N
:: Actually start doing the upnp menu
CLS
ECHO:%yellow%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO      UPNP PORT FORWARDING MENU    
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%blue%
ECHO: & ECHO:
IF NOT EXIST "%HERE%\univ-utils\Portforwarded\Portforwarded.Server.exe" (
ECHO   %yellow% 'Portforwarded.Server' PROGRAM %blue% - %red% NOT YET INSTALLED / DOWNLOADED %blue%
ECHO   Port forwarding done in one way or another is requied for people outside your router network to connect.
ECHO   ---------------------------------------------------------------------------------------------
ECHO   %yellow% SETTING UP PORT FORWARDING: %blue%
ECHO   1. THE PREFERRED METHOD IS MANUALLY SETTING UP PORT FORWARDING IN YOUR ROUTER
ECHO      - Manual setting of port forwarding introduces less risk allowing connections than using UPnP.  
ECHO:
ECHO   2. UPnP CAN ALTERNATIVELY BE USED IF YOU HAVE NETWORK ROUTER WHICH IS COMPATIBLE WITH UPnP.
ECHO      - UPnP is a connection method with which networked computers can open ports on network routers.
ECHO      - Not all routers have UPnP - and if yours does it needs to be enabled in settings  - it often is by default.
ECHO: & ECHO:
ECHO      - The program used by the Universalator to do UPnP functions - 'Portforwarded.Server', is not downloaded by default.
ECHO        To check if your router can use UPnP, and use it for setting up port forwarding - you can
ECHO        enter %yellow% 'DOWNLOAD' %blue% to install the 'Portforwarded.Server' program and enable the Universalator UPNP Menu.
ECHO: & ECHO:
ECHO: & ECHO   ENTER YOUR SELECTION & ECHO      %green% 'DOWNLOAD' - Download UPnP Program %blue% & ECHO      %green% 'M' - Main Menu %blue%
)

IF NOT DEFINED PROTOCOL SET "PROTOCOL=TCP"
IF NOT DEFINED PORTUDP SET "PORTUDP=24454"

IF EXIST "%HERE%\univ-utils\Portforwarded\Portforwarded.Server.exe" (
  where dotnet  2>nul 1>nul || (
    CLS
    ECHO: & ECHO: & ECHO   %yellow% OH HEY - IT LOOKS LIKE YOU DON'T HAVE MICROSOFT .NET INSTALLED %blue%
    ECHO   %yellow%    Microsoft .net ^(also known as dotnet ^) is required by the UPNP program which Universalator now uses. %blue%
    ECHO   %yellow%    HERE IS MICROSOFT'S WEBSITE FOR .NET INSTALLER DOWNLOADS: %blue% & ECHO: & ECHO:
    ECHO   https://dotnet.microsoft.com/en-us/download & ECHO: & ECHO   Either go there to get an installer to use, or search the Internet. & ECHO: & ECHO: & ECHO:
    PAUSE
    GOTO :mainmenu
  )
)

IF EXIST "%HERE%\univ-utils\Portforwarded\Portforwarded.Server.exe" (
ECHO   %yellow% Portforwarded.Server PROGRAM %blue% - %green% DOWNLOADED %blue% & ECHO:
ECHO   %yellow% PROTOCOL    %blue% -    %green% %PROTOCOL% %blue%
IF !USEPORTFORWARDED!==N ECHO   %yellow% UPNP STATUS %blue% -      %red% NOT ACTIVE - WILL NOT USE UPNP PORT FORWARDING %blue% & ECHO                        %red% 'A' - TO ACTIVATE %yellow% OR %red% SET UP AND USE MANUAL NETWORK ROUTER PORT FORWARDING %blue% & ECHO:
IF "!PROTOCOL!"=="TCP" IF !USEPORTFORWARDED!==Y  ECHO   %yellow% UPNP STATUS %blue% - %green% ACTIVE - WILL FORWARD PORT - TCP !PORT! %blue% & ECHO:
IF "!PROTOCOL!"=="BOTH" IF !USEPORTFORWARDED!==Y  ECHO   %yellow% UPNP STATUS %blue% - %green% ACTIVE - WILL FORWARD PORT - TCP !PORT! / UDP !PORTUDP! %blue% & ECHO:
IF "!PROTOCOL!"=="UDP" IF !USEPORTFORWARDED!==Y  ECHO   %yellow% UPNP STATUS %blue% - %green% ACTIVE - WILL FORWARD PORT - UDP !PORTUDP! %blue% & ECHO:
IF !SHOWIP!==Y ECHO                                                               %yellow% Local IP:port  %blue% - !LOCALIP!:%PORT%
IF !SHOWIP!==Y ECHO                                                               %yellow% Public IP:port %blue% - !PUBLICIP!:%PORT%
IF !SHOWIP!==N ECHO:
IF !SHOWIP!==N ECHO:
ECHO    OPTIONS:
ECHO   %green% CHECK - Check for a network router with UPnP enabled %blue% 
ECHO   %green% TOGGLE - Toggle port forwarding between ^[TCP^], ^[TCP ^& UDP^], ^[UDP^] %blue% 
ECHO   %green% PORT - Change the port numbers being used %blue% 
IF !SHOWIP!==N ECHO   %green% SHOW  - Show your Local and Public IP addresses %blue% && ECHO:
IF !SHOWIP!==Y ECHO   %green% HIDE  - Hide your Local and Public IP addresses %blue% && ECHO:
ECHO   %green% A - Activate UPnP Port Forwarding     %blue%
ECHO   %green% D - Deactivate UPnP Port Forwarding   %blue%
ECHO: & ECHO   %green% M - Main Menu %blue%
ECHO: & ECHO   Enter your choice:
)
ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P "ASKUPNPMENU="
:: Trims off any trailing spaces
IF "!ASKUPNPMENU:~-1!"==" " CALL :trim "!ASKUPNPMENU!" ASKUPNPMENU

IF EXIST "%HERE%\univ-utils\Portforwarded\Portforwarded.Server.exe" (
IF /I !ASKUPNPMENU!==M GOTO :mainmenu
IF /I !ASKUPNPMENU!==CHECK GOTO :upnpvalid
IF /I !ASKUPNPMENU!==TOGGLE GOTO :toggle
IF /I !ASKUPNPMENU!==PORT GOTO :upnpport
IF /I !ASKUPNPMENU!==A GOTO :upnpactivate
IF /I !ASKUPNPMENU!==D GOTO :upnpdeactivate
IF /I !ASKUPNPMENU!==SHOW (
  SET SHOWIP=Y
  GOTO :upnpmenu
)
IF /I !ASKUPNPMENU!==HIDE (
  SET SHOWIP=N
  GOTO :upnpmenu
) 
REM IF /I !ASKUPNPMENU! NEQ M IF /I !ASKUPNPMENU! NEQ CHECK IF /I !ASKUPNPMENU! NEQ TOGGLE IF /I !ASKUPNPMENU! NEQ PORT IF /I !ASKUPNPMENU! NEQ A IF /I !ASKUPNPMENU! NEQ D GOTO :upnpmenu
)

IF  EXIST "%HERE%\univ-utils\Portforwarded\Portforwarded.Server.exe" (
   GOTO :upnpmenu
) ELSE (
IF /I !ASKUPNPMENU!==DOWNLOAD GOTO :upnpdownload
IF /I !ASKUPNPMENU!==M GOTO :mainmenu
IF /I !ASKUPNPMENU! NEQ DOWNLOAD IF /I !ASKUPNPMENU! NEQ M GOTO :upnpmenu
)


:: Switches between protocol types to forward
:toggle
IF !PROTOCOL!==TCP ( SET "PROTOCOL=BOTH" ) ELSE (
  IF "!PROTOCOL!"=="BOTH" ( SET "PROTOCOL=UDP" ) ELSE (
    SET "PROTOCOL=TCP"
  )
)
FOR /F "delims=" %%A IN (settings-universalator.txt) DO (
  SET "TEMP=%%A"
  IF "!TEMP:SET PROTOCOL=x!" NEQ "!TEMP!" ( ECHO SET PROTOCOL=!PROTOCOL!>>z.txt ) ELSE ( ECHO !TEMP!>>z.txt ) )
DEL settings-universalator.txt
REN z.txt settings-universalator.txt
GOTO :upnpmenu

:: User can enter their port numbers to be used
:upnpport
CLS

REM Leave as %DOTCP% not !DOTCP! - CMD weirdness...
IF "%PROTOCOL%"=="TCP" SET DOTCP=Y & SET DOUDP=N
IF "%PROTOCOL%"=="BOTH" SET DOTCP=Y & SET DOUDP=Y
IF "%PROTOCOL%"=="UDP" SET DOTCP=N & SET DOUDP=Y

IF %DOTCP%==Y (
  SET "TCPSTART=!PORT!"
  ECHO: & ECHO: & ECHO   %yellow% THE TCP PORT PREVIOUSLY ENTERED WAS %green% !PORT! %blue% & ECHO: & ECHO: & ECHO:
  
  ECHO: & ECHO   %yellow% ENTER THE PORT NUMBER TO BE USED FOR THE %green% TCP %yellow% PORT %blue% & ECHO:
  ECHO   %yellow% OR 'default' TO USE THE DEFAULT MINECRAFT PORT 25565 & ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P "PORT2="
  :: Trims off any trailing spaces
  IF "!PORT2:~-1!"==" " CALL :trim "!PORT2!" PORT2

  IF /I "!PORT2!"=="default" (
    SET "PORT=25565"
    REM Corrects the server.properties file if the TCP port number changed
    IF "!PORT!" NEQ "!TCPSTART!" (
      CALL :serverpropsedit server-port !PORT!
      CALL :univ_settings_edit PORT !PORT!
    )
    IF "!PROTOCOL!"=="TCP" (
      GOTO :upnpmenu
    ) ELSE ( 
      IF NOT DEFINED PORTUDP SET PORTUDP=24454
      SET UDPSTART=!PORTUDP!
      GOTO :upnp_udpagain
    )
  ) 

  ( ECHO !PORT2! | FINDSTR /R [a-Z] 1>nul 2>nul ) && (
    REM If setting PORT2 to be an integer fails then they didn't enter only an integer
    ECHO: & ECHO   %red% OOPS %blue% - You did not enter an integer number.  Try again. & ECHO:
    PAUSE
    GOTO :upnpport
  ) || ( SET "PORT3=" )

  IF !PORT2! LSS 10000 (
    ECHO: & ECHO      %red% OOPS %blue% - DO NOT SET THE PORT TO BE USED BELOW 10000 - BELOW THAT NUMBER IS NOT A GOOD IDEA
    ECHO       Other critical processes may be using numbers below 10000 & ECHO: & ECHO   TRY AGAIN^^! & ECHO: & ECHO:
    PAUSE
    GOTO :upnpport
  )
  SET "PORT=!PORT2!" & SET "PORT2="
  REM Corrects the server.properties file if the TCP port number changed
  IF "!PORT!" NEQ "!TCPSTART!" (
    CALL :serverpropsedit server-port !PORT!
    CALL :univ_settings_edit PORT !PORT!
  )
)

IF NOT DEFINED PORTUDP SET PORTUDP=24454
SET UDPSTART=!PORTUDP!

:upnp_udpagain
IF %DOUDP%==Y (
  IF EXIST "config\voicechat\voicechat-server.properties" (
    CLS
    FOR /F "tokens=2 delims=^= " %%A IN ('FINDSTR "port=" "config\voicechat\voicechat-server.properties"') DO SET PORTCONFIG=%%A
    ECHO: & ECHO: & ECHO   %yellow% A %green% 'Simple Voice Chat' mod %yellow% config file was found, with a value set to use UDP port %green% !PORTCONFIG! %blue% & ECHO:
    ECHO   %yellow% FYI - The default 'Simple Voice Chat' mod port number is 24454 %blue% & ECHO:
    ECHO   %yellow% Do you want to use this port number %green% !PORTCONFIG! %yellow% for your %green% UDP %yellow% port setting? %blue% & ECHO:
    SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
    SET /P "ASK="
    IF /I !ASK!==Y SET "PORT2=!PORTCONFIG!"
    IF /I !ASK! NEQ Y  (
      ECHO: & ECHO   You said N, or at least not Y & ECHO: & ECHO   %yellow% Enter a port number to use for %green% UDP %blue%
      ECHO   %yellow% OR - enter 'default' to use 24454 %blue% & ECHO:
      SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
      SET /P "PORT2="
      :: Trims off any trailing spaces
      IF "!PORT2:~-1!"==" " CALL :trim "!PORT2!" PORT2

      IF /I "!PORT2!"=="default" (
        SET "PORTUDP=24454"
      )
      IF /I "!PORT2!" NEQ "default" ( ( ECHO !PORT2! | FINDSTR /R [a-Z] 1>nul 2>nul ) && (
        REM If setting PORT2 to be an integer fails then they didn't enter only an integer
        ECHO   %red% OOPS %blue% - You did not enter an integer number.  Try again. & ECHO:
        PAUSE
        GOTO :upnp_udpagain
      ) )
    )


    IF /I "!PORT2!"=="default" SET "PORT2=24454"

    IF "!PORT2!" NEQ "!PORTCONFIG!" (
      FOR /F "delims=" %%A IN ('type config\voicechat\voicechat-server.properties') DO (
        SET "TEMP=%%A"
        SET "PORTLINE=port=!PORT2!"

        REM If both replacement tests on TEMP pass then it's the real port entry and not a comment, otherwise put back the original line.
        IF "!TEMP!" NEQ "!TEMP:#=x!" ( ECHO !TEMP!>>config\voicechat\2voicechat-server.properties ) ELSE (
          IF "!TEMP!" NEQ "!TEMP:port=x!" ( ECHO !PORTLINE!>>config\voicechat\2voicechat-server.properties ) ElSE (
            ECHO !TEMP!>>config\voicechat\2voicechat-server.properties 
          )
        )
      )
      REM You have to be in the same working directory as the file to rename the file.
      PUSHD config\voicechat
      DEL voicechat-server.properties 1>nul 2>nul
      REN 2voicechat-server.properties voicechat-server.properties
      POPD
    )
    SET "PORTUDP=!PORT2!" & SET "PORT2="
  ) ELSE (
    ECHO: & ECHO: & ECHO   %yellow% ENTER THE PORT NUMBER TO BE USED FOR THE %green% UDP %blue% PORT & ECHO:
    ECHO: & IF DEFINED PORTUDP ( ECHO   %yellow% The port you had set already was - %green% !PORTUDP! %blue% & ECHO: )
    ECHO: & ECHO   Enter a port number to use for UDP & ECHO:
    SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
    SET /P "PORT2="
    :: Trims off any trailing spaces
    IF "!PORT2:~-1!"==" " CALL :trim "!PORT2!" PORT2

    FOR %%A IN (!PORT2!) DO ( SET /a "PORT2=%%A" 1>nul 2>nul || (
      REM If setting PORT2 to be an integer fails then they didn't enter only an integer
      ECHO   %red% OOPS %blue% - You did not enter an integer number.  Try again. & ECHO:
      PAUSE
      GOTO :upnp_udpagain
    ))
    SET "PORTUDP=!PORT2!" & SET "PORT2="
  )
  IF "!UDPSTART!" NEQ "!PORTUDP!" ( CALL :univ_settings_edit PORTUDP !PORTUDP! )
)
GOTO :upnpmenu

:: BEGIN UPNP CHECK / LOOK FOR VALID & ENABLED UPNP ROUTER
:upnpvalid
:: Loops through the status flag -s looking for lines that are different between itself and itself but replacing any found 'Found valid IGD' with random other string.
SET FOUNDVALIDUPNP=N
ECHO   %cyan% Checking for UPnP Enabled Network Router ... ... ... %blue%

:: Need to use a java verion to use the Portforwarded.Server test - any java will do since old MC 1.4.2 will be use as the tester.  If this finds a java in PATH just go with it.
( WHERE java | FINDSTR "java.exe" 2>&1 >nul ) && ( SET "UPNPJAVA=java" )

REM If java wasn't found in the path then need to actually get a copy by preinstalling.  There should be a JAVAVERSION set!
IF NOT DEFINED UPNPJAVA (
  SET GETUPNPJAVA=Y
  GOTO :javaupnp
)
:returnjavaupnp
IF DEFINED GETUPNPJAVA (
  SET "UPNPJAVA=!JAVAFILE!"
  REM Adds a backquote in front of single quotes because using this in powershell and needs char escaping.
  SET "UPNPJAVA=!UPNPJAVA:'=`'!"
  SET "GETUPNPJAVA="
)

:: Now gets a vanilla Minecraft server JAR to use for testing
IF NOT EXIST "%HERE%\univ-utils\Portforwarded\minecraft_server.1.4.2.jar" (
  SET "MCHOLDER=!MINECRAFT!"
  SET "MINECRAFT=1.4.2"
  SET UPNPGETMCJAR=Y
  GOTO :upnpgetjar
)
:returnupnpgetjar
IF DEFINED UPNPGETMCJAR (
  SET "MINECRAFT=!MCHOLDER!" & SET "MCHOLDER=" & SET "UPNPGETMCJAR="
  IF EXIST "minecraft_server.1.4.2.jar" ( MOVE "%HERE%\minecraft_server.1.4.2.jar" "%HERE%\univ-utils\Portforwarded\minecraft_server.1.4.2.jar" >nul ) ELSE ( GOTO :upnpmenu )
)


SET CHECKPASS=IDK
FOR /F "delims=" %%A IN ('powershell -Command="cmd.exe /c 'univ-utils\Portforwarded\Portforwarded.Server.exe' executable:file='!UPNPJAVA!' executable:workingdirectory='univ-utils\Portforwarded' executable:parameters='-Xmx3G -jar minecraft_server.1.4.2.jar nogui' upnp:0:Protocol='Tcp' upnp:0:LocalPort=!PORT! upnp:0:PublicPort=!PORT! testmode='true'"') DO (
    ECHO "%%A" | FINDSTR /I /C:"Created map for IP" >nul && SET CHECKPASS=Y
)

IF !CHECKPASS!==Y (
    CLS
    ECHO: & ECHO: & ECHO:
    ECHO     %green% FOUND A NETWORK ROUTER WITH UPNP ENABLED FOR USE %blue%
    ECHO:
    IF /I !ASKUPNPMENU!==A GOTO :upnpreturnactivate
    PAUSE
    GOTO :upnpmenu
) ELSE (
    CLS
    ECHO:& ECHO:
    ECHO   %red% NO UPNP ENABLED NETWORK ROUTER WAS FOUND - SORRY. %blue% & ECHO:
    ECHO   IT IS POSSIBLE THAT YOUR ROUTER DOES HAVE UPNP COMPATIBILITY BUT IT IS CURRENTLY
    ECHO   SET TO DISABLED.  CHECK YOUR NETWORK ROUTER SETTINGS.
    ECHO: & ECHO   OR & ECHO:
    ECHO   YOU WILL NEED TO CONFIGURE PORT FORWARDING ON YOUR NETWORK ROUTER MANUALLY
    ECHO   FOR INSRUCTIONS YOU CAN WEB SEARCH PORT FORWARDING MINECRAFT SERVERS
    ECHO: & ECHO   OR & ECHO:
    ECHO   VISIT THE UNIVERSALATOR WIKI AT:
    ECHO   https://github.com/nanonestor/universalator/wiki
    ECHO: & ECHO:
    PAUSE
    GOTO :upnpmenu
)

:: END UPNP CHECK / LOOK FOR VALID & ENABLED UPNP ROUTER

:: BEGIN UPNP ACTIVATE PORT FOWARD
:upnpactivate
CLS
ECHO: & ECHO: & ECHO:
ECHO       %yellow% ENABLE UPNP PORT FORWARDING? %blue%
ECHO: & ECHO:
ECHO         Enter your choice:
ECHO:
ECHO         %green% 'Y' or 'N' %blue%
ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P "ENABLEUPNP="
IF /I !ENABLEUPNP! NEQ N IF /I !ENABLEUPNP! NEQ Y GOTO :upnpactivate


REM Need to check if UPNP will work! If the test fails the script does not come back here, it goes to upnpmenu
IF /I !ENABLEUPNP!==Y ECHO: & ECHO: & GOTO :upnpvalid
:upnpreturnactivate

REM Handles if Y or N was entered and sets config with result
IF /I !ENABLEUPNP!==Y (
  SET USEPORTFORWARDED=Y
  ECHO: & ECHO     %green% Portforwarded UPNP port forwarding ENABLED^^! %blue% & ECHO:
  PAUSE
  CALL :univ_settings_edit USEPORTFORWARDED Y
  GOTO :upnpmenu
) ELSE (
  SET USEPORTFORWARDED=N
  CALL :univ_settings_edit USEPORTFORWARDED N
  GOTO :mainmenu
)

:: END UPNP ACTIVATE PORT FORWARD

:: BEGIN UPNP DEACTIVATE PORT FORWARD
:upnpdeactivate

SET USEPORTFORWARDED=N
ECHO: & ECHO   %red% Portforwarded UPNP port forwarding Disabled^^! %blue% & ECHO:
CALL :univ_settings_edit USEPORTFORWARDED N
PAUSE
GOTO :upnpmenu

::END UPNP DEACTIVATE PORT FORWARD

:: BEGIN UPNP FILE DOWNLOAD
:upnpdownload
CLS
ECHO: & ECHO:
ECHO  %yellow% DOWNLOAD Portforwarded.Server PROGRAM? %blue% & ECHO:
ECHO  ENTERING 'Y' WILL DOWNLOAD THE Portforwarded.Server PROGRAM FROM THAT PROJECTS WEBSITE ON GITHUB: & ECHO:
ECHO   https://github.com/itssimple/Portforwarded.Server & ECHO:
ECHO   Portforwarded.Server is published with the MIT / open source license. & ECHO:
ECHO  %yellow% DOWNLOAD Portforwarded.Server PROGRAM? %blue% & ECHO:
ECHO   ENTER YOUR CHOICE: & ECHO:
ECHO   %green%  'Y' - Download file %blue%
ECHO   %green%  'N' - NO  ^(Back to UPNP menu^) %blue% & ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P "ASKUPNPDOWNLOAD="
IF /I !ASKUPNPDOWNLOAD! NEQ N IF /I !ASKUPNPDOWNLOAD! NEQ Y GOTO :upnpdownload
IF /I !ASKUPNPDOWNLOAD!==N GOTO :upnpmenu
:: If download is chosen - download the Portforwarded Windows client ZIP file, License.  Then unzip out only the Portforwarded.Server.exe
IF /I !ASKUPNPDOWNLOAD!==Y IF NOT EXIST "%HERE%\univ-utils\Portforwarded\Portforwarded.Server.exe" (
  CLS
  ECHO: & ECHO: & ECHO   Downloading ZIP file ... ... ... & ECHO:
  IF NOT EXIST "%HERE%\univ-utils\Portforwarded" MD "%HERE%\univ-utils\Portforwarded"
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/itssimple/Portforwarded.Server/releases/download/2.0.1/Portforwarder.Server-2.0.1-win-x64.zip', 'univ-utils\Portforwarded\Portforwarded_release.zip')"
  
  IF EXIST "%HERE%\univ-utils\Portforwarded\Portforwarded_release.zip" (
    ECHO   %green% SUCCESSFULLY DOWNLOADED Portforwarded BINARAIES ZIP FILE %blue%
    PUSHD "%HERE%\univ-utils\Portforwarded"
    tar -xf Portforwarded_release.zip Portforwarded.Server.exe >nul
    DEL Portforwarded_release.zip >nul 2>&1
    POPD
  ) ELSE (
      ECHO: & ECHO  %red% DOWNLOAD OF Portforwarded FILES ZIP FAILED %blue%
      PAUSE
      GOTO :upnpmenu
  )
  IF EXIST "%HERE%\univ-utils\Portforwarded\Portforwarded.Server.exe" (
    ECHO: & ECHO   %green% Portforwarded FILE Portforwarded.Server.exe SUCCESSFULLY EXTRACTED FROM ZIP %blue% & ECHO:
    ECHO       Going back to UPnP menu ... ... ... & ECHO:
    PAUSE
    GOTO :upnpmenu
  ) ELSE (
    ECHO: & ECHO   %green% Portforwarded BINARY ZIP FILE WAS FOUND TO BE DOWNLOADED %blue% & ECHO   %red% BUT FOR SOME REASON EXTRACTING THE Portforwarded.Server.exe FILE FROM THE ZIP FAILED %blue%
    PAUSE 
  )
  GOTO :upnpmenu
) ELSE GOTO :upnpmenu

:: END UPNP SECTION

:: BEGIN JAVA OVERRIDE SECTION
:override
CLS
ECHO: & ECHO: & ECHO   %green% JAVA OVERRIDE FOR THE CURRENT PROGRAM SESSION ENABLED %blue% & ECHO   %yellow% Using the following system Path Java %blue% & ECHO:
SET /a num=0
FOR /F "usebackq delims=" %%J IN (`"java -version 2>&1"`) DO (
  ECHO        %%J
  SET JAV[!num!]=%%J
  SET /a num+=1
)
ECHO: & ECHO   %yellow% GOOD LUCK WITH THAT !! %blue% & ECHO: & ECHO   %green% JAVA OVERRIDE FOR THE CURRENT PROGRAM SESSION ENABLED %blue% & ECHO:
SET CUSTOMJAVA=!JAV[1]!
SET OVERRIDE=Y
PAUSE
GOTO :mainmenu
:: END JAVA OVERRIDE SECTION

:: BEGIN MCREATOR SECTION
:mcreator
CLS
ECHO:
ECHO   %yellow% Searching 'mods' folder for MCreator mods [Please Wait] %blue%
ECHO:
PUSHD mods
findstr /i /m "net/mcreator /procedures/" *.jar >final.txt
IF !ERRORLEVEL!==1 (
  IF EXIST final.txt DEL final.txt
  POPD
  ECHO: & ECHO  %green% NO MCREATOR MADE MODS WERE DETECTED IN THE MODS FOLDER %blue% & ECHO:
  PAUSE
  GOTO :mainmenu
)
ver >nul
SORT final.txt > mcreator-mods.txt
DEL final.txt
POPD
MOVE "%HERE%\mods\mcreator-mods.txt" "%HERE%\mcreator-mods.txt"
CLS
ECHO:
ECHO            %yellow% RESULTS OF Search %blue%
ECHO ---------------------------------------------
for /f "tokens=1 delims=" %%i in (mcreator-mods.txt) DO (
  ECHO    mcreator mod - %%i
)
ECHO: & ECHO: & ECHO:
ECHO    The above mod files were created using MCreator.
ECHO    %red% They are known to often cause severe problems because of the way they get coded. %blue% & ECHO:
ECHO    A text tile has been generated in this directory named mcreator-mods.txt listing
ECHO      the mod file names for future reference. & ECHO:
PAUSE
GOTO :mainmenu
:: END MCREATOR SECTION

:: BEGIN ZIP SERVERPACK SECTION
:zipit
CLS
ECHO: & ECHO   %yellow% ZIP SERVER PACK - ZIP SERVER PACK %blue% & ECHO:
ECHO     Continue on to create a server pack ZIP file? & ECHO:
ECHO     Server packs are typically made by modpack authors wishing to share the files & ECHO     needed to correctly run a server for their modpack. & ECHO:
ECHO          %green% - Include all required files and folders in the following menu. %blue% & ECHO:
ECHO          %red% - Do not include folders or files that aren't neccessary / customized by you. %blue% & ECHO: & ECHO:
ECHO   %yellow% ZIP SERVER PACK - ZIP SERVER PACK %blue% & ECHO: & ECHO: & ECHO: & ECHO: & ECHO:
SET /P SCRATCH="%blue%         %green% ENTER 'Y' TO CONTINUE OR 'M' FOR MAIN MENU: %blue% " <nul
SET /P "ASKUPNPDOWNLOAD="
IF /I !ASKUPNPDOWNLOAD! NEQ M IF /I !ASKUPNPDOWNLOAD! NEQ Y GOTO :zipit
IF /I !ASKUPNPDOWNLOAD!==M GOTO :mainmenu


SET /a ZIPCOUNT=0
FOR /F %%A IN ('DIR /B') DO (
  IF %%A==config SET "ZIPFILE[!ZIPCOUNT!]=config" & SET /a ZIPCOUNT+=1
  IF %%A==defaultconfigs SET "ZIPFILE[!ZIPCOUNT!]=defaultconfigs" & SET /a ZIPCOUNT+=1
  IF %%A==kubejs SET "ZIPFILE[!ZIPCOUNT!]=kubejs" & SET /a ZIPCOUNT+=1
  IF %%A==mods SET "ZIPFILE[!ZIPCOUNT!]=mods" & SET /a ZIPCOUNT+=1
  IF %%A==scripts SET "ZIPFILE[!ZIPCOUNT!]=scripts" & SET /a ZIPCOUNT+=1
  IF %%A==server.properties SET "ZIPFILE[!ZIPCOUNT!]=server.properties" & SET /a ZIPCOUNT+=1
  IF %%A==settings-universalator.txt SET "ZIPFILE[!ZIPCOUNT!]=settings-universalator.txt" & SET /a ZIPCOUNT+=1
  ECHO %%A | FINDSTR /BI "Universalator" >nul
  IF !ERRORLEVEL!==0 (
    SET "ZIPFILE[!ZIPCOUNT!]=%%A"
    SET /a ZIPCOUNT+=1
  )
)

:zipit2
CLS
ECHO: & ECHO    ZIP SERVER PACK - ZIP SERVER PACK %blue% & ECHO:

FOR /L %%B IN (0,1,!ZIPCOUNT!) DO (
  IF [!ZIPFILE[%%B]!] NEQ [] IF !ZIPFILE[%%B]! NEQ deletedentry ECHO   %yellow% !ZIPFILE[%%B]! %blue% 
)
ECHO:
ECHO    Above are listed the current files and folders selected to include in making the server pack ZIP file.
ECHO    Use the commands listed to add or remove entries - use exact file or folder names. & ECHO:
ECHO    Once you are finished editing, enter the ZIPIT command to generate your server pack ZIP. & ECHO    The name after the ZIPIT command will be the filename that gets created - do not include .zip at the end. & ECHO: & ECHO:

SET /P SCRATCH="%green% Entry options - %blue% %green% 'ADD <name>' %blue% %green% 'REM <name>' %blue% %green% 'ZIPIT <name>' %blue% %green% 'M' for main menu%blue%" <nul
ECHO: & ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P "ASKUPNPDOWNLOAD="
ECHO:

IF /I !ASKUPNPDOWNLOAD! NEQ M IF /I "!ASKUPNPDOWNLOAD:~0,6!" NEQ "ZIPIT " IF /I "!ASKUPNPDOWNLOAD:~0,3!" NEQ "ADD" IF /I "!ASKUPNPDOWNLOAD:~0,3!" NEQ "REM" GOTO :zipit2
IF /I !ASKUPNPDOWNLOAD!==M GOTO :mainmenu

:: ADD section
:: Filters entries to deny adding things that should be installed by user or a script like modloader files.
:: If entry is allowed and exists then it adds +1 to ZIPCOUNT a new pseudo array ZIPFILE variable for the entry.
IF /I "!ASKUPNPDOWNLOAD:~0,3!"=="ADD" (
  SET "TEMP=!ASKUPNPDOWNLOAD:~4!"
  ECHO !TEMP! | FINDSTR /I "univ-utils .fabric libraries versions logs .jar" >nul
  IF !ERRORLEVEL!==0 (
    ECHO   %red% You tried to add '!TEMP!' - this will not be added because it should be either installed %blue% & ECHO   %red% by script / user or will be generated when server files first run. %blue% & ECHO:
    PAUSE
    GOTO :zipit2
  )
  IF EXIST "!TEMP!" (
   SET /a ZIPCOUNT+=1
   SET ZIPFILE[!ZIPCOUNT!]=!TEMP!
  ) ELSE (
    ECHO   %red% 'ADD' ENTRY '!TEMP!' DOES NOT EXIST - Filenames must be exact and include any extension! %blue% & ECHO:
    PAUSE
  )
)

:: REM section
:: Changes rem entries into the string 'deletedentry'.  Adding and then removing a ton of entries eventually winds up in a large ZIPCOUNT but it's not a big problem.
IF /I "!ASKUPNPDOWNLOAD:~0,3!"=="REM" (
  SET "TEMP=!ASKUPNPDOWNLOAD:~4!"
  IF EXIST "!TEMP!" (
    FOR /L %%R IN (0,1,!ZIPCOUNT!) DO (
      IF "!ZIPFILE[%%R]!"=="!TEMP!" SET ZIPFILE[%%R]=deletedentry
      ECHO !ZIPFILE[%%R]!
    )
  ) ELSE (
    ECHO   %red% 'REM' ENTRY '!TEMP!' DOES NOT EXIST - Filenames must be exact and include any extension! %blue% & ECHO:
    PAUSE
  )
)

IF /I "!ASKUPNPDOWNLOAD:~0,6!"=="ZIPIT " (
  SET "ZIPNAME=!ASKUPNPDOWNLOAD:~6!"
  IF [!ASKUPNPDOWNLOAD:~6!]==[] GOTO :zipit2
  IF EXIST "!ZIPNAME!.zip" DEL "!ZIPNAME!.zip" >nul
  FOR /L %%R IN (0,1,!ZIPCOUNT!) DO (
    IF "!ZIPFILE[%%R]!" NEQ "deletedentry" IF [!ZIPFILE[%%R]!] NEQ [] (
      powershell -Command "Compress-Archive -CompressionLevel Optimal -Path '!ZIPFILE[%%R]!' -Update -DestinationPath '!ZIPNAME!.zip'" >nul
    )
  )
  IF NOT EXIST univ-utils\readme.txt (
    ECHO Using this serverpack->univ-utils\readme.txt
    ECHO .>>univ-utils\readme.txt
    ECHO If using Windows - run the file named 'Universalator-version.bat', then launch.  Changing any settings, do not alter the Minecraft version - '!MINECRAFT!'>>univ-utils\readme.txt
    ECHO .>>univ-utils\readme.txt
    ECHO IF using Linux or OSX/Mac go to the website for the modloader used - '!MODLOADER!' - and install, then launch the core server files for that modloader using the same Minecraft - '!MINECRAFT!' - and Modloader version - '!MODLOADERVERSION!' - as the modpack version or custom profile you are using.  Use the same version of java - '!JAVAVERSION!'.>>univ-utils\readme.txt
  )
  powershell -Command "Compress-Archive -CompressionLevel Optimal -Path 'univ-utils\readme.txt' -Update -DestinationPath '!ZIPNAME!.zip'" >nul
  ECHO: & ECHO   %yellow% Finished creating server pack zip named !ZIPNAME!.zip %blue% & ECHO: & ECHO:
  PAUSE
  GOTO :mainmenu
)
GOTO :zipit2

:: END ZIP SERVERPACK SECTION

:: BEGIN LOGS SCANNING SECTION
:logsscan
IF NOT EXIST "%HERE%\logs\latest.log" GOTO :skiplogchecking
:: Looks for the stopping the server text to decide if the server was shut down on purpose.  If so goes to main menu and do not bother checking anything else.
TYPE "%HERE%\logs\latest.log" | FINDSTR /I /C:"Stopping the server" >nul && GOTO :skiplogchecking
:: Search if any mods are compiled against a newe MC version than currently used
TYPE "%HERE%\logs\latest.log" | FINDSTR /I /C:"Unsupported class file major version" >nul && (
  ECHO: & ECHO        %red% --SPECIAL NOTE-- %blue%
  ECHO    %yellow% FROM SCANNING THE LOGS IT LOOKS LIKE YOUR SERVER MAY HAVE CRASHED FOR ONE OF TWO REASONS:  %blue%
  ECHO    %yellow% --YOUR SELECTED JAVA VERSION IS NOT COMPATIBLE WITH THE CURRENT FORGE VERSION OR MOD FILE^(S^) %blue%
  ECHO    %yellow% --AT LEAST ONE MOD FILE IN THE MODS FOLDER IS MEANT FOR A DIFFERENT VERSION OF FORGE / MINECRAFT %blue% & ECHO:
  ECHO        %red% --SPECIAL NOTE-- %blue% & ECHO:
)

  :: Search if the standard client side mod message was found.
FOR %%T IN ("invalid dist DEDICATED_SERVER" "Attempting to load a clientside only mod") DO (
  TYPE "%HERE%\logs\latest.log" | FINDSTR /I /C:%%T >nul && (
    ECHO: & ECHO        %red% --- SPECIAL NOTE --- %blue%
    ECHO    THE TEXT %%T WAS FOUND IN THE LOG FILE
    ECHO    This could %yellow% MAYBE %blue% mean you have CLIENT SIDE mods crashing the server. & ECHO:
    ECHO   %yellow% TRY USING THE UNIVERSALATOR %green% 'SCAN' %yellow% OPTION TO FIND CLIENT MODS. %blue% & ECHO:
    ECHO   There are a lot of other reasons which could be causing the server to crash.
    ECHO   If you have already done a client mod SCAN, look through the logs carefully to try to find whether the issue
    ECHO   really are client side mods, or another issue.
    ECHO: & ECHO        %red% --- SPECIAL MESSAGE --- %blue% & ECHO:
    GOTO :outofclientmessage
  )
)
:outofclientmessage


  :: Search if the standard client side mod message was found.
TYPE "%HERE%\logs\latest.log" | FINDSTR /I /C:"FAILED TO BIND TO PORT" >nul && (
  ECHO: & ECHO        %red% --- SPECIAL NOTE --- %blue%
  ECHO   %yellow% THE TEXT %red%'FAILED TO BIND TO PORT'%yellow% WAS FOUND IN THE LOG FILE %blue%
  ECHO   %yellow% THIS MEANS THAT ANOTHER PROGRAM / PROCESS IS CURRENTLY USING THE PORT %blue% 
  ECHO   %yellow% SET IN SETTINGS- MAYBE ANOTHER SERVER? %blue%
  ECHO: & ECHO   %yellow% IF YOU CANNOT SEEM TO CLOSE WHATEVER THE PROGRAM IS - RESTART YOUR COMPUTER AND TRY LAUNCHING AGAIN. %blue%
  ECHO:
  ECHO        %red% --- SPECIAL MESSAGE --- %blue% & ECHO:
)
ECHO: & ECHO   IF THIS MESSAGE IS VISIBLE SERVER MAY HAVE CRASHED / STOPPED & ECHO: & ECHO   CHECK LOG FILES - PRESS ANY KEY TO GO BACK TO MAIN MENU & ECHO:

:skiplogchecking
PAUSE

:: Resets the background color to blue if modloader had set it to other
color 1E
CLS

GOTO :mainmenu

:: END LOGS SCANNING SECTION

:: BEGIN Port editing menu
:portedit
CLS
ECHO: & ECHO:
ECHO   %yellow% ENTER THE PORT NUMBER TO USE FOR THE LAUNCHED SERVER %blue%
ECHO:
ECHO      DEFAULT VALUE IS %yellow% 25565 %blue%
ECHO:
ECHO      CURRENTLY SET VALUE IS - %green% %PORT% %blue%
ECHO:
ECHO      DO NOT SET THE PORT TO BE USED BELOW 10000 - BELOW THAT NUMBER IS NOT A GOOD IDEA
ECHO      OTHER CRITICAL PROCESSES MAY ALREADY BE USING PORTS BELOW THAT NUMBER
ECHO:
ECHO   %yellow% ENTER THE PORT NUMBER TO USE FOR THE LAUNCHED SERVER %blue%
ECHO:
ECHO:
SET /P SCRATCH="%blue% %green% ENTER new port number, 'default', or 'M' for main menu): %blue% " <nul
SET /P newport=
:: Trims off any trailing spaces
IF "!newport:~-1!"==" " CALL :trim "!newport!" newport

IF /I !newport!==M GOTO :mainmenu
IF /I !newport!==default (
  SET PORT=25565
  CALL :serverpropsedit server-port !PORT!
  CALL :univ_settings_edit PORT !PORT!
  GOTO :mainmenu 
)

IF /I !newport! NEQ default ( ( ECHO !newport! | FINDSTR /R [a-Z] 1>nul 2>nul ) && GOTO :portedit )
IF !newport! LSS 10000 GOTO :portedit
SET DUMMY=W
SET /a DUMMY=%newport%
IF "!DUMMY!" NEQ "!newport!" GOTO :mainmenu

SET "PORT=!newport!"
CALL :serverpropsedit server-port !PORT!
CALL :univ_settings_edit PORT !PORT!
GOTO :mainmenu


:: Evaluates if the entry was a number.  Unsets var and then tries to assign it to the result of the FOR delims.  If it is not defined then it is a number.  If it is defined then it is not a number
SET "var=" & FOR /f "delims=0123456789" %%i IN ("%newport%") DO SET var=%%i
:: If var defined then it's not a number
IF DEFINED var ECHO: & ECHO   %red% Invalid entry - only options are a Port number, 'default', or 'M' ^^! %blue% & ECHO: & PAUSE & GOTO :portedit
:: If var is defined then it's a number, check to see if it is in the allowed range
IF NOT DEFINED var (
  IF %newport% LSS 10000 ECHO: & ECHO   %red% Invalid entry - Port cannot be set below 10000 ^^! %blue% & ECHO: & PAUSE & GOTO :portedit

  CALL :serverpropsedit server-port %newport%
  SET PORT=%newport%
  GOTO :mainmenu
)
GOTO :mainmenu
:: END Port editing menu

:: BEGIN server.properties FILE EDITING MENU
:editserverprops
CLS

ECHO: & ECHO  %yellow% SERVER PROPERTIES - SERVER PROPERTIES %blue% & ECHO:

:: Finds the values for each property name to display for editing. Be sure to sort the names alphabetically for the FOR loop!
:: This method is faster than the older FINDSTR pipe to pipe filtering being used.
set /a idk=0
FOR %%A IN (difficulty enable-command-block enforce-whitelist function-permission-level level-name level-seed level-type max-players max-tick-time max-world-size motd region-file-compression server-port simulation-distance spawn-protection view-distance white-list) DO (
  FINDSTR "%%A" server.properties 1>nul 2>nul && ( 
    FOR /F "tokens=1,2 delims== " %%X IN ('FINDSTR "%%A" server.properties') DO (
      SET /a idk+=1
      SET PROP[!idk!]=%%X
      SET VAL[!idk!]=%%Y
    )
  )
)

:: The following code and function below it work to auto format printing two columns of text for the properties and values found.
:: First iterate through the list to find the length of the longest modID string
SET COLUMNWIDTH=0
FOR /L %%p IN (1,1,!idk!) DO (
  IF /I "!PROP[%%p]!" NEQ "" CALL :GetMaxStringLength COLUMNWIDTH "!PROP[%%p]!"
)
:: The equal sign is followed by 80 spaces and a doublequote
SET "EightySpaces=                                                                                "
FOR /L %%D IN (1,1,!idk!) DO (
	:: Append 80 spaces after the modID value
	SET "Column=!PROP[%%D]!%EightySpaces%"
	:: Chop at maximum column width, using a FOR loop as a kind of "super delayed" variable expansion
	FOR %%W IN (!COLUMNWIDTH!) DO (
    SET "Column=!Column:~0,%%W!"
  )
  :: Finally echo the actual line for display using the now-length-formatted PROP[%D] which is now the Column variable. Comparing %D to a number is to account for spaces to keep nice formatting.
	IF %%D LEQ 9 ECHO   ^[%%D^]  !Column!  -   !VAL[%%D]!
	IF %%D GEQ 10 ECHO   ^[%%D^] !Column!  -   !VAL[%%D]!
)

ECHO: & ECHO  %yellow% Current values of some select server properties.   %blue%
ECHO   For full range of properties edit the file 'server.properties' manually with any text editor.
ECHO   ----------------------------------- & ECHO:
ECHO  %yellow% Enter a property number to edit, or 'M' for main menu. %blue%%red% Be sure values are valid^^! %blue% & ECHO:
SET /P SCRATCH="%blue% %green% ENTRY (or 'M' for main menu): %blue% " <nul
SET /P entry1=
:: Trims off any trailing spaces
IF "!entry1:~-1!"==" " CALL :trim "!entry1!" entry1

IF /I !entry1!==M GOTO :mainmenu

:: Evaluates if the entry was a number.  Unsets var and then tries to assign it to the result of the FOR delims.  If it is not defined then it is a number.  If it is defined then it is not a number
SET "var=" & FOR /f "delims=0123456789" %%i IN ("%entry1%") DO SET var=%%i
IF DEFINED var ECHO: & ECHO   %red% Invalid entry - must enter a valid number option or M for main menu^^! %blue% & ECHO: & PAUSE & GOTO :editserverprops

IF NOT DEFINED var (
  IF %entry1% GTR !idk! ECHO   %red% Invalid entry - number is greater than available options! %blue% & ECHO: & PAUSE & GOTO :editserverprops
  ECHO:
  IF "!PROP[%entry1%]!"=="region-file-compression" (
    IF !VAL[%entry1%]!==deflate SET entry2=lz4 & ECHO: & ECHO: & ECHO: & ECHO   %yellow% LZ4 compression method set - this will take up more hard drive space for the world folder, %blue% & ECHO   %yellow% but have faster access time performance^^! %blue% & ECHO: & PAUSE
    IF !VAL[%entry1%]!==lz4 SET entry2=deflate
    REM Could nest more IF ELSE to make more toggle entries.
  ) ELSE (
    SET /P SCRATCH="%blue% %green% Enter new value for '!PROP[%entry1%]!': %blue% " <nul
    SET /P entry2=
    :: Trims off any trailing spaces
    IF "!entry2:~-1!"==" " CALL :trim "!entry2!" entry1
  )

  :: Uses the serverpropsedit function to edit the server.properties file
  CALL :serverpropsedit !PROP[%entry1%]! !entry2!

  :: If changed property is server-port then update the PORT variable. Must be done here because any variable setting in the function is discarded.
  IF !PROP[%entry1%]!==server-port SET PORT=!entry2!

  :: Unsets used variables to reset the setup
	FOR /L %%e IN (0,1,%idk%) DO (
    SET "PROP[!idk!]="
    SET "VAL[!idk!]="
    SET "entry2="
  )
  :: Now that entry was edited with function, go back to the editserverprops menu which will refresh the new changed server.properties for display.
  GOTO :editserverprops
)
:: Just in case something goes wrong the script gets sent back to mainmenu
GOTO :mainmenu

:: END server.properties FILE EDITING MENU


REM BEGIN FIREWALL RULE CHECKING
:firewallcheck

:: FIND JAVA FOLDER LOCATION - To check if a valid firewall rule is set, first need to find the folder location, or determine if it even exists as installed yet.
IF NOT EXIST "%HERE%\univ-utils\java" (
  CLS
  ECHO: & ECHO: & ECHO   %yellow% A JAVA FOLDER COULD NOT BE FOUND IN THE UNIVERSALATOR STORED FILES. %blue%
  ECHO: & ECHO       CHECKING THE FIREWALL RULE CAN ONLY BE DONE ONCE A %green% LAUNCH %blue% HAS
  ECHO       BEEN DONE AND THE JAVA TO BE USED IS INSTALLED. & ECHO: & ECHO:
  PAUSE
  GOTO :mainmenu
)

:: Presets a variable to use as a search string versus java folder names.
IF !JAVAVERSION!==8 SET FINDFOLDER=jdk8u
IF !JAVAVERSION!==11 SET FINDFOLDER=jdk-11
IF !JAVAVERSION!==16 SET FINDFOLDER=jdk-16
IF !JAVAVERSION!==17 SET FINDFOLDER=jdk-17
IF !JAVAVERSION!==21 SET FINDFOLDER=jdk-21

:: Uses ver >nul to ensure that the errorlevel is reset to 0, before testing. 
ver >nul

SET "JAVAFOLDER="
FOR /F "delims=" %%A IN ('DIR /B univ-utils\java') DO (
  ECHO "%%A" | FINDSTR "!FINDFOLDER!" >nul && SET "JAVAFOLDER=%%A"
)

IF NOT DEFINED JAVAFOLDER (
    CLS
    ECHO: & ECHO: & ECHO   %yellow% A FOLDER FOR THE JAVA TO BE USED COULD NOT BE FOUND IN THE UNIVERSALATOR STORED FILES. %blue%
    ECHO: & ECHO       CHECKING THE FIREWALL RULE CAN ONLY BE DONE ONCE A %green% LAUNCH %blue% HAS
    ECHO       BEEN DONE AND THE JAVA TO BE USED IS INSTALLED. & ECHO: & ECHO:
    PAUSE
    GOTO :mainmenu
)

SET FOUNDGOODFIREWALLRULE=IDK

REM Uses the determined java file/folder location to look for a firewall rule set to use the java.exe
REM This is done by looking at the latest.log file for a successful world spawn gen, which usually means that the server fully loaded at least once, giving the user time to accept the firewall 'allow'.
REM If the java version / folder was just installed in this window session, skip this check entirely.  The variable could be un-set but it's easier to avoid shennanigans if it's just disabled for the rest of the session.
REM If the Private firewall is turned off, skip this check entirely
FOR /F "delims=" %%A IN ('powershell -Command "$data = Get-NetFirewallProfile -Name Private; $data.Enabled"') DO IF "%%A" NEQ "True" SET FOUNDGOODFIREWALLRULE=Y & GOTO :firewallresult
REM Checks for firewall rules set for {inbound / true / allow}, with the strings {TCP} and {JAVAFOLDERPATH} in the line.
SET "LONGJAVAFOLDER=%HERE%\univ-utils\java\!JAVAFOLDER!\bin\java.exe"

FOR /F "delims=" %%A IN ('powershell -Command "$data = Get-NetFirewallRule -Direction Inbound -Enabled True -Action Allow; $data.name"') DO (
  REM Uses string replacement to check for TCP in the line, and if found echos the string to a FINDSTR to look for the java folder path.
  SET TEMP=%%A
  IF "!TEMP!" NEQ "!TEMP:TCP=x!" IF "!TEMP!" NEQ "!TEMP:%LONGJAVAFOLDER%=x!" SET FOUNDGOODFIREWALLRULE=Y
)

:firewallresult

IF !FOUNDGOODFIREWALLRULE!==Y (
  CLS
  ECHO: & ECHO: & ECHO:
  ECHO   %green% A GOOD FIREWALL RULE WAS DETECTED %blue% & ECHO: & ECHO:
  ECHO   AT THE LOCATION -
  ECHO   %yellow% %LONGJAVAFOLDER% %blue% & ECHO: & ECHO: & ECHO:
  ECHO   %green% ** PRESS ANY KEY TO CONTINUE ** %blue% & ECHO: & ECHO:
  PAUSE
)

IF !FOUNDGOODFIREWALLRULE! NEQ Y (
  CLS
  ECHO: & ECHO: & ECHO:
  ECHO   %red% CONCERN - NO WINDOWS FIREWALL PASS RULE FOR THE INSTALLED JAVA DETECTED - CONCERN %blue%
  ECHO   %green% ** IF YOU THINK THIS MESSAGE IS INCORRECT YOU CAN STILL PRESS ANY KEY TO CONTINUE ** %blue% & ECHO:
  ECHO   %blue% IT LOOKS LIKE THIS SERVER FOLDER HAS SUCCESSFULLY RUN PREVIOUSLY WITH THE SAME MINECRAFT VERSION, %blue%
  ECHO   %blue% BUT NO WINDOWS FIREWALL RULE WAS FOUND FOR THE java.exe SET TO: %blue% & ECHO:
  ECHO   %blue% 'Direction:Inbound' / 'Action':'Allow' / 'Enabled':'True' %blue% & ECHO:
  ECHO    %LONGJAVAFOLDER% & ECHO:
  ECHO        %yellow% - YOU SHOULD GO TO WINDOWS FIREWALL SETTINGS AND REMOVE ANY EXISTING FIREWALL RULES COVERING %blue%
  ECHO        %yellow%   THIS java.exe LOCATION ^(LISTED ABOVE^), AND ANY RULES COVERING THE PORT YOU HAVE SET. %blue%
  ECHO        %yellow% - THEN LAUNCH THE SERVER AGAIN AND. JUST. PRESS. 'Allow' ON THE %blue%
  ECHO        %yellow%   WINDOWS NOTIFICATION POP-UP THAT COMES UP WHILE LAUNCHING. %blue% & ECHO:
  ECHO     HINT - The default Java that Universalator uses is published by Adoptium.net and
  ECHO     will be named 'OpenJDK Platform binary' & ECHO: & ECHO: & ECHO:
  ECHO   %green% ** IF YOU THINK THIS MESSAGE IS INCORRECT YOU CAN STILL PRESS ANY KEY TO CONTINUE ** %blue% & ECHO: & ECHO:
  PAUSE
)

GOTO :mainmenu

:restarttoggle

IF DEFINED RESTART IF !RESTART!==N (
  SET RESTART=Y
) ELSE (
  SET RESTART=N
)
IF NOT DEFINED RESTART SET RESTART=Y

IF !RESTART!==Y (
  CLS
  ECHO: & ECHO: & ECHO:
  ECHO   %green% AUTOMATIC RESTARTS ARE ENABLED %blue% & ECHO: & ECHO:
  ECHO   %yellow% SERVER PROCESS WILL RESTART UP TO 5 TIMES, %blue% & ECHO   %yellow% UNLESS IT IS PURPOSELY STOPPED USING THE /STOP COMMAND. %blue% & ECHO: & ECHO: & ECHO:
  ECHO   %green% ** PRESS ANY KEY TO CONTINUE ** %blue% & ECHO: & ECHO:
  PAUSE
) ELSE (
  CLS
  ECHO: & ECHO: & ECHO:
  ECHO   %yellow% AUTOMATIC RESTARTS ARE DISABLED %blue% & ECHO: & ECHO:
  ECHO   %yellow% SERVER PROCESS WILL NOT RESTART ITSELF. %blue% & ECHO: & ECHO:
  ECHO   %green% ** PRESS ANY KEY TO CONTINUE ** %blue% & ECHO: & ECHO:
  PAUSE
)
GOTO :mainmenu

:: FUNCTIONS

:: Function to edit the server.properties file.  The function is passed two parameters, a property %1 and value %2.  Only one entry is evaluated and changed.
:: If the value is the same as what's in the file then nothing is actually changed.  Using setlocal and endlocal throws away any variables assigned in the funciton once it ends.
:serverpropsedit
setlocal
SET /a idx=0
SET changedvalue=N

:: Sets equals sign as a delimeter
FOR /F tokens^=^1^,^2^ delims^=^= %%A IN (server.properties) DO (
  SET "property[!idx!]=%%A"
  SET "value[!idx!]=%%B"
  IF "%1"=="%%A" IF "%2" NEQ "%%B" (
    SET "value[!idx!]=%2"
    SET changedvalue=Y
  )
  SET /a idx+=1
)
IF !changedvalue!==Y (
  type NUL > server.properties
  FOR /L %%A IN (0,1,!idx!) DO (
    REM If the value is not blank then print both as property=value to the temp file.
    IF [!value[%%A]!] NEQ [] (
      ECHO !property[%%A]!=!value[%%A]!>>server.properties
    ) ELSE (
      REM Only continues with blank values if property is not also blank (blank line).
      IF [!property[%%A]!] NEQ [] (
        REM Prints lines with comment # as only the first value.  Prints lines without # as property=value.
        IF "!property[%%A]:#=x!"=="!property[%%A]!" ECHO !property[%%A]!=!value[%%A]!>>server.properties
        IF "!property[%%A]:#=x!" NEQ "!property[%%A]!" ECHO !property[%%A]!>>server.properties
      )
    )
  )
)
endlocal
GOTO:EOF


:: FUNCTION USED FOR DETERMINING MAX CHARACTER LENGTH
:GetMaxStringLength

:: Usage :GetMaxStringLength <OutVariableName> <StringToBeMeasured>
:: Note - OutVariableName may already have an initial value
SET StrTest=%~2
:: Just add zero, in case the initial value is empty
SET /A %1+=0
:: Maximum length we will allow, modify appended spaces accordingly
SET MaxLength=80
IF %MaxLength% GTR !%1! (
	FOR /L %%e IN (!%1!,1,%MaxLength%) DO (
		IF NOT "!StrTest:~%%e!"=="" (
			SET /A %1=%%e+1
		)
	)
)
GOTO:EOF


:: FUNCTION TO REPLACE STRINGS WITHIN VARIABLE STRINGS - hot stuff!
:: l_replace function - reworked to allow any variable name passed to alter.  Needs 4 paramters passed.

:: 4 Paramters:     <variable to edit> <string to find> <replacement string> <variable to edit name>
:: EXAMPLE:         CALL :l_replace "!TEMP!" "=" ";" "TEMP"

:: 1= string to edit / 2= find string / 3= replace string / 4= passed variable name
:l_replace
SET "%~4=x%~1x"
:l_replaceloop
FOR /f "delims=%~2 tokens=1*" %%x IN ("!%~4!") DO (
IF "%%y"=="" SET "%~4=!%~4:~1,-1!" & EXIT /b
SET "%~4=%%x%~3%%y"
)
GOTO :l_replaceloop


REM Function to edit the Universalator settings file

:univ_settings_edit

FOR /F "delims=" %%A IN ('type settings-universalator.txt') DO (
  FOR /F "tokens=1,2 delims==" %%B IN ("%%A") DO (
    SET "TEMP=%%B"
 
    IF "%%B" NEQ "SET %~1" ECHO %%A>>x.txt
    IF "%%B"=="SET %~1" ECHO %%B=%~2>>x.txt

  )
)
IF EXIST x.txt (
  DEL settings-universalator.txt >nul
  REN x.txt settings-universalator.txt >nul
)
GOTO :EOF


REM Trim function - pass two parameters - CALL :trim variablevalue variablename

REM !TEMP:~-1! - gets the last character
REM !TEMP:~0,-1!" - gets all but the last character

:trim
SET "TEMP=%~1"
:trimagain
IF "!TEMP:~-1!"==" " (
  SET "TEMP=!TEMP:~0,-1!"
  GOTO :trimagain
) ELSE ( 
  SET "%~2=!TEMP!"
  EXIT /B 
)
GOTO :EOF
