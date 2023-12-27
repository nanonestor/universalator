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

:: Sets the title and backgound color of the command window
TITLE Universalator
color 1E
prompt [universalator]:
::  The defaut JVM arguments that will print out for use in the settings file that gets created.  Users can edit this settings file to edit their JVM arguments to be used for launching.
SET ARGS=-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:+DisableExplicitGC -XX:+PerfDisableSharedMem -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -XX:MaxTenuringThreshold=1 -XX:SurvivorRatio=32 -XX:MaxGCPauseMillis=100 -XX:GCPauseIntervalMillis=150 -XX:TargetSurvivorRatio=90 -XX:+UseFastAccessorMethods -XX:+UseCompressedOops -XX:ReservedCodeCacheSize=400M -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1NewSizePercent=30 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20
:: Additional JVM arguments that will always be applied
SET OTHERARGS=-XX:+IgnoreUnrecognizedVMOptions -XX:+AlwaysActAsServerClassMachine -Dlog4j2.formatMsgNoLookups=true
:: These variables set to exist as blank in case windows is older than 10 and they aren't assigned otherwise
SET "yellow="
SET "blue="
:: Sets a HERE variable equal to the current directory string.
SET "HERE=%cd%"

SET "DELAY=ping -n 2 127.0.0.1 >nul"

:: BEGIN CHECKING OPERATING SYSTEM TYPE
:: Sets a variable to figure out which OS the script is being run from.  Because powershell for Linux exists!  It can be used later to determine whether to run various things.
:: IF the BAT is run from Linux or OSX it's intended that it's run through powershell with a parameter %1 to set the OSTYPE.
:: Using the Linux/OSX powershell is unreiable at figuring out it's own OSTYPE, so this is the easiest option to set that.
IF [%1] NEQ [] (
  SET "OSTYPE=%1" 
) ELSE (
  :: If no %1 parameter was passed then default to WINDOWS
  SET "OSTYPE=WINDOWS"
)
:: If a non wanted parameter was passed give error message - entering 'windows' as a parameter passes this test also
IF /I "!OSTYPE!" NEQ "WINDOWS" IF /I "!OSTYPE!" NEQ "LINUX" IF /I "!OSTYPE!" NEQ "OSX" IF /I "!OSTYPE!" NEQ "TUX" (
  CLS
  ECHO: & ECHO: & ECHO   THIS BAT FILE WAS LAUNCHED WITH AN EXTRA PARAMETER THAT WAS NOT RECOGNIZED: & ECHO   '!OSTYPE!' & ECHO: & ECHO   THE ONLY RECOGNIZED PARAMETERS ARE 'linux' AND 'osx' & ECHO: & ECHO:
  PAUSE
  COLOR 07 & CLS & EXIT [\B]
)
:: Reformat the variables to guarantee all caps
IF /I "!OSTYPE!" EQU "LINUX" SET "OSTYPE=LINUX"
IF /I "!OSTYPE!" EQU "TUX" SET "OSTYPE=LINUX"
IF /I "!OSTYPE!" EQU "OSX" SET "OSTYPE=OSX"
IF /I "!OSTYPE!" EQU "WINDOWS" SET "OSTYPE=WINDOWS"

:: TEST LINES FOR WINDOW RESIZING - KIND OF SCREWEY NEEDS FURTHER CHECKS
::mode con: cols=160 lines=55
::powershell -command "&{$H=get-host;$W=$H.ui.rawui;$B=$W.buffersize;$B.width=160;$B.height=9999;$W.buffersize=$B;}

:: WINDOWS VERSION CHECK
:: Versions equal to or older than Windows 8 (internal version number 6.2) will stop the script with warning.
for /f "tokens=4-7 delims=[.] " %%i in ('ver') do (if %%i==Version (
    set major=%%j
    set minor=%%k 
    ) else (
    set major=%%i
    set minor=%%j
    ))
:: If Windows is older than 10 tells user the sad news that they are not supported.
:: If Windows is greater than or equal to version 10 then set some variables to set console output colors!  Then skip OS warning.
IF %major% LEQ 9 (
    ECHO: & ECHO: & ECHO:
    ECHO   YOUR WINDOWS VERSION IS OLD ENOUGH TO NOT BE SUPPORTED & ECHO:
    ECHO   UPDATING TO WINDOWS 10 OR GREATER IS HIGHLY RECOMMENDED
    ECHO:
    PAUSE & EXIT [\B]
)
IF %major% GEQ 10 (
  SET yellow=[34;103m
  SET blue=[93;44m
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
  ECHO. & ECHO. & ECHO. & ECHO   %yellow% PROBLEM DETECTED %blue% & ECHO. & ECHO      %red% "%cd%" %blue% & ECHO. & ECHO      THE ABOVE FOLDER LOCATION ENDS IN A SPECIAL CHARACTER - %red% ^!LASTCHAR! %blue% & ECHO:
  ECHO      REMOVE THIS SPECIAL CHARACTER FROM THE END OF OF THE FOLDER NAME OR USE A DIFFERENT FOLDER & ECHO: & ECHO: & ECHO:
  ECHO        ** SPECIAL CHARACTERS AT THE END OF FOLDER NAMES BREAKS CERTAIN COMMAND FUNCTIONS THE SCRIPT USES
  ECHO: & ECHO: & ECHO: & ECHO: & ECHO: & ECHO: & ECHO:
  PAUSE & EXIT [\B]
)

:: Checks to see if an exclamation mark is found anywhere in the folder path, which breaks many commands in the script.  Disabling delayed expansion could be done to detect it a different way.
FOR /F "delims=" %%A IN ('powershell -Command "ECHO (get-location).path | FINDSTR "^^!""') DO SET ISEXCLFOUND=%%A
IF DEFINED ISEXCLFOUND IF "%CD%"=="!ISEXCLFOUND!" (
    setlocal disabledelayedexpansion
    ECHO. & ECHO. & ECHO. & ECHO   %yellow% PROBLEM DETECTED %blue% & ECHO. & ECHO   %red% "%cd%" %blue% & ECHO. & ECHO   THE ABOVE FOLDER PATH CONTAINS AN EXCLAMATION MARK CHARACTER  - %red% ^! %blue% & ECHO.
    ECHO   INCLUDING THIS CHARACTER IN FOLDER NAMES CAN BREAK THE FUNCTIONS IN THE PROGRAM. & ECHO   CHANGE FOLDER NAMES TO REMOVE THE EXCLAMATION MARK %red% ^! %blue% & ECHO: & ECHO: & ECHO:
    PAUSE & EXIT [/B]
    setlocal enabledelayedexpansion
)

:: Checks to see if there are environmental variables trying to set global ram allocation values!  This is a real thing!
:: Check for _JAVA_OPTIONS
IF NOT DEFINED _JAVA_OPTIONS GOTO :skipjavopts
IF DEFINED _JAVA_OPTIONS (
  ECHO %_JAVA_OPTIONS% | FINDSTR /i "xmx xmn" 1>NUL
)
  IF %ERRORLEVEL%==0 (
    ECHO:
    ECHO  %yellow% WARNING - IT WAS DETECTED THAT YOU HAVE THE WINDOWS ENVIRONMENTAL VARIABLE %blue%
    ECHO  %yellow% NAMED %blue% _JAVA_OPTIONS %yellow% SETTING GLOBAL RAM MEMORY VALUES SUCH AS -Xmx or -Xmn %blue%
    ECHO:
    ECHO  %yellow% PLEASE REMOVE THIS VALUE FROM THE VARIABLE SO THAT YOUR SERVER WILL LAUNCH CORRECTLY! %blue%
    ECHO:
    ECHO  IF YOU DON'T KNOW HOW - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
    ECHO  https://github.com/nanonestor/universalator/wiki
    ECHO:
    PAUSE & EXIT [\B]
  )
:skipjavopts

: Check for JDK_JAVA_OPTIONS
IF NOT DEFINED JDK_JAVA_OPTIONS GOTO :skipjdkjavaoptions
IF DEFINED JDK_JAVA_OPTIONS (
  ECHO %JDK_JAVA_OPTIONS% | FINDSTR /i "xmx xmn" 1>NUL
)
  IF %ERRORLEVEL%==0 (
    ECHO:
    ECHO  %yellow% WARNING - IT WAS DETECTED THAT YOU HAVE THE WINDOWS ENVIRONMENTAL VARIABLE %blue%
    ECHO  %yellow% NAMED %blue% JDK_JAVA_OPTIONS %yellow% SETTING GLOBAL RAM MEMORY VALUES SUCH AS -Xmx or -Xmn %blue%
    ECHO:
    ECHO  %yellow% PLEASE REMOVE THIS VALUE FROM THE VARIABLE SO THAT YOUR SERVER WILL LAUNCH CORRECTLY! %blue%
    ECHO:
    ECHO  IF YOU DON'T KNOW HOW - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
    ECHO  https://github.com/nanonestor/universalator/wiki
    ECHO:
    PAUSE & EXIT [\B]
  )
:skipjdkjavaoptions

:: Check for JAVA_TOOL_OPTIONS
IF NOT DEFINED JAVA_TOOL_OPTIONS GOTO :skipjavatooloptions
IF DEFINED JAVA_TOOL_OPTIONS (
  ECHO %JAVA_TOOL_OPTIONS% | FINDSTR /i "xmx xmn" 1>NUL
)
  IF %ERRORLEVEL%==0 (
    ECHO:
    ECHO  %yellow% WARNING - IT WAS DETECTED THAT YOU HAVE THE WINDOWS ENVIRONMENTAL VARIABLE %blue%
    ECHO  %yellow% NAMED %blue% JAVA_TOOL_OPTIONS %yellow% SETTING GLOBAL RAM MEMORY VALUES SUCH AS -Xmx or -Xmn %blue%
    ECHO:
    ECHO  %yellow% PLEASE REMOVE THIS VALUE FROM THE VARIABLE SO THAT YOUR SERVER WILL LAUNCH CORRECTLY! %blue%
    ECHO:
    ECHO  IF YOU DON'T KNOW HOW - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
    ECHO  https://github.com/nanonestor/universalator/wiki
    ECHO:
    PAUSE & EXIT [\B]
  )
:skipjavatooloptions


:: The below SET PATH only applies to this command window launch and isn't permanent to the system's PATH.
:: It's only done if the tests fail to find the entries in the 'System PATH' environment variable, which they should be as default in Windows.
:: Fun fact - in a FINDSTR search string, backslash \ is the special character escape character.

ECHO %PATH% | FINDSTR /L /C:C\:\Windows\System32\; >nul 2>&1 || SET "PATH=%PATH%C:\Windows\System32;"
ECHO %PATH% | FINDSTR /L /C:C\:\Windows\System32\Wbem\; >nul 2>&1 || SET "PATH=%PATH%C:\Windows\System32\Wbem;"
ECHO %PATH% | FINDSTR /L /C:C\:\Windows\SysWOW64\; >nul 2>&1 || SET "PATH=%PATH%C:\Windows\SysWOW64;"
ECHO %PATH% | FINDSTR /L /C:C\:\Windows\System32\WindowsPowerShell\v1.0\\; >nul 2>&1 || SET "PATH=%PATH%C:\Windows\System32\WindowsPowerShell\v1.0\;"

:: Checks to see if CMD is working by checking WHERE for some commands - if the WHERE fails then a variable is set.
WHERE FINDSTR >nul 2>&1 || SET CMDBROKEN=Y
WHERE CERTUTIL >nul 2>&1 || SET CMDBROKEN=Y
WHERE NETSTAT >nul 2>&1 || SET CMDBROKEN=Y
WHERE PING >nul 2>&1 || SET CMDBROKEN=Y
WHERE CURL >nul 2>&1 || SET CMDBROKEN=Y
WHERE TAR >nul 2>&1 || SET CMDBROKEN=Y

IF DEFINED CMDBROKEN IF !CMDBROKEN!==Y (
  ECHO:
  ECHO        %yellow% WARNING - PROBLEM DETECTED %blue%
  ECHO        %yellow% CMD / COMMAND PROMPT FUNCTIONS ARE NOT WORKING CORRECTLY ON YOUR WINDOWS INSTALLATION. %blue%
  ECHO:
  ECHO             FOR REPAIR SOLUTIONS
  ECHO             SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
  ECHO:
  ECHO             %green% https://github.com/nanonestor/universalator/wiki/4-Troubleshooting %blue%
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

ECHO "%LOC%" | FINDSTR /i "curseforge atlauncher at_launcher gdlauncher gd_launcher" 1>NUL && (
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
:: Detects if the OS is Windows, if it isn't, then skip checking the hosts file
IF !OSTYPE! NEQ WINDOWS GOTO :skiphostscheck
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

IF EXIST settings-universalator.txt (
  RENAME settings-universalator.txt settings-universalator.bat && CALL settings-universalator.bat && RENAME settings-universalator.bat settings-universalator.txt
)
IF /I !MODLOADER!==FORGE SET FORGE=!MODLOADERVERSION!
IF /I !MODLOADER!==NEOFORGE SET NEOFORGE=!MODLOADERVERSION!
IF /I !MODLOADER!==FABRIC SET FABRICLOADER=!MODLOADERVERSION!
IF /I !MODLOADER!==QUILT SET QUILTLOADER=!MODLOADERVERSION!
IF DEFINED MAXRAMGIGS SET MAXRAM=-Xmx!MAXRAMGIGS!G
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

:portcheckup
:: BEGIN CHECKING IF CURRENT PORT SET IN server.properties IS ALREADY IN USE
:: Assume server.properties exists
FOR /F %%A IN ('findstr server-port server.properties') DO SET PROPSPORT=%%A
IF DEFINED PROPSPORT IF "%PROPSPORT%" NEQ "" SET PORTSET=%PROPSPORT:~12%
IF NOT DEFINED PROPSPORT SET PORTSET=25565

ver > nul
NETSTAT -o -n -a | FINDSTR %PORTSET%
:: If port was not found already after checking netstat entries then assume it's being used and run warning/process kill screen
IF %ERRORLEVEL%==1 GOTO :skipportclear

IF EXIST pid.txt DEL pid.txt && IF EXIST pid2.txt DEL pid2.txt && IF EXIST pid3.txt DEL pid3.txt


for /F "delims=" %%A IN ('netstat -aon') DO (
    ECHO %%A>>pid.txt
)

set idx=0
FOR /F "delims=" %%A IN ('findstr %PORTSET% pid.txt') DO (
    SET BEE[!idx!]=%%A
    set /a idx+=1
)
IF NOT DEFINED BEE[0] GOTO :skipportclear


FOR /F "tokens=5 delims= " %%B IN ("!BEE[0]!") DO (
    SET PIDNUM=%%B
)

FOR /F "delims=" %%C IN ('TASKLIST /fi "pid eq !PIDNUM!"') DO (
    ECHO %%C>>pid3.txt
)
SET idx=0
FOR /F "delims=" %%D IN ('findstr !PIDNUM! pid3.txt') DO (
    SET BOO[!idx!]=%%D
    set /a idx+=1
)
FOR /F "tokens=1,3,4 delims= " %%E IN ("!BOO[0]!") DO (
    SET IMAGENAME=%%E
    SET SESSIONNAME=%%F
    SET SESSIONNUM=%%G
)


IF EXIST pid.txt DEL pid.txt && IF EXIST pid2.txt DEL pid2.txt && IF EXIST pid3.txt DEL pid3.txt

:portwarning
  CLS
  ECHO: & ECHO:
  ECHO   %yellow% WARNING - PORT ALREADY IN USE - WARNING %blue%
  ECHO:
  ECHO   CURRENT %yellow% PORT SET = %PORTSET% %blue%
  ECHO:
  ECHO   IT IS DETECTED THAT THE PORT CURRENTLY SET (SHOWN ABOVE)
  ECHO   IN THE SETTINGS FILE server.properties %yellow% IS ALREADY IN USE %blue%
  ECHO:
  ECHO   THE FOLLOWING IS THE PROCESS RUNNING THAT APPEARS TO BE USING THE PORT
  ECHO   MINECRAFT SERVERS WILL USUALLY CONTAIN THE NAMES java.exe AND Console
  ECHO:
  ECHO   IMAGE NAME - %IMAGENAME%
  ECHO   SESSION NAME - %SESSIONNAME%
  ECHO   PID NUMBER - %PIDNUM%
  ECHO:
  ECHO   %yellow% WARNING - PORT ALREADY IN USE - WARNING %blue%
  ECHO:
  ECHO   Type 'KILL' to try and let the script close the program using the port already.
  ECHO   Type 'Q' to close the script program if you'd like to try and solve the issue on your own.
  ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P "KILLIT="
  IF /I !KILLIT! NEQ KILL IF /I !KILLIT! NEQ Q GOTO :portwarning
  IF /I !KILLIT!==Q (
    PAUSE & EXIT [\B]
  )
  IF /I !KILLIT!==KILL (
    CLS
    ECHO:
    ECHO   ATTEMPTING TO KILL TASK PLEASE WAIT...
    ECHO:
    TASKKILL /F /PID %PIDNUM%
    %DELAY%
  )
ver > nul
NETSTAT -o -n -a | FINDSTR %PORTSET%
IF %ERRORLEVEL%==0 (
  CLS
  ECHO:
  ECHO   OOPS - THE ATTEMPT TO KILL THE TASK PROCESS USING THE PORT SEEMS TO HAVE FAILED
  ECHO:
  ECHO   FURTHER OPTIONS:
  ECHO   --SET A DIFFERENT PORT, OR CLOSE KNOWN SERVERS/PROGRAMS USING THIS PORT.
  ECHO   --IF YOU THINK PORT IS BEING KEPT OPEN BY A BACKGROUND PROGRAM TRY RESTARTING COMPUTER.
  ECHO   --TRY RUNNING THE UNIVERSALATOR SCRIPT AGAIN.
  ECHO: & ECHO: & ECHO: 
  PAUSE & EXIT [\B]
)
IF %ERRORLEVEL%==1 (
  ECHO:
  ECHO   SUCCESS!
  ECHO   IT SEEMS LIKE KILLING THE PROGRAM WAS SUCCESSFUL IN CLEARING THE PORT!
  ECHO:
  %DELAY%
)

:: Below line is purely done to guarantee that the current ERRORLEVEL is reset to 0
:skipportclear
ver > nul
:: END CHECKING IF CURRENT PORT SET IN server.properties IS ALREAY IN USE

:: BEGIN SETTING VARIABLES TO PUBLIC IP AND PORT SETTING

:: Obtains the computer's public IP address by poking a website API service which specifically exists for this purpose - api.bigdatacloud.net is now used, it seems reliably fasteer than the older api.ipify.org used
FOR /F %%B IN ('powershell -Command "$data = ((New-Object System.Net.WebClient).DownloadString('https://api.bigdatacloud.net/data/client-ip') | Out-String | ConvertFrom-Json); $data.ipString"') DO SET PUBLICIP=%%B
:: If trying api.bigdatacloud.net failed to get the public IP then try this different web service at ip-api.com
IF NOT DEFINED PUBLICIP FOR /F %%B IN ('powershell -Command "$data = ((New-Object System.Net.WebClient).DownloadString('http://ip-api.com/json/?fields=query') | Out-String | ConvertFrom-Json); $data.query"') DO SET PUBLICIP=%%B

FOR /F %%A IN ('findstr server-port server.properties') DO SET PORTLINE=%%A
IF DEFINED PORTLINE SET PORT=%PORTLINE:~12%
IF NOT DEFINED PORT SET PORT=25565

IF !PORT! LSS 10000 (
  CLS
  ECHO: & ECHO: & ECHO   %red% CURRENT PORT SET IN server.properties FILE - %blue%%yellow% !PORT! %blue%
  ECHO: & ECHO   %red% DO NOT SET THE PORT TO BE USED BELOW 10000 - BELOW THAT NUMBER IS NOT A GOOD IDEA %blue%
  ECHO: & ECHO   %red% OTHER CRITICAL PROCESSES MAY ALREADY USE PORTS BELOW THIS NUMBER %blue% & ECHO:
  PAUSE & EXIT [\B]
)
:: END SETTING VARIABLES TO PUBLIC IP AND PORT SETTING

:: BEGIN GETTING LOCAL IPV4 ADDRESS TO BE USED

:: If file present (upnp port forwarding = loaded') check to see if port forwarding is activated or not using it.
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
  SET ISUPNPACTIVE=N
  FOR /F "delims=" %%E IN ('univ-utils\miniupnp\upnpc-static.exe -l') DO (
    SET CHECKUPNPSTATUS=%%E
    IF "!CHECKUPNPSTATUS!" NEQ "!CHECKUPNPSTATUS:%PORT%=PORT!" SET ISUPNPACTIVE=Y
    IF "!CHECKUPNPSTATUS!" NEQ "!CHECKUPNPSTATUS:Local LAN ip address=replace!" SET LANLINE=%%E
  )
)
IF DEFINED LANLINE (
  FOR /F "tokens=5 delims=: " %%T IN ("!LANLINE!") DO SET LOCALIP=%%T
)

:: If no UPnP setting of LOCALIP was done - then use ipconfig to get the local IP address
IF NOT DEFINED LOCALIP (
  FOR /F "delims=" %%G IN ('ipconfig') DO (
      SET LOOKFORIPV4=%%G
      :: If the string marking the IPv4 address is found then record it using delims and tokens to get the right string
      IF "!LOOKFORIPV4!" NEQ "!LOOKFORIPV4:IPv4 Address=replace!" (
        FOR /F "tokens=13 delims=: " %%T IN ("!LOOKFORIPV4!") DO SET LOCALIP=%%T
      )
      :: If ethernet and WiFi are both active then the first entry recorded will be ethernet which is probably preferred
      :: Ethernet is listed first always in ipconfig - so if LOCALIP becomes defined the loop gets exited by going to the exitlocalipset label
      IF DEFINED LOCALIP GOTO :exitlocalipset
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

TITLE Universalator
IF EXIST settings-universalator.txt (
  RENAME settings-universalator.txt settings-universalator.bat && CALL settings-universalator.bat && RENAME settings-universalator.bat settings-universalator.txt
  IF DEFINED MAXRAMGIGS IF !MAXRAMGIGS! NEQ "" SET MAXRAM=-Xmx!MAXRAMGIGS!G
  IF /I !MODLOADER!==FORGE SET FORGE=!MODLOADERVERSION!
  IF /I !MODLOADER!==NEOFORGE SET NEOFORGE=!MODLOADERVERSION!
  IF /I !MODLOADER!==FABRIC SET FABRICLOADER=!MODLOADERVERSION!
  IF /I !MODLOADER!==QUILT SET QUILTLOADER=!MODLOADERVERSION!
)
IF NOT EXIST univ-utils MD univ-utils
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
IF DEFINED PORT ECHO   %yellow% CURRENT PORT SET %blue%          !PORT!                            %green% MENU OPTIONS %blue%
ECHO:
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" IF !ISUPNPACTIVE!==N ECHO   %yellow% UPNP STATUS %blue%       %red% NOT ACTIVATED %blue%
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" IF !ISUPNPACTIVE!==Y  ECHO   %yellow% UPNP STATUS %blue%  %green% ACTIVE - FORWARDING PORT %PORT% %blue%
IF EXIST settings-universalator.txt ECHO                                                           %green% L %blue% = LAUNCH SERVER & ECHO:
IF NOT EXIST settings-universalator.txt ECHO                                                           %green% S %blue% = SETTINGS ENTRY
IF EXIST settings-universalator.txt ECHO                                                           %green% S %blue% = RE-ENTER ALL SETTINGS
ECHO                                                           %green% R %blue%    = RAM MAX SETTING
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" ECHO                                                           %green% UPNP %blue% = UPNP PORT FORWARDING MENU
ECHO                                                           %green% SCAN %blue% = SCAN MOD FILES FOR CLIENT MODS & ECHO:
ECHO                                                           %green% A %blue%    = (LIST) ALL POSSIBLE MENU OPTIONS
:allcommandsentry
SET /P SCRATCH="%blue%  %green% ENTER A MENU OPTION:%blue% " <nul
SET /P "MAINMENU="

IF /I !MAINMENU!==Q COLOR 07 & CLS & EXIT [\B]
IF /I !MAINMENU!==UPNP GOTO :upnpmenu
IF /I !MAINMENU!==R GOTO :justsetram
IF /I !MAINMENU!==S GOTO :startover
IF /I !MAINMENU!==J GOTO :javaselect
IF /I !MAINMENU!==L IF EXIST settings-universalator.txt IF DEFINED MINECRAFT IF DEFINED MODLOADER IF DEFINED JAVAVERSION GOTO :actuallylaunch
IF /I !MAINMENU!==SCAN IF EXIST "%HERE%\mods" GOTO :getmcmajor
IF /I !MAINMENU!==SCAN IF NOT EXIST "%HERE%\mods" GOTO :mainmenu
IF /I !MAINMENU!==OVERRIDE GOTO :override
IF /I !MAINMENU!==MCREATOR IF EXIST "%HERE%\mods" GOTO :mcreator
IF /I !MAINMENU!==MCREATOR IF NOT EXIST "%HERE%\mods" GOTO :mainmenu
IF /I !MAINMENU!==A GOTO :allcommands
IF /I !MAINMENU!==ZIP GOTO :zipit

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
ECHO:    %green% SCAN %blue% = SCAN MOD FILES FOR CLIENT ONLY MODS & ECHO:
ECHO:    %green% UPNP %blue% = UPNP PORT FORWARDING MENU & ECHO:
ECHO:    %green% MCREATOR %blue% = SCAN MOD FILES FOR MCREATOR MADE MODS & ECHO:
ECHO:    %green% OVERRIDE %blue% = USE CURRENTLY SET SYSTEM JAVA PATH INSTEAD OF UNIVERSALATOR JAVA & ECHO:
ECHO:    %green% ZIP %blue% = MENU FOR CREATING SERVER PACK ZIP FILE & ECHO: & ECHO: & ECHO:
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

:: Checks to see if the MC just entered begins with 1. as a simple pass in case something else was entered.  Until Minecraft 2 happens this will be fine.
:: Also checks if an entry was even made, and if there are any spaces in the entry.
IF NOT DEFINED MINECRAFT GOTO :startover
IF "!MINECRAFT:~0,2!" NEQ "1." GOTO :startover
IF "!MINECRAFT!" NEQ "!MINECRAFT: =!" GOTO :startover
ECHO !MINECRAFT! | FINDSTR "[a-z] [A-Z]" && GOTO :startover


:: IF running SCAN from main menu it gets placed here first to get values for MC major and minor versions.
:getmcmajor

:: Stores the major and minor Minecraft version numbers in their own variables as integers.
SET "MCMINOR="
FOR /F "tokens=2,3 delims=." %%E IN ("!MINECRAFT!") DO (
    SET /a MCMAJOR=%%E
    SET /a MCMINOR=%%F
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

:: Corrects entry to be all capital letters if not already entered by user.
IF /I !MODLOADER!==FORGE SET MODLOADER=FORGE
IF /I !MODLOADER!==FABRIC SET MODLOADER=FABRIC
IF /I !MODLOADER!==QUILT SET MODLOADER=QUILT
IF /I !MODLOADER!==NEOFORGE SET MODLOADER=NEOFORGE
IF /I !MODLOADER!==VANILLA SET MODLOADER=VANILLA
IF /I !MODLOADER! NEQ FORGE IF /I !MODLOADER! NEQ FABRIC IF /I !MODLOADER! NEQ NEOFORGE IF /I !MODLOADER! NEQ QUILT IF /I !MODLOADER! NEQ VANILLA GOTO :reentermodloader


:: Detects if settings are trying to use some weird old Minecraft Forge version that isn't supported.
:: This is done again later after the settings-universalator.txt is present and this is section is skipped.
IF /I !MODLOADER!==FORGE IF !MCMAJOR! LSS 10 IF !MINECRAFT! NEQ 1.6.4 IF !MINECRAFT! NEQ 1.7.10 IF !MINECRAFT! NEQ 1.8.9 IF !MINECRAFT! NEQ 1.9.4 (
  CLS
  ECHO: & ECHO: & ECHO: & ECHO:
  ECHO    %yellow% SORRY - YOUR ENTERED MINECRAFT VERSION - FORGE FOR MINECRAFT !MINECRAFT! - IS NOT SUPPORTED. %blue%
  ECHO:
  ECHO    %yellow% FIND A MODPACK WITH A MORE POPULARLY USED VERSION. %blue%
  ECHO    OR
  ECHO    PRESS ANY KEY TO START OVER AND ENTER NEW VERSION NUMBERS
  ECHO:
  PAUSE
  GOTO :startover
)

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
  IF EXIST "%HERE%\univ-utils\maven-fabric-metadata.xml" IF /I !MODLOADER!==FABRIC FOR /F %%G IN ('powershell -Command "Test-Path '%HERE%\univ-utils\maven-fabric-metadata.xml' -OlderThan (Get-Date).AddHours(-6)"') DO SET XMLAGE=%%G
  IF EXIST "%HERE%\univ-utils\maven-quilt-metadata.xml" IF /I !MODLOADER!==QUILT FOR /F %%G IN ('powershell -Command "Test-Path '%HERE%\univ-utils\maven-quilt-metadata.xml' -OlderThan (Get-Date).AddHours(-6)"') DO SET XMLAGE=%%G

:: If XMLAGE is True then a new maven metadata file is obtained.  Any existing is silently deleted.  If the maven is unreachable by ping then no file delete and download is done, so any existing old file is preserved.
IF /I !MODLOADER!==FABRIC IF /I !XMLAGE!==True (
    DEL "%HERE%\univ-utils\maven-fabric-metadata.xml" >nul 2>&1
    curl -sLfo "%HERE%\univ-utils\maven-fabric-metadata.xml" https://maven.fabricmc.net/net/fabricmc/fabric-loader/maven-metadata.xml >nul 2>&1
    IF NOT EXIST "%HERE%\univ-utils\maven-fabric-metadata.xml"  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.fabricmc.net/net/fabricmc/fabric-loader/maven-metadata.xml', 'univ-utils\maven-fabric-metadata.xml')" >nul
)
IF /I !MODLOADER!==QUILT IF /I !XMLAGE!==True (
    DEL "%HERE%\univ-utils\maven-quilt-metadata.xml" >nul 2>&1
    curl -sLfo "%HERE%\univ-utils\maven-quilt-metadata.xml" https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-loader/maven-metadata.xml >nul 2>&1
    IF NOT EXIST "%HERE%\univ-utils\maven-quilt-metadata.xml"  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-loader/maven-metadata.xml', 'univ-utils\maven-quilt-metadata.xml')" >nul
)
:: Skips over the oops message if a maven metadata file was found
IF EXIST "%HERE%\univ-utils\maven-fabric-metadata.xml" IF /I !MODLOADER!==FABRIC GOTO :skipmavenoopsfabric
IF EXIST "%HERE%\univ-utils\maven-quilt-metadata.xml" IF /I !MODLOADER!==QUILT GOTO :skipmavenoopsfabric

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
FOR /F %%A IN ('powershell -Command "$data = [xml](Get-Content -Path univ-utils\maven-fabric-metadata.xml); $data.metadata.versioning.release"') DO SET FABRICLOADER=%%A
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
:: Checks if any blank spaces were in the entry.
IF "!FABRICLOADER!" NEQ "!FABRICLOADER: =!" GOTO :redofabricloader

:: If custom Fabric Loader was entered check on the maven XML file that it is a valid version
FOR /F %%A IN ('powershell -Command "$data = [xml](Get-Content -Path univ-utils\maven-fabric-metadata.xml); $data.metadata.versioning.versions.version"') DO (
  IF %%A==!FABRICLOADER! GOTO :setjava
)
:: If this point is reached then no valid Fabric Loader version was found on the maven - go to the oops message
GOTO :oopsnovalidfabricqulit

:: If Quilt modloader ask user to enter version or Y for newest detected.
:enterquilt
:: Gets the newest release version available from the current maven mavendata file.
FOR /F %%A IN ('powershell -Command "$data = [xml](Get-Content -Path univ-utils\maven-quilt-metadata.xml); $data.metadata.versioning.release"') DO SET QUILTLOADER=%%A
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

:: Checks if any blank spaces were in the entry.
IF "!QUILTLOADER!" NEQ "!QUILTLOADER: =!" GOTO :redofabricloader

:: If custom Quilt Loader was entered check on the maven XML file that it is a valid version
FOR /F %%A IN ('powershell -Command "$data = [xml](Get-Content -Path univ-utils\maven-quilt-metadata.xml); $data.metadata.versioning.versions.version"') DO (
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
  IF EXIST "%HERE%\univ-utils\maven-forge-metadata.xml" IF /I !MODLOADER!==FORGE FOR /F %%G IN ('powershell -Command "Test-Path '%HERE%\univ-utils\maven-forge-metadata.xml' -OlderThan (Get-Date).AddHours(-2)"') DO SET XMLAGE=%%G
  IF EXIST "%HERE%\univ-utils\maven-neoforge-1.20.1-metadata.xml" IF /I !MODLOADER!==NEOFORGE IF !MINECRAFT!==1.20.1 FOR /F %%G IN ('powershell -Command "Test-Path '%HERE%\univ-utils\maven-neoforge-1.20.1-metadata.xml' -OlderThan (Get-Date).AddHours(-2)"') DO SET XMLAGE=%%G
  IF EXIST "%HERE%\univ-utils\maven-neoforge-metadata.xml" IF /I !MODLOADER!==NEOFORGE IF !MINECRAFT! NEQ 1.20.1 FOR /F %%G IN ('powershell -Command "Test-Path '%HERE%\univ-utils\maven-neoforge-metadata.xml' -OlderThan (Get-Date).AddHours(-2)"') DO SET XMLAGE=%%G

:: If XMLAGE is True then a new maven metadata file is obtained.  Any existing is silently deleted.  If the maven is unreachable by ping then no file delete and download is done, so any existing old file is preserved.
IF /I !MODLOADER!==FORGE IF /I !XMLAGE!==True (
    DEL "%HERE%\univ-utils\maven-forge-metadata.xml" >nul 2>&1
    curl -sLfo "%HERE%\univ-utils\maven-forge-metadata.xml" https://maven.minecraftforge.net/net/minecraftforge/forge/maven-metadata.xml >nul 2>&1
    IF NOT EXIST "%HERE%\univ-utils\maven-forge-metadata.xml"  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/maven-metadata.xml', 'univ-utils\maven-forge-metadata.xml')" >nul
)
IF /I !MODLOADER!==NEOFORGE IF !MINECRAFT!==1.20.1 IF /I !XMLAGE!==True (
    DEL "%HERE%\univ-utils\maven-neoforge-1.20.1-metadata.xml" >nul 2>&1
    curl -sLfo "%HERE%\univ-utils\maven-neoforge-1.20.1-metadata.xml" https://maven.neoforged.net/releases/net/neoforged/forge/maven-metadata.xml >nul 2>&1
    IF NOT EXIST "%HERE%\univ-utils\maven-neoforge-1.20.1-metadata.xml"  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.neoforged.net/releases/net/neoforged/forge/maven-metadata.xml', 'univ-utils\maven-neoforge-1.20.1-metadata.xml')" >nul
)
IF /I !MODLOADER!==NEOFORGE IF !MINECRAFT! NEQ 1.20.1 IF /I !XMLAGE!==True (
    DEL "%HERE%\univ-utils\maven-neoforge-metadata.xml" >nul 2>&1
    curl -sLfo "%HERE%\univ-utils\maven-neoforge-metadata.xml" https://maven.neoforged.net/releases/net/neoforged/neoforge/maven-metadata.xml >nul 2>&1
    IF NOT EXIST "%HERE%\univ-utils\maven-neoforge-metadata.xml"  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.neoforged.net/releases/net/neoforged/neoforge/maven-metadata.xml', 'univ-utils\maven-neoforge-metadata.xml')" >nul
)
:: Skips over the oops message if a maven metadata file was found
IF EXIST "%HERE%\univ-utils\maven-forge-metadata.xml" IF /I !MODLOADER!==FORGE GOTO :skipmavenoopsforge
IF EXIST "%HERE%\univ-utils\maven-neoforge-1.20.1-metadata.xml" IF /I !MODLOADER!==NEOFORGE IF !MINECRAFT!==1.20.1 GOTO :skipmavenoopsforge
IF EXIST "%HERE%\univ-utils\maven-neoforge-metadata.xml" IF /I !MODLOADER!==NEOFORGE IF !MINECRAFT! NEQ 1.20.1 GOTO :skipmavenoopsforge

:: If script gets here then either no maven metadata file ever existed, or an old file was deleted, and none was obtained from the maven either due to download problems or because the maven is offline.
CLS
ECHO: & ECHO: & ECHO: & ECHO   %red% OOPS %blue% - %yellow% A DOWNLOAD OF THE MAVEN METADATA FILE WAS ATTEMPTED FOR THE %green% !MODLOADER! %yellow% FILE SERVER %blue% & ECHO:
ECHO   %yellow% BUT THE FILE WAS NOT FOUND AFTER THE DOWNLOAD ATTEMPT. %blue%
ECHO   %yellow% MAYBE YOUR WINDOWS USER DOES NOT HAVE SUFFIENT PERMISSIONS?  OR YOU MAY HAVE AN OVERLY AGGRESSIVE ANTIVIRUS PROGRAM. %blue% & ECHO: & ECHO   %yellow% PRESS ANY KEY TO START OVER. %blue% & ECHO: & ECHO: & ECHO:
PAUSE
GOTO :startover

:skipmavenoopsforge
:: If Forge get newest version available of the selected minecraft version.
IF /I !MODLOADER!==FORGE (
  SET /a idx=0
  SET "ARRAY[!idx!]="
  FOR /F "tokens=1,2 delims=-" %%A IN ('powershell -Command "$data = [xml](Get-Content -Path univ-utils\maven-forge-metadata.xml); $data.metadata.versioning.versions.version"') DO (
    IF %%A==%MINECRAFT% (
        SET ARRAY[!idx!]=%%B
        SET /a idx+=1
    )
  )
  SET NEWESTFORGE=!ARRAY[0]!
  IF [!ARRAY[0]!] EQU [] (
    CLS
    ECHO: & ECHO: & ECHO: & ECHO   %red% OOPS %blue% - %yellow% NO FORGE VERSIONS EXIST FOR THIS MINECRAFT VERSION %blue% - !MINECRAFT! & ECHO:
    ECHO   %yellow% PRESS ANY KEY TO TRY A DIFFERENT COMBINATION OF MINECRAFT VERSION AND MODLOADER TYPE %blue% & ECHO: & ECHO: & ECHO:
    PAUSE
    GOTO :startover
  )
)

REM If Neoforge get newest version available of the selected minecraft version.
IF /I !MODLOADER!==NEOFORGE (
  SET "NEWESTNEOFORGE="
  REM This is the initial versions maven that Neoforge used - only for MC 1.20.1
  IF !MINECRAFT!==1.20.1 FOR /F "tokens=1,2 delims=-" %%A IN ('powershell -Command "$data = [xml](Get-Content -Path univ-utils\maven-neoforge-1.20.1-metadata.xml); $data.metadata.versioning.versions.version"') DO (
    IF %%A==%MINECRAFT% (
        SET NEWESTNEOFORGE=%%B
    )
  )
  REM Neoforge changed how they version number their installer files starting with MC 1.20.2 - this is the new system.
  IF !MINECRAFT! NEQ 1.20.1 FOR /F "tokens=1-4 delims=.-" %%A IN ('powershell -Command "$data = [xml](Get-Content -Path univ-utils\maven-neoforge-metadata.xml); $data.metadata.versioning.versions.version"') DO (
    REM If the current Minecraft version contains a minor version
    IF %%A==!MCMAJOR! IF %%B==!MCMINOR! (
        SET NEWESTNEOFORGE=%%A.%%B.%%C
        IF [%%D] NEQ [] SET NEWESTNEOFORGE=!NEWESTNEOFORGE!-%%D
    )
  )
  REM If looking through the maven xml file results in NEWESTNEOFORGE being blank then it found no matches with the current minecraft version.
  IF [!NEWESTNEOFORGE!] EQU [] (
    CLS
    ECHO: & ECHO: & ECHO: & ECHO   %red% OOPS %blue% - %yellow% NO NEOFORGE VERSIONS EXIST FOR THIS MINECRAFT VERSION %blue% - !MINECRAFT! & ECHO:
    ECHO   %yellow% PRESS ANY KEY TO TRY A DIFFERENT COMBINATION OF MINECRAFT VERSION AND MODLOADER TYPE %blue% & ECHO: & ECHO: & ECHO:
    PAUSE
    GOTO :startover
  )
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
IF /I "!FROGEENTRY!"=="Y" (
  IF !MODLOADER!==FORGE SET FORGE=!NEWESTFORGE!
  IF !MODLOADER!==NEOFORGE SET NEOFORGE=!NEWESTNEOFORGE!
  GOTO :setjava
)
:: Checks if any blank spaces were in the entry.
IF "!FROGEENTRY!" NEQ "!FROGEENTRY: =!" GOTO :redoenterforge

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
  FOR /F "tokens=1,2 delims=-" %%A IN ('powershell -Command "$data = [xml](Get-Content -Path univ-utils\maven-forge-metadata.xml); $data.metadata.versioning.versions.version"') DO (
    IF %%A==!MINECRAFT! IF %%B==!FROGEENTRY! GOTO :foundvalidforgeversion
    )
)
IF /I !MODLOADER!==NEOFORGE IF !MINECRAFT!==1.20.1 (
  FOR /F "tokens=1,2 delims=-" %%A IN ('powershell -Command "$data = [xml](Get-Content -Path univ-utils\maven-neoforge-1.20.1-metadata.xml); $data.metadata.versioning.versions.version"') DO (
    IF %%A==!MINECRAFT! IF %%B==!FROGEENTRY! GOTO :foundvalidforgeversion
  )
)
IF /I !MODLOADER!==NEOFORGE IF !MINECRAFT! NEQ 1.20.1 (
  FOR /F "tokens=1-4 delims=.-" %%A IN ('powershell -Command "$data = [xml](Get-Content -Path univ-utils\maven-neoforge-metadata.xml); $data.metadata.versioning.versions.version"') DO (
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

IF !MCMAJOR! LEQ 16 SET JAVAVERSION=8
IF !MCMAJOR!==17 SET JAVAVERSION=16
IF !MCMAJOR! GEQ 18 SET JAVAVERSION=17

:: Minecraft Forge 1.16.5 is a special version that a few different Javas can work with
IF !MCMAJOR!==16 IF !MCMINOR!==5 IF /I !MODLOADER!==FORGE (
  CLS
  ECHO: & ECHO: & ECHO: & ECHO:
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO:
  ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
  ECHO:
  ECHO   THE ONLY VERSIONS AVAILABLE THAT WORK WITH MINECRAFT / FORGE 1.16.5 ARE %green% 8 %blue% AND %green% 11 %blue%
  ECHO:
  ECHO   USING JAVA 11 %green% MAY %blue% OR %red% MAY NOT %blue% WORK DEPENDING ON MODS BEING LOADED
  ECHO   %green% BUT IT PROBABLY WILL %blue%
  ECHO:
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P JAVAVERSION=
  IF !JAVAVERSION! NEQ 8 IF !JAVAVERSION! NEQ 11 GOTO :setjava
)

:javaselect
IF DEFINED MAINMENU IF /I !MAINMENU!==J (

  SET INITIALJAVA=!JAVAVERSION!
  IF NOT DEFINED MCMAJOR (
    SET "MCMINOR="
    FOR /F "tokens=2,3 delims=." %%E IN ("!MINECRAFT!") DO SET /a MCMAJOR=%%E & SET /a MCMINOR=%%F
    IF NOT DEFINED MCMINOR SET /a MCMINOR=0
  )
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
  IF !MCMAJOR! GEQ 18 ECHO   THE OPTIONS FOR MINECRAFT !MINECRAFT! BASED LAUNCHING ARE %green% 17 %blue% AND %green% 21 %blue%
  ECHO:
  ECHO   * USING THE NEWER VERSION OPTION IF GIVEN A CHOICE %green% MAY %blue% OR %red% MAY NOT %blue% WORK DEPENDING ON MODS BEING LOADED
  ECHO   * IF A SERVER FAILS TO LAUNCH, YOU SHOULD CHANGE BACK TO THE LOWER DEFAULT VERSION^^! & ECHO: & ECHO:
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P JAVAVERSION=
IF !MCMAJOR! LSS 16 IF !JAVAVERSION! NEQ 8 GOTO :javaselect
IF !MCMAJOR! EQU 16 IF !MCMINOR! LEQ 4 IF !JAVAVERSION! NEQ 8 GOTO :javaselect
IF !MCMAJOR! EQU 16 IF !MCMINOR! EQU 5 IF !JAVAVERSION! NEQ 8 IF !JAVAVERSION! NEQ 11 GOTO :javaselect
IF !MCMAJOR! EQU 17 IF !JAVAVERSION! NEQ 16 GOTO :javaselect
IF !MCMAJOR! GEQ 18 IF !JAVAVERSION! NEQ 17 IF !JAVAVERSION! NEQ 21 GOTO :javaselect
:: If the java version was changed, then bypass the eventual firewall rule check for the rest of this window session
IF !INITIALJAVA! NEQ !JAVAVERSION! SET BYPASSFIREWALLRULECHECK=Y
GOTO :setconfig
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

:: Checks if there are any spaces or decimal points in the entry
IF "!MAXRAMGIGS!" NEQ "!MAXRAMGIGS: =!" GOTO :badramentry
IF "!MAXRAMGIGS!" NEQ "!MAXRAMGIGS:.=!" GOTO :badramentry

:: Tests to see if the entered value is an integer or not.  If it is a string and not an integer (letters etc) - trying to set TEST1 as an integer with SET /a will fail.
SET TEST1=w
SET /a TEST1=!MAXRAMGIGS!
IF !MAXRAMGIGS! NEQ !TEST1! GOTO :badramentry

:: Sets the actual MAXRAM variable to launch the server with now that tests have passed.
 SET MAXRAM=-Xmx!MAXRAMGIGS!G

  :: END RAM / MEMORY SETTING

:actuallylaunch

IF /I !MAINMENU!==L SET ASKMODSCHECK=N
IF NOT EXIST settings-universalator.txt (
  SET MAINMENU=S
  SET ASKMODSCHECK=Y
)
:setconfig
:: Generates settings-universalator.txt file if settings-universalator.txt does not exist
IF EXIST settings-universalator.txt DEL settings-universalator.txt

    ECHO :: To reset this file - delete and run launcher again.>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Minecraft version below - example: MINECRAFT=1.18.2 >>settings-universalator.txt
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

:: Returns to main menu if menu option was only to enter java or ram values
IF /I !MAINMENU!==R GOTO :mainmenu
IF /I !MAINMENU!==J GOTO :mainmenu

SET MAXRAM=-Xmx!MAXRAMGIGS!G

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
:: BEGIN JAVA SETUP SECTION
:: Presets a variable to use as a search string versus java folder names.
IF !JAVAVERSION!==8 SET FINDFOLDER=jdk8u
IF !JAVAVERSION!==11 SET FINDFOLDER=jdk-11
IF !JAVAVERSION!==16 SET FINDFOLDER=jdk-16
IF !JAVAVERSION!==17 SET FINDFOLDER=jdk-17
IF !JAVAVERSION!==21 SET FINDFOLDER=jdk-21

:checkforjava
IF NOT EXIST "%HERE%\univ-utils\java" MD "%HERE%\univ-utils\java"
ver >nul

FOR /F "delims=" %%A IN ('DIR /B univ-utils\java') DO (
  ECHO %%A | FINDSTR "!FINDFOLDER!" >nul
  IF !ERRORLEVEL!==0 (
    SET JAVAFOLDER=%%A
    ECHO   Found existing Java !JAVAVERSION! folder - %%A & ECHO:
    ping -n 1 127.0.0.1 >nul
    :: Runs a FOR loop with a powershell command to check the age of the found java folder.  If it's older than 3 months result is 'True'.  If it's newer than 3 months result is 'False'.
    FOR /F %%G IN ('powershell -Command "Test-Path '%HERE%\univ-utils\java\%%A' -OlderThan (Get-Date).AddMonths(-2.5)"') DO (
      :: If False then that means the folder is newer than 3 months - go ahead and use that folder for java, then move on!
      IF %%G==False (
        SET JAVAFILE="univ-utils\java\%%A\bin\java.exe"
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
    SET JAVAFILE="univ-utils\java\!JAVAFOLDER!\bin\java.exe"
    GOTO :javafileisset
  ) ELSE (
    :: Removes the old java folder if the test failed and the newest release was not found in the folder name.
    ECHO   Java folder !JAVAFOLDER! is not the newest version available.  & ECHO   Replacing with the newest Java !JAVAVERSION! version from Adoptium^^! & ECHO:
    RD /s /q "%HERE%\univ-utils\java\!JAVAFOLDER!" >nul
  ) 
)

:: At this point Java was either not found or was old with a newer version available as release from Adoptium.
PUSHD "%HERE%\univ-utils\java"

ECHO   Downloading Java !JAVAVERSION! newest version from Adoptium & ECHO:

:: Sets a variable for the URL string to use to use the Adoptium URL Api - it just makes the actual command later easier deal with.
SET "ADOPTIUMDL=https://api.adoptium.net/v3/assets/feature_releases/!JAVAVERSION!/ga?architecture=x64&heap_size=normal&image_type=!IMAGETYPE!&jvm_impl=hotspot&os=windows&page_size=1&project=jdk&sort_method=DEFAULT&sort_order=DESC&vendor=eclipse"
ver >nul
:: Gets the download URL for the newest release binaries ZIP using the URL Api and then in the same powershell command downloads it.  This avoids having to manipulate URL links with % signs in them in the CMD environment which is tricky.
powershell -Command "$data=(((New-Object System.Net.WebClient).DownloadString('!ADOPTIUMDL!') | Out-String | ConvertFrom-Json)); (New-Object Net.WebClient).DownloadFile($data.binaries.package.link, '%HERE%\univ-utils\java\javabinaries.zip')"

IF NOT EXIST javabinaries.zip (
  ECHO: & ECHO: & ECHO   JAVA BINARIES ZIP FILE FAILED TO DOWNLOAD - PRESS ANY KEY TO TRY AGAIN! & ECHO: & ECHO:
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
  REM Sets a variable to skip checking for firewall rules on a just installed version / folder.
  SET BYPASSFIREWALLRULECHECK=Y
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

SET "JAVANUM=!JAVAFOLDER:-jdk=!"
SET "JAVANUM=!JAVAFOLDER:jdk-=!"
SET "JAVANUM=!JAVANUM:jdk=!"
SET "JAVANUM=!JAVANUM:-jre=!"

REM BEGIN FIREWALL RULE CHECKING
REM Skips past the firewall check - when user launches from launch screen the script comes back here to check.
GOTO :passthroughcheck

:firewallcheck

REM Uses the determined java file/folder location to look for a firewall rule set to use the java.exe
REM This is done by looking at the latest.log file for a successful world spawn gen, which usually means that the server fully loaded at least once, giving the user time to accept the firewall 'allow'.
REM If the java version / folder was just installed in this window session, skip this check entirely.  The variable could be un-set but it's easier to avoid shennanigans if it's just disabled for the rest of the session.
REM If the Private firewall is turned off, skip this check entirely
FOR /F "delims=" %%A IN ('powershell -Command "$data = Get-NetFirewallProfile -Name Private; $data.Enabled"') DO IF "%%A" NEQ "True" SET FOUNDGOODFIREWALLRULE=Y & GOTO :skipfirewallcheck
REM Checks for firewall rulees set for {inbound / true / allow}, with the strings {TCP} and {JAVAFOLDERPATH} in the line.
SET "LONGJAVAFOLDER=%HERE%\univ-utils\java\!JAVAFOLDER!\bin\java.exe"
:: Set a high bar for checking firewall only when latest.log file present, had a world spawn prepare event, and had the same minecraft version - if either turns out false then skip.
IF EXIST "%HERE%\logs\latest.log" TYPE "logs\latest.log" | FINDSTR /i "Preparing spawn area" >nul 2>&1 && TYPE "logs\latest.log" | FINDSTR /i "!MINECRAFT!" >nul 2>&1 || GOTO :skipfirewallcheck

FOR /F "delims=" %%A IN ('powershell -Command "$data = Get-NetFirewallRule -Direction Inbound -Enabled True -Action Allow; $data.name"') DO (
  REM Uses string replacement to check for TCP in the line, and if found echos the string to a FINDSTR to look for the java folder path.
  SET TEMP=%%A
  IF "!TEMP!" NEQ "!TEMP:TCP=x!" IF "!TEMP!" NEQ "!TEMP:%LONGJAVAFOLDER%=x!" SET FOUNDGOODFIREWALLRULE=Y & GOTO :skipfirewallcheck
)
IF NOT DEFINED FOUNDGOODFIREWALLRULE (
  CLS
  ECHO: & ECHO: & ECHO:
  ECHO   %red% CONCERN - NO WINDOWS FIREWALL PASS RULE FOR THE INSTALLED JAVA DETECTED - CONCERN %blue% & ECHO:
  ECHO   %blue% IT LOOKS LIKE THIS SERVER FOLDER HAS SUCCESSFULLY RUN PREVIOUSLY WITH THE SAME MINECRAFT VERSION, %blue%
  ECHO   %blue% BUT NO WINDOWS FIREWALL RULE WAS FOUND FOR THE java.exe SET TO: %blue%
  ECHO   %blue% 'Direction:Inbound' / 'Action':'Allow' / 'Enabled':'True' %blue% & ECHO:
  ECHO     %LONGJAVAFOLDER% & ECHO:
  ECHO   %blue% YOU SHOULD GO TO WINDOWS FIREWALL SETTINGS AND REMOVE ANY EXISTING FIREWALL RULES COVERING %blue%
  ECHO   %blue% THIS java.exe LOCATION ^(LISTED ABOVE^), AND ANY RULES COVERING THE PORT YOU HAVE SET. %blue%
  ECHO   %blue% THEN LAUNCH THE SERVER AGAIN AND PRESS 'Allow' ON THE WINDOWS POP-UP THAT COMES UP WHILE LAUNCHING. %blue%
  ECHO: & ECHO: & ECHO: & ECHO:
  ECHO   %green% * IF YOU THINK THIS MESSAGE IS INCORRECT YOU CAN STILL PRESS ANY KEY TO CONTINUE %blue% & ECHO: & ECHO:
  PAUSE
)

:skipfirewallcheck
IF /I !MODLOADER!==FORGE GOTO :reallydoforge
IF /I !MODLOADER!==NEOFORGE GOTO :reallydoforge
IF /I !MODLOADER!==FABRIC GOTO :reallydofabric
IF /I !MODLOADER!==QUILT GOTO :reallydofabric
IF /I !MODLOADER!==VANILLA GOTO :reallydofabric

:passthroughcheck
:: END JAVA SETUP SECTION

SET "MCMINOR="
FOR /F "tokens=2,3 delims=." %%E IN ("!MINECRAFT!") DO (
    SET /a MCMAJOR=%%E
    SET /a MCMINOR=%%F
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
  IF EXIST libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/. GOTO :foundforge
  IF EXIST forge-!MINECRAFT!-!FORGE!.jar GOTO :foundforge
  IF EXIST minecraftforge-universal-!MINECRAFT!-!FORGE!.jar GOTO :foundforge
  IF EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar GOTO :foundforge
  IF EXIST forge-!MINECRAFT!-!FORGE!-universal.jar GOTO :foundforge
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

:: Sets variables for different file names that different versions of Forge have.
IF !MINECRAFT!==1.6.4 IF NOT EXIST minecraftforge-universal-1.6.4-!FORGE!.jar SET "FORGEFILENAMEORDER=!MINECRAFT!-!FORGE!"
IF !MCMAJOR! GEQ 7 IF !MCMAJOR! LEQ 9 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar SET "FORGEFILENAMEORDER=!MINECRAFT!-!FORGE!-!MINECRAFT!"
IF !MCMAJOR!==10 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-universal.jar SET "FORGEFILENAMEORDER=!MINECRAFT!-!FORGE!"
IF !MCMAJOR! GEQ 11 IF !MCMAJOR! LEQ 16 IF NOT EXIST forge-!MINECRAFT!-!FORGE!.jar SET "FORGEFILENAMEORDER=!MINECRAFT!-!FORGE!"
IF !MCMAJOR! GEQ 17 IF NOT EXIST libraries\net\minecraftforge\forge\!MINECRAFT!-!FORGE!\. SET "FORGEFILENAMEORDER=!MINECRAFT!-!FORGE!"

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
  !JAVAFILE! -Djava.net.preferIPv4Stack=true -XX:+UseG1GC -jar forge-installer.jar --installServer
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

::If eula.txt doens't exist yet user prompted to agree and sets the file automatically to eula=true.  The only entry that gets the user further is 'agree'.
IF NOT EXIST eula.txt ping -n 4 127.0.0.1 >nul
:eula
IF NOT EXIST eula.txt ( 
  CLS
  ECHO: & ECHO:
  ECHO   Mojang's EULA has not yet been accepted. In order to run a Minecraft server, you must accept Mojang's EULA.
  ECHO   Mojang's EULA is available to read at https://account.mojang.com/documents/minecraft_eula
  ECHO:
  ECHO     %yellow% If you agree to Mojang's EULA then type 'AGREE' %blue% & ECHO:
  ECHO     %yellow% ENTER YOUR RESPONSE %blue% & ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P RESPONSE=

  IF /I !RESPONSE!==AGREE (
    ECHO:
    ECHO   User agreed to Mojang's EULA. & ECHO:
    %DELAY%
    ECHO eula=true> eula.txt
  ) ELSE (
    GOTO :forgeeula
  )
)
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
SET ASKMODSCHECK=N
IF NOT EXIST "%HERE%\mods" GOTO :mainmenu
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

  ECHO Searching for client only mods . . .
IF NOT EXIST univ-utils MD univ-utils
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


  REM Gets the client only list from github file, checks if it's empty or not after download attempt, then sends
  REM to a new file masterclientids.txt with any blank lines removed.
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/nanonestor/utilities/main/clientonlymods.txt', 'univ-utils/clientonlymods.txt')" >nul


  REM Checks if the just downloaded file's first line is empty or not.  Better never save that webfile with the first line empty!
  IF EXIST clientonlymods.txt SET /P EMPTYCHECK=<clientonlymods.txt
  IF NOT EXIST clientonlymods.txt SET EMPTYCHECK=""
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

   REM Sends the mods.toml to standard output using the tar command in order to set the ERRORLEVEL - actual output and error output silenced
   tar -xOf "mods\!SERVERMODS[%%T].file!" *\mods.toml >nul 2>&1

   IF !ERRORLEVEL!==0 FOR /F "delims=" %%X IN ('tar -xOf "mods\!SERVERMODS[%%T].file!" *\mods.toml') DO (
    
      SET "TEMP=%%X"
      IF !FOUNDMODPLACE!==Y IF "!TEMP!" NEQ "!TEMP:modId=x!" (
         SET "TEMP=!TEMP: =!"
         SET "TEMP=!TEMP:#mandatory=!"
         :: CALLs a special function to replace equals with underscore characters for easier detection.
         CALL :l_replace "!TEMP!" "=" "_"
      )
      IF !FOUNDMODPLACE!==Y IF "!TEMP!" NEQ "!TEMP:modId_=x!" (
      :: Uses special carats to allow using double quotes " as delimiters, to find the modID value.
      FOR /F delims^=^"^ tokens^=2 %%Y IN ("!TEMP!") DO SET ID=%%Y
       SET MODID[!MODIDLINE!]=!ID!
       SET /a MODIDLINE+=1
       SET FOUNDMODPLACE=DONE
      )
      :: Detects if the current line has the [mods] string.  If it does then record to a varaible which will trigger checking for the string modId_ to detect the real modId of this mod file.
      IF "!TEMP!" NEQ "!TEMP:[mods]=x!" SET FOUNDMODPLACE=Y
   )
   SET SERVERMODS[%%T].id=!MODID[0]!
)
:: Below skips to finishedscan label skipping the next section which is file scanning for old MC versions (1.12.2 and older).
IF !MCMAJOR! GEQ 13 GOTO :finishedscan

GOTO :skipreplacefunction
:: Function to replace strings within variable strings - hot stuff!
:l_replace
SET "TEMP=x%~1x"
:l_replaceloop
FOR /f "delims=%~2 tokens=1*" %%x IN ("!TEMP!") DO (
IF "%%y"=="" set "TEMP=!TEMP:~1,-1!"&exit/b
set "TEMP=%%x%~3%%y"
)
GOTO :l_replaceloop
:skipreplacefunction

:: END SCANNING NEW STYLE MODS.TOML
:: BEGIN SCANNING OLD STYLE MCMOD.INFO

:scanmcmodinfo
:: For each found jar file - uses tar command to output using STDOUT the contents of the mods.toml.  For each line in the STDOUT output the line is checked.
:: First a trigger is needed to determine if the [mods] section has been detected yet in the JSON.  Once that trigger variable has been set to Y then 
:: the script scans to find the modID line.  A fancy function replaces the = sign with _ for easier string comparison to determine if the modID= line was found.
:: This should ensure that no false positives are recorded.

SET "TABCHAR=	"
FOR /L %%t IN (0,1,!SERVERMODSCOUNT!) DO (
  SET COUNT=%%t
  SET /a COUNT+=1
  ECHO SCANNING !COUNT!/!ACTUALMODSCOUNT! - !SERVERMODS[%%t].file!

  REM Sends the mcmod.info to standard output using the tar command in order to set the ERRORLEVEL - actual output and error output silenced
  tar -xOf "mods\!SERVERMODS[%%t].file!" mcmod.info >nul 2>&1

  IF !ERRORLEVEL!==0 FOR /F "delims=" %%X IN ('tar -xOf "mods\!SERVERMODS[%%t].file!" mcmod.info') DO (
    :: Sets ID to undefined if it was previously defined
    SET "ID="
    :: Sets a temp variable equal to the current line for processing, and replaces " with ; for easier loop delimiting later.
    SET "TEMP=%%X"
    SET "TEMP=!TEMP:"=;!"
    :: If the line contains the modid then further process line and then set ID equal to the actual modid entry.
    IF "!TEMP!" NEQ "!TEMP:;modid;=x!" (
      SET "TEMP=!TEMP:%TABCHAR%=!"
      SET "TEMP=!TEMP: =!"
      SET "TEMP=!TEMP:;=!"
      SET "TEMP=!TEMP:,=!"
      FOR /F "tokens=2 delims=:" %%Y IN ("!TEMP!") DO (
        SET SERVERMODS[%%t].id=%%Y
      )
    )
  )
  :: If ID was found record it to the array entry of the current mod number, otherwise set the ID of that mod equal to a dummy string x.
  IF NOT DEFINED SERVERMODS[%%t].id SET SERVERMODS[%%t].id=x
)
:: END SCANNING OLD STYLE MCMOD.INFO
:finishedscan


:: This is it! Checking each server modid versus the client only mods list text file.  Starts with a loop through each server modID found.
SET /a NUMCLIENTS=0
FOR /L %%b IN (0,1,!SERVERMODSCOUNT!) DO (

  :: Runs a FINDSTR to see if the string of the modID is found on a line.  This needs further checks to guarantee the modID is the entire line and not just part of it.
  FINDSTR /I /R /C:"!SERVERMODS[%%b].id!" univ-utils\clientonlymods.txt >nul
  
  REM If errorlevel is 0 then the FINDSTR above found the modID.  The line returned by the FINDSTR can be captured into a variable by using a FOR loop.
  REM That variable is compared to the server modID in question.  If they are equal then it is a definite match and the modID and filename are recorded to a list of client only mods found.
  IF !ERRORLEVEL!==0 (
    FOR /F "delims=" %%A IN ('FINDSTR /I /R /C:"!SERVERMODS[%%b].id!" univ-utils\clientonlymods.txt') DO (

      IF /I !SERVERMODS[%%b].id!==%%A (
        SET /a NUMCLIENTS+=1
        SET FOUNDCLIENTS[!NUMCLIENTS!].id=!SERVERMODS[%%b].id!
        SET FOUNDCLIENTS[!NUMCLIENTS!].file=!SERVERMODS[%%b].file!
      )
    )
  )
)

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

GOTO :continue2
:: Function used above for determining max character length of any of the modIDs.
:GetMaxStringLength

:: Usage : GetMaxStringLength OutVariableName StringToBeMeasured
:: Note  : OutVariable may already have an initial value
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
:continue2

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

:: FINALLY LAUNCH FORGE SERVER!
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

REM Goes to firewall rule checking if nothing bypasses going there
IF NOT DEFINED FOUNDGOODFIREWALLRULE IF NOT DEFINED BYPASSFIREWALLRULECHECK GOTO :firewallcheck
REM Script comes back after firewall rule checking
:reallydoforge

ECHO: & ECHO   Launching... & ping -n 2 127.0.0.1 > nul & ECHO   Launching.. & ping -n 2 127.0.0.1 > nul & ECHO   Launching. & ECHO:
:: Starts forge depending on what java version is set.  Only correct combinations will launch - others will crash.

IF !OVERRIDE!==Y SET "JAVAFILE=java"
TITLE Universalator - !MINECRAFT! !MODLOADER!
ver >nul
IF /I !MODLOADER!==NEOFORGE GOTO :actuallylaunchneoforge
:: Special case forge.jar filenames for older OLD versions
IF !MINECRAFT!==1.6.4 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar minecraftforge-universal-1.6.4-!FORGE!.jar nogui
) 
IF !MINECRAFT!==1.7.10 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-1.7.10-!FORGE!-1.7.10-universal.jar nogui
) 
IF !MINECRAFT!==1.8.9 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-1.8.9-!FORGE!-1.8.9-universal.jar nogui
) 
IF !MINECRAFT!==1.9.4 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-1.9.4-!FORGE!-1.9.4-universal.jar nogui
) 
IF !MINECRAFT!==1.10.2 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-1.10.2-!FORGE!-universal.jar nogui
) 

:: General case forge.jar filenames for regular OLD Minecraft Forge newer (higher numbered) than 1.10.2 but older than 1.17
IF !MCMAJOR! LEQ 16 IF !MINECRAFT! NEQ 1.6.4 IF !MINECRAFT! NEQ 1.7.10 IF !MINECRAFT! NEQ 1.8.9 IF !MINECRAFT! NEQ 1.9.4 IF !MINECRAFT! NEQ 1.10.2 (
%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% -jar forge-!MINECRAFT!-!FORGE!.jar nogui
) 
:: Launching Minecraft versions 1.17 and newer.  As of 1.20.4 Forge went back to an executable JAR file that gets put in the main directory.
IF !MCMAJOR! GEQ 17 SET LAUNCHFORGE=NEWOLD
IF !MCMAJOR! EQU 20 IF !MCMINOR! GEQ 4 SET LAUNCHFORGE=NEWNEW
IF !MCMAJOR! GEQ 21 SET LAUNCHFORGE=NEWNEW

IF !LAUNCHFORGE!==NEWOLD (
  %JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% @libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/win_args.txt nogui %*
)
IF !LAUNCHFORGE!==NEWNEW (
  %JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-!MINECRAFT!-!FORGE!-shim.jar nogui
)

:actuallylaunchneoforge
IF /I !MODLOADER!==NEOFORGE (
  IF !MINECRAFT!==1.20.1 %JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% @libraries/net/neoforged/forge/!MINECRAFT!-!NEOFORGE!/win_args.txt nogui %*
  IF !MINECRAFT! NEQ 1.20.1 %JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% @libraries/net/neoforged/neoforge/!NEOFORGE!/win_args.txt nogui %*
)

:: Complaints to report in console output if launch attempt crashes
IF NOT EXIST "%HERE%\logs\latest.log" GOTO :skipforgelogs
:: Looks for the stopping the server text to decide if the server was shut down on purpose.  If so goes to main menu.
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"Stopping the server" >nul && (
  PAUSE
  GOTO :mainmenu
)

TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"Unsupported class file major version" >nul && (
  ECHO: & ECHO        %red% --SPECIAL NOTE-- %blue%
  ECHO    %yellow% FROM SCANNING THE LOGS IT LOOKS LIKE YOUR SERVER MAY HAVE CRASHED FOR ONE OF TWO REASONS:  %blue%
  ECHO    %yellow% --YOUR SELECTED JAVA VERSION IS CRASHING WITH THE CURRENT FORGE AND MODS VERSIONS %blue%
  ECHO    %yellow% --AT LEAST ONE MOD FILE IN THE MODS FOLDER IS FOR A DIFFERENT VERSION OF FORGE / MINECRAFT %blue% & ECHO:
  ECHO        %red% --SPECIAL NOTE-- %blue% & ECHO:
)

  :: Search if the standard client side mod message was found.  Ignore if certain mod file names of server-needed mods are found that are known to have unsilenced messages regarding.
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"invalid dist DEDICATED_SERVER" >nul && DIR /B | FINDSTR /i "auxiliaryblocks farmersdelight ispawner findme modernfix obscuria's strawgolem the_vault wildbackport" >nul && (
  ECHO: & ECHO        %red% --- SPECIAL MESSAGE --- %blue%
  ECHO    THE TEXT 'invalid dist DEDICATED_SERVER' WAS FOUND IN THE LOG FILE
  ECHO    THIS COULD MEAN YOU HAVE CLIENT MODS CRASHING THE SERVER - OTHERWISE SOME MOD AUTHORS DID NOT SILENCE THAT MESSAGE.
  ECHO:
  ECHO    TRY USING THE UNIVERSALATOR %green% 'SCAN' %blue% OPTION TO FIND CLIENT MODS.
  ECHO        %red% --- SPECIAL MESSAGE --- %blue% & ECHO:
)
ECHO: & ECHO   IF THIS MESSAGE IS VISIBLE SERVER MAY HAVE CRASHED / STOPPED & ECHO: & ECHO   CHECK LOG FILES - PRESS ANY KEY TO GO BACK TO MAIN MENU & ECHO: & ECHO:
PAUSE
:skipforgelogs
GOTO :mainmenu
:: END FORGE LAUNCH SECTION


:: BEGIN FABRIC INSTALLATION SECTION
:preparefabric
:: Skips installation if already present, if either file is not present then assume a reinstallation is needed.
IF EXIST fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar IF EXIST "libraries\net\fabricmc\fabric-loader\!FABRICLOADER!\fabric-loader-!FABRICLOADER!.jar" GOTO :launchfabric

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
      %JAVAFILE% -XX:+UseG1GC -jar fabric-installer.jar server -loader !FABRICLOADER! -mcversion !MINECRAFT! -downloadMinecraft
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
  RENAME fabric-server-launch.jar fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar
)

::If eula.txt doens't exist yet 
IF NOT EXIST eula.txt (
  %DELAY%
  GOTO :eula
)
:eulafabricreturn

IF EXIST fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar (
  GOTO :launchfabric 
) ELSE (
  GOTO :preparefabric
)
:: END FABRIC INSTALLATION SECTION

:: BEGIN QUILT INSTALLATION SECTION
:preparequilt
:: Skips installation if already present
IF EXIST quilt-server-launch-!MINECRAFT!-!QUILTLOADER!.jar IF EXIST "libraries\org\quiltmc\quilt-loader\!QUILTLOADER!\quilt-loader-!QUILTLOADER!.jar" GOTO :launchquilt

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
      %JAVAFILE% -XX:+UseG1GC -jar quilt-installer.jar install server !MINECRAFT! !QUILTLOADER! --download-server --install-dir=%cd%
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
  RENAME quilt-server-launch.jar quilt-server-launch-!MINECRAFT!-!QUILTLOADER!.jar
)

::If eula.txt doens't exist yet 
IF NOT EXIST eula.txt (
  %DELAY%
  GOTO :eula
)
:eulaquiltreturn

IF EXIST quilt-server-launch-!MINECRAFT!-!QUILTLOADER!.jar GOTO :launchquilt
GOTO :preparequilt

:: END QUILT INSTALLATION SECTION

:: BEGIN FABRIC client only mods scanning section
:scanfabric

ECHO:
ECHO Searching for client mods . . .

IF EXIST univ-utils\allfabricdeps.txt DEL univ-utils\allfabricdeps.txt >nul
:: Some mod authors enter tab characters instead of spaces in their JSON/TOML files which messes up the delimiting.  A tab character is recorded in this variable to later void the tab char by replacement in strings of interest.
SET "TABCHAR=	"
:: This variable is for a trigger to determine at the end if any client mods at all were found.
SET FOUNDFABRICCLIENTS=N

:: Loops through each number up to the total mods count to enter that filename into the next loop.
FOR /L %%f IN (0,1,!SERVERMODSCOUNT!) DO (
  SET /a JSONLINE=0
  SET FOUNDDEPENDS=N
  SET SERVERMODS[%%f].environ=N
  SET /a COUNT=%%f
  SET /a COUNT+=1
  ECHO SCANNING !COUNT!/%ACTUALMODSCOUNT% - !SERVERMODS[%%f].file!

  tar -xOf "mods\!SERVERMODS[%%f].file!" quilt.mod.json >nul 2>&1
  IF !ERRORLEVEL!==0 (
    FOR /F %%A IN ('powershell -Command "$json=(tar xOf "mods\!SERVERMODS[%%f].file!" quilt.mod.json) | Out-String | ConvertFrom-Json; $json.quilt_loader.id"') DO SET SERVERMODS[%%f].id=%%A
    FOR /F %%A IN ('powershell -Command "$json=(tar xOf "mods\!SERVERMODS[%%f].file!" quilt.mod.json) | Out-String | ConvertFrom-Json; $json.minecraft.environment"') DO (
      IF %%A==client SET SERVERMODS[%%f].environ=C
    )
    FOR /F %%B IN ('powershell -Command "$json=(tar xOf "mods\!SERVERMODS[%%f].file!" quilt.mod.json) | Out-String | ConvertFrom-Json; $json.quilt_loader.depends.id"') DO (
                IF %%B NEQ quilt_loader IF %%B NEQ minecraft IF %%B NEQ quilt_base IF %%B NEQ java IF %%B NEQ cloth-config IF %%B NEQ cloth-config2 IF %%B NEQ fabric-language-kotlin IF %%B NEQ iceberg IF %%B NEQ quilted_fabric_api IF %%B NEQ creativecore IF %%B NEQ architectury ECHO %%B>>univ-utils\allfabricdeps.txt
    )
  ) ELSE (
  tar -xOf "mods\!SERVERMODS[%%f].file!" fabric.mod.json >nul 2>&1

  REM Uses STDOUT from tar command to loop through each line in the fabric.mod.json file of each mod file.
  IF !ERRORLEVEL!==0 FOR /F "delims=" %%I IN ('tar -xOf "mods\!SERVERMODS[%%f].file!" fabric.mod.json') DO (
    
    REM Sets a temp variable equal to the current line for processing, and replaces " with ; for easier loop delimiting later.
    SET "TEMP=%%I"
    SET "TEMP=!TEMP:"=;!"
    REM If the line contains the modid then further process line and then set ID equal to the actual modid entry.
    IF "!TEMP!" NEQ "!TEMP:;id;=x!" (
      SET "TEMP=!TEMP:%TABCHAR%=!"
      SET "TEMP=!TEMP: =!"
      SET "TEMP=!TEMP::=!"
      REM Normal id delims detection
      FOR /F "tokens=2 delims=;" %%Q IN ("!TEMP!") DO (
        SET SERVERMODS[%%f].id=%%Q
      )

      REM Delims detection for cases when JSON files are formatted to all be on one line instead of multiple lines.  hopefully the rest of the format is regular - otherwise incorrect entry will be recorded for the id.
      REM This could be made fancier by adding more tokens and comparing them to see which one equals id and then recording the next token as the id entry.
      IF !JSONLINE!==0 FOR /F "tokens=5 delims=;" %%Q IN ("!TEMP!") DO (
        REM Assumes that JSON is formatted normally so that the 5th token is the mod ID and records it.
        SET SERVERMODS[%%f].id=%%Q
        REM Outputs the fabric.mod.json file to an actual unzipped file so that powershell can read it.
        PUSHD univ-utils

        tar -xf "%HERE%\mods\!SERVERMODS[%%f].file!" fabric.mod.json >nul 2>&1

        POPD
        REM Uses powershell to output the dependency values in fabric.mod.json
        powershell -Command "$json=Get-Content -Raw -Path 'univ-utils\fabric.mod.json' | Out-String | ConvertFrom-Json; $json.depends.psobject.properties.name | Out-File -FilePath univ-utils\single-line-mod-deps.txt"
        REM Scans the dependency values just dumped and prints them to the master file to compile them - filters out commonly added values to ignore.
        FOR /F "delims=" %%D IN (univ-utils\single-line-mod-deps.txt) DO (
          IF %%D NEQ fabricloader IF %%D NEQ minecraft IF %%D NEQ fabric IF %%D NEQ java IF %%D NEQ cloth-config IF %%D NEQ cloth-config2 IF %%D NEQ fabric-language-kotlin IF %%D NEQ iceberg IF %%D NEQ fabric-resource-loader-v0 IF %%D NEQ creativecore IF %%D NEQ architectury ECHO %%D>>univ-utils\allfabricdeps.txt
        )
      )

      
    )
    REM Detects with the string replacement method if the enviroment value is present, and then if found whether the client entry is present.  Otherwise if environment is found but client not - mark mod as not client.
    IF "!TEMP!" NEQ "!TEMP:;environment;=x!" (
      SET "TEMP=!TEMP: =!"
      SET "TEMP=!TEMP::=!"
      IF "!TEMP!" NEQ "!TEMP:;environment;;client;,=x!" (
        SET SERVERMODS[%%f].environ=C
        SET FOUNDFABRICCLIENTS=Y
      ) ELSE ( 
        IF NOT DEFINED SERVERMODS[%%f].environ SET SERVERMODS[%%f].environ=N
      )
    )
    REM If the depends value was found in a previous loop but the }, string is found - set the FOUDNDEPENDS variable back equal to N to stop recording entries.
    IF !FOUNDDEPENDS!==Y IF "!TEMP!" NEQ "!TEMP:},=x!" SET FOUNDDEPENDS=N
    REM If the depends value was found in a previous loop and no JSON value ending strings are found - record the dependency entry (ignores common entries that aren't relevant)
    IF !FOUNDDEPENDS!==Y IF "!TEMP!"=="!TEMP:}=x!" IF "!TEMP!"=="!TEMP:]=x!" (
      SET "TEMP=!TEMP:%TABCHAR%=!"
      SET "TEMP=!TEMP: =!"
      SET "TEMP=!TEMP::=!"
      IF !FOUNDDEPENDS!==Y FOR /F "delims=;" %%g IN ("!TEMP!") DO (
        IF %%g NEQ fabricloader IF %%g NEQ minecraft IF %%g NEQ fabric IF %%g NEQ java IF %%g NEQ cloth-config IF %%g NEQ cloth-config2 IF %%g NEQ fabric-language-kotlin IF %%g NEQ iceberg IF %%g NEQ fabric-resource-loader-v0 IF %%g NEQ creativecore IF %%g NEQ architectury ECHO %%g>>univ-utils\allfabricdeps.txt
        REM Below is a different way to do the above line - however it's slower.  If FINDSTR does not find one of the string values then it echos the entry to the txt file.
        REM ECHO %%g | FINDSTR "fabricloader minecraft fabric java cloth-config cloth-config2 fabric-language-kotlin iceberg fabric-resource-loader-v0 creativecore architectury" >nul 2>&1 || ECHO %%g>>univ-utils\allfabricdeps.txt
      )
    )
    REM If the depends string is found set FOUNDDEPENDS Y for discovery in the next loop iteration.
    IF !FOUNDDEPENDS!==N IF "!TEMP!" NEQ "!TEMP:;depends;=x!" SET FOUNDDEPENDS=Y
    REM Increases the integer value of JSONLINE - this variable is only used to determine if the JSON is the compact 1 line version or has multiple lines.
    SET /a JSONLINE+=1
  )) 
)
REM Goes to the no clients found message.  If any environment client mods were found this trigger variable will be Y instead.
IF !FOUNDFABRICCLIENTS!==N GOTO :noclientsfabric

:: Loops through each mod file/id array value to make a final array for mods with the clients environment which also don't have any matches for their mod id in the dependencies.
SET /a CLIENTSCOUNT=0
FOR /L %%r IN (0,1,!SERVERMODSCOUNT!) DO (
  IF !SERVERMODS[%%r].environ!==C (
    FINDSTR "!SERVERMODS[%%r].id!" univ-utils\allfabricdeps.txt >nul
    IF !ERRORLEVEL! NEQ 0 (
      SET "FABRICCLIENTS[!CLIENTSCOUNT!].file=!SERVERMODS[%%r].file!"
      SET "FABRICCLIENTS[!CLIENTSCOUNT!].id=!SERVERMODS[%%r].id!"
      SET /a CLIENTSCOUNT+=1
    )
  )
)

IF EXIST univ-utils\fabric.mod.json DEL univ-utils\fabric.mod.json >nul
IF EXIST univ-utils\single-line-mod-deps.txt DEL univ-utils\single-line-mod-deps.txt >nul
IF EXIST univ-utils\allfabricdeps.txt DEL univ-utils\allfabricdeps.txt >nul

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

GOTO :continue1
:: Function used above for determining max character length of any of the modIDs.
:GetMaxStringLength

:: Usage : GetMaxStringLength OutVariableName StringToBeMeasured
:: Note  : OutVariable may already have an initial value
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
:continue1

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
  ECHO      %yellow%   "%HERE%\CLIENTMODS" 
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
:: Tries to ping the Mojang file server to check that it is online and responding
SET /a pingmojang=1
:pingmojangagain

ECHO   Pinging Mojang file server - Attempt # !pingmojang! ... & ECHO:
SET PINGMOJANG=IDK
ping -n 2 launchermeta.mojang.com >nul || ping -n 6 launchermeta.mojang.com >nul || SET PINGMOJANG=F
ping -n 2 piston-meta.mojang.com >nul || ping -n 6 piston-meta.mojang.com >nul || SET PINGMOJANG=F
IF !PINGMOJANG!==F (
  SET pingmojang+=1
  CLS
  ECHO:
  ECHO A PING TO THE MOJANG FILE SERVER HAS FAILED
  ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
  ECHO PRESS ANY KEY TO TRY TO PING FILESERVER AGAIN
  PAUSE
  GOTO :pingmojangagain
)

ECHO   Downloading Minecraft server JAR file... .. . & ECHO:

:: Downloads the vanilla Minecraft server JAR from the Mojang file server
powershell -Command "(New-Object Net.WebClient).DownloadFile(((Invoke-RestMethod -Method Get -Uri ((Invoke-RestMethod -Method Get -Uri "https://launchermeta.mojang.com/mc/game/version_manifest_v2.json").versions | Where-Object -Property id -Value !MINECRAFT! -EQ).url).downloads.server.url), 'minecraft_server.!MINECRAFT!.jar')"
:: If the download failed to get a file then try again
IF NOT EXIST minecraft_server.!MINECRAFT!.jar (
  ECHO: & ECHO   OOPS - THE MINECRAFT SERVER JAR FAILED TO DOWNLOAD & ECHO: & ECHO   PRESS ANY KEY TO TRY DOWNLOADING AGAIN & ECHO: & ECHO:
  PAUSE
  GOTO :preparevanilla
)

:: Gets a URL for the version JSON from the Mojang file server
FOR /F %%A IN ('powershell -Command "$data=(((New-Object System.Net.WebClient).DownloadString('https://launchermeta.mojang.com/mc/game/version_manifest_v2.json') | Out-String | ConvertFrom-Json)); $stuff=($data.versions | Where-Object -Property id -Value !MINECRAFT! -EQ); $stuff.url"') DO SET MOJANGVERSIONURL2=%%A
:: Looks at the version JSON URL at the Mojang file server to get the SHA1 checksum for the server JAR file
FOR /F %%A IN ('powershell -Command "$data=(((New-Object System.Net.WebClient).DownloadString('!MOJANGVERSIONURL2!') | Out-String | ConvertFrom-Json)); $data.downloads.server.sha1"') DO SET SERVERSHA1REAL=%%A


:: Gets the SHA1 checksum for the downloaded server JAR.
SET /a idm=0 
FOR /F %%F  IN ('certutil -hashfile minecraft_server.!MINECRAFT!.jar SHA1') DO (
      SET SHA1VAL[!idm!]=%%F
      SET /a idm+=1
)
SET SERVERJARSHA1=!SHA1VAL[1]!
  
:: Checks to see if the calculated checksum is the same as the value specified from Mojang information
IF !SERVERSHA1REAL! NEQ !SERVERJARSHA1! (
  DEL minecraft_server.!MINECRAFT!.jar
  ECHO: & ECHO: & ECHO:
  ECHO   THE MINECRAFT SERVER JAR FILE CHECKSUM VALUE DID NOT MATCH THE CHECKSUM IT WAS SUPPOSED TO BE
  ECHO   THIS LIKELY MEANS A CORRUPTED DOWNLOAD.
  ECHO:
  ECHO   PRESS ANY KEY TO TRY DOWNLOADING AGAIN! & ECHO: & ECHO:
  PAUSE
  GOTO :preparevanilla
)
ECHO   Checksum values of downloaded server JAR and expected value match - file is valid & ECHO:
%DELAY%
IF /I !MODLOADER!==FORGE GOTO :returnfromgetvanillajar
IF /I !MODLOADER!==NEOFORGE GOTO :returnfromgetvanillajar

:skipvanillainstall
:: Goes to the EULA section, after that it goes directly to the launchvanilla label
GOTO :eula

:: END VANILLA INSTALLATION SECTION

:: FINALLY LAUNCH FABRIC / QUILT / VANILLA SERVER!
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

IF NOT DEFINED FOUNDGOODFIREWALLRULE IF NOT DEFINED BYPASSFIREWALLRULECHECK GOTO :firewallcheck
:reallydofabric

ECHO: & ECHO   Launching... & ping -n 2 127.0.0.1 >nul & ECHO   Launching.. & ping -n 2 127.0.0.1 >nul & ECHO   Launching. & ECHO:

IF !OVERRIDE!==Y SET "JAVAFILE=java"
TITLE Universalator - !MINECRAFT! !MODLOADER!

:: Actually launch the server!
IF /I !MODLOADER!==FABRIC (
%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% -jar fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar nogui
)
IF /I !MODLOADER!==QUILT (
%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% -jar quilt-server-launch-!MINECRAFT!-!QUILTLOADER!.jar nogui
)
IF /I !MODLOADER!==VANILLA (
%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% -jar minecraft_server.!MINECRAFT!.jar nogui
)

PAUSE
:: Complains in console output if launch attempt crashes
IF NOT EXIST "%HERE%\logs\latest.log" GOTO :skipfabriclogs
:: Looks for the stopping the server text to decide if the server was shut down on purpose.  If so goes to main menu.
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"Stopping the server" >nul 2>&1 && PAUSE && GOTO :mainmenu

:: Search if java version mismatch is found
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"Unsupported class file major version" >nul 2>&1
IF !ERRORLEVEL!==0 (
  ECHO: & ECHO        %red% --SPECIAL NOTE-- %blue%
  ECHO    %yellow% FROM SCANNING THE LOGS IT LOOKS LIKE YOUR SERVER MAY HAVE CRASHED FOR ONE OF TWO REASONS:  %blue%
  ECHO    %yellow% --YOUR SELECTED JAVA VERSION IS CRASHING WITH THE CURRENT FORGE AND MODS VERSIONS %blue%
  ECHO    %yellow% --AT LEAST ONE MOD FILE IN THE MODS FOLDER IS FOR A DIFFERENT VERSION OF FORGE / MINECRAFT %blue% & ECHO:
  ECHO        %red% --SPECIAL NOTE-- %blue% & ECHO:
)

:: Search if the standard client side mod message was found.  Ignore if java 19 is detected as probably the more important item.
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"invalid dist DEDICATED_SERVER" >nul 2>&1
IF !ERRORLEVEL!==0 (
  ECHO: & ECHO        %red% --- SPECIAL MESSAGE --- %blue%
  ECHO    THE TEXT 'invalid dist DEDICATED_SERVER' WAS FOUND IN THE LOG FILE
  ECHO    THIS COULD MEAN YOU HAVE CLIENT MODS CRASHING THE SERVER - OTHERWISE SOME MOD AUTHORS DID NOT SILENCE THAT MESSAGE.
  ECHO:
  ECHO    TRY USING THE UNIVERSALATOR %green% 'SCAN' %blue% OPTION TO FIND CLIENT MODS.
  ECHO        %red% --- SPECIAL MESSAGE --- %blue% & ECHO:
)
PAUSE
:skipfabriclogs
GOTO :mainmenu

:: BEGIN UPNP SECTION
:upnpmenu
:: First check to see if LOCALIP was found previously on launch or not.  If miniUPnP was just installed during this program run it needs to be done!
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" IF NOT DEFINED LOCALIP (
  SET LOCALIP=NOLOCALIPFOUND
  FOR /F "delims=" %%E IN ('univ-utils\miniupnp\upnpc-static.exe -l') DO (
    SET CHECKUPNPSTATUS=%%E
    IF "!CHECKUPNPSTATUS!" NEQ "!CHECKUPNPSTATUS:Local LAN ip address=replace!" SET LANLINE=%%E
  )
  IF DEFINED LANLINE (
  FOR /F "tokens=5 delims=: " %%T IN ("!LANLINE!") DO SET LOCALIP=%%T
)
)
:: Sets a variable to toggle so that IP addresses can be shown or hidden
IF NOT DEFINED SHOWIP SET SHOWIP=N
:: Actually start doing the upnp menu
CLS
ECHO:%yellow%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO      UPNP PORT FORWARDING MENU    
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%blue%
ECHO: & ECHO:
IF NOT EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
ECHO   %yellow% MiniUPnP PROGRAM %blue% - %red% NOT YET INSTALLED / DOWNLOADED %blue%
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
ECHO      - The program used by the Universalator to do UPnP functions - MiniUPnP, is not downloaded by default.
ECHO        To check if your router can use UPnP, and use it for setting up port forwarding - you can
ECHO        enter %yellow% 'DOWNLOAD' %blue% to install the MiniUPnP program and enable the Universalator UPNP Menu.
ECHO: & ECHO:
ECHO: & ECHO   ENTER YOUR SELECTION & ECHO      %green% 'DOWNLOAD' - Download UPnP Program %blue% & ECHO      %green% 'M' - Main Menu %blue%
)

IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
ECHO: & ECHO   %yellow% MiniUPnP PROGRAM %blue% - %green% DOWNLOADED %blue%
IF !ISUPNPACTIVE!==N ECHO   %yellow% UPNP STATUS %blue% -      %red% NOT ACTIVATED: %blue% & ECHO                        %red% 'A' - ACTIVATE %yellow% OR %red% SET UP AND USE MANUAL NETWORK ROUTER PORT FORWARDING %blue% & ECHO:
IF !ISUPNPACTIVE!==Y  ECHO   %yellow% UPNP STATUS %blue% - %green% ACTIVE - FORWARDING PORT %PORT% %blue% & ECHO:
IF !SHOWIP!==Y ECHO                                                               %yellow% Local IP:port  %blue% - !LOCALIP!:%PORT%
IF !SHOWIP!==Y ECHO                                                               %yellow% Public IP:port %blue% - !PUBLICIP!:%PORT%
IF !SHOWIP!==N ECHO:
IF !SHOWIP!==N ECHO:
ECHO:
ECHO   %green% CHECK - Check for a network router with UPnP enabled %blue% 
IF !SHOWIP!==N ECHO   %green% SHOW  - Show your Local and Public IP addresses %blue% && ECHO:
IF !SHOWIP!==Y ECHO   %green% HIDE  - Hide your Local and Public IP addresses %blue% && ECHO:
ECHO   %green%                                       %blue%
ECHO   %green% A - Activate UPnP Port Forwarding     %blue%
ECHO   %green%                                       %blue%
ECHO   %green% D - Deactivate UPnP Port Forwarding   %blue%
ECHO   %green%                                       %blue%
ECHO   %green% S - Status of port forwarding refresh %blue%
ECHO   %green%                                       %blue%
ECHO: & ECHO   %green% M - Main Menu %blue%
ECHO: & ECHO   Enter your choice:
)
ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P "ASKUPNPMENU="
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
IF /I !ASKUPNPMENU!==M GOTO :mainmenu
IF /I !ASKUPNPMENU!==CHECK GOTO :upnpvalid
IF /I !ASKUPNPMENU!==A GOTO :upnpactivate
IF /I !ASKUPNPMENU!==D GOTO :upnpdeactivate
IF /I !ASKUPNPMENU!==S GOTO :upnpstatus
IF /I !ASKUPNPMENU!==SHOW (
  SET SHOWIP=Y
  GOTO :upnpmenu
)
IF /I !ASKUPNPMENU!==HIDE (
  SET SHOWIP=N
  GOTO :upnpmenu
)
IF /I !ASKUPNPMENU! NEQ M IF /I !ASKUPNPMENU! NEQ CHECK IF /I !ASKUPNPMENU! NEQ A IF /I !ASKUPNPMENU! NEQ D IF /I !ASKUPNPMENU! NEQ S GOTO :upnpmenu
)

IF NOT EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
IF /I !ASKUPNPMENU!==DOWNLOAD GOTO :upnpdownload
IF /I !ASKUPNPMENU!==M GOTO :mainmenu
IF /I !ASKUPNPMENU! NEQ DOWNLOAD IF /I !ASKUPNPMENU! NEQ M GOTO :upnpmenu
)

:: BEGIN UPNP LOOK FOR VALID & ENABLED UPNP ROUTER
:upnpvalid
:: Loops through the status flag -s looking for lines that are different between itself and itself but replacing any found 'Found valid IGD' with random other string.
SET FOUNDVALIDUPNP=N
ECHO   Checking for UPnP Enabled Network Router ... ... ...
FOR /F "delims=" %%B IN ('univ-utils\miniupnp\upnpc-static.exe -s') DO (
    SET UPNPSCAN=%%B
    IF "!UPNPSCAN!" NEQ "!UPNPSCAN:Found valid IGD=huh!" SET FOUNDVALIDUPNP=Y
)
:: Messages to confirm or give the bad news about finding a UPNP enabled device.
IF !FOUNDVALIDUPNP!==N (
    CLS
    ECHO:& ECHO:
    ECHO   %red% NO UPNP ENABLED NETWORK ROUTER WAS FOUND - SORRY. %blue% & ECHO:
    ECHO   IT IS POSSIBLE THAT YOUR ROUTER DOES HAVE UPNP COMPATIBILITY BUT IT IS CURRENTLY
    ECHO   SET TO DISABLED.  CHECK YOUR NETWORK ROUTER SETTINGS.
    ECHO: & ECHO   or & ECHO:
    ECHO   YOU WILL NEED TO CONFIGURE PORT FORWARDING ON YOUR NETWORK ROUTER MANUALLY
    ECHO   FOR INSRUCTIONS YOU CAN WEB SEARCH PORT FORWARDING MINECRAFT SERVERS
    ECHO   OR
    ECHO   VISIT THE UNIVERSALATOR WIKI AT:
    ECHO   https://github.com/nanonestor/universalator/wiki
    ECHO: & ECHO:
    PAUSE
    GOTO :upnpmenu
)
IF !FOUNDVALIDUPNP!==Y (
    CLS
    ECHO: & ECHO: & ECHO:
    ECHO     %green% FOUND A NETWORK ROUTER WITH UPNP ENABLED FOR USE %blue%
    ECHO:
    SET ISUPNPACTIVE=N
    PAUSE
    GOTO :upnpmenu
)
GOTO :upnpmenu
:: END UPNP LOOK FOR VALID & ENABLED UPNP ROUTER


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
IF /I !ENABLEUPNP!==N GOTO :upnpmenu
SET /a CYCLE=1
SET ACTIVATING=Y
ECHO: & ECHO   %yellow%  Attempting to activate UPnP port forwarding ... .. . %blue% & ECHO:
:activatecycle
:: Tries several different command methods to activate the port forward using miniUPnP.  Each attempt then goes to get checked for success in the upnpstatus section.
IF !CYCLE!==1 (
  FOR /F "delims=" %%A IN ('univ-utils\miniupnp\upnpc-static.exe -a !LOCALIP! %PORT% %PORT% TCP 0') DO (
    SET TEMPM=%%A
    IF "!TEMPM!" NEQ "!TEMPM:ConflictInMappingEntry=x!" (
      ECHO: & ECHO   %red% UPNP ACTIVATION NOT SUCCESSFUL - IT LOOKS LIKE PORT SELECTION IS ALREADY IN USE %blue%
      ECHO: & ECHO   %yellow%  TRY CLOSING ANY OLD SERVER WINDOWS OR BACKGROUND PROCESSES / RESTART COMPUTER / RESTART NETWORK ROUTER & ECHO:
      PAUSE
      GOTO :upnpmenu
    )
  )
  SET /a CYCLE+=1
  GOTO :activatestatus
)
IF !CYCLE!==2 (
  FOR /F "delims=" %%A IN ('univ-utils\miniupnp\upnpc-static.exe -r %PORT% TCP') DO (
      SET TEMPM=%%A
    IF "!TEMPM!" NEQ "!TEMPM:ConflictInMappingEntry=x!" (
      ECHO: & ECHO   %red% UPNP ACTIVATION NOT SUCCESSFUL - IT LOOKS LIKE PORT SELECTION IS ALREADY IN USE %blue%
      ECHO: & ECHO   %yellow%  TRY CLOSING ANY OLD SERVER WINDOWS OR BACKGROUND PROCESSES / RESTART COMPUTER / RESTART NETWORK ROUTER & ECHO:
      PAUSE
      GOTO :upnpmenu

    )
  )
  SET /a CYCLE+=1
  GOTO :activatestatus
)
IF !CYCLE!==3 (
  FOR /F "delims=" %%A IN ('univ-utils\miniupnp\upnpc-static.exe -a %PUBLICIP% %PORT% %PORT% TCP') DO (
      SET TEMPM=%%A
    IF "!TEMPM!" NEQ "!TEMPM:ConflictInMappingEntry=x!" (
      ECHO: & ECHO   %red% UPNP ACTIVATION NOT SUCCESSFUL - IT LOOKS LIKE PORT SELECTION IS ALREADY IN USE %blue%
      ECHO: & ECHO   %yellow%  TRY CLOSING ANY OLD SERVER WINDOWS OR BACKGROUND PROCESSES / RESTART COMPUTER / RESTART NETWORK ROUTER & ECHO:
      PAUSE
      GOTO :upnpmenu

    )
  )
  SET /a CYCLE+=1
  GOTO :activatestatus
)
SET ACTIVATING=N
:: Activating if reaching here has failed - run a scan of the first activation method to try and produce an error code to read
ECHO:
ECHO   %red% SORRY - The activation of UPnP port forwarding was not detected to have worked. %blue% & ECHO: & ECHO:
PAUSE
GOTO :upnpmenu

:: END UPNP ACTIVATE PORT FORWARD


:: BEGIN UPNP CHECK STATUS
:upnpstatus
:: Loops through the lines in the -l flag to list MiniUPNP active ports - looks for a line that is different with itself compated to itself but
:: trying to replace any string inside that matches the port number with a random different string - in this case 'PORT' for no real reason.
:: Neat huh?  Is proabably faster than piping an echo of the variables to findstr and then checking errorlevels (other method to do this).
ECHO   %red% Checking Status of UPnP Port Forward ... ... ... %blue% & ECHO:
:activatestatus
SET ISUPNPACTIVE=N
FOR /F "delims=" %%E IN ('univ-utils\miniupnp\upnpc-static.exe -l') DO (
    SET UPNPSTATUS=%%E
    IF "!UPNPSTATUS!" NEQ "!UPNPSTATUS:%PORT%=PORT!" SET ISUPNPACTIVE=Y
)
:: IF detected port is active then reset var set if sent here by activating code, then either way go back to upnp menu.
IF !ISUPNPACTIVE!==Y (
  IF DEFINED ACTIVATING SET ACTIVATING=N
  ECHO:
  ECHO   %green% ACTIVE - Port forwarding using UPnP is active for port %PORT% %blue%
  ECHO: & ECHO:
  PAUSE
  GOTO :upnpmenu
)
:: if script was sent here by the activating section and port forward still not active - goes back there.
IF !ISUPNPACTIVE!==N IF DEFINED ACTIVATING IF !ACTIVATING!==Y GOTO :activatecycle
:: Otherwise goes back to upnpmenu
IF !ISUPNPACTIVE!==N ECHO   %red% NOT ACTIVE - Port forwarding using UPnP is not active for port %PORT% %blue% & ECHO:
PAUSE
GOTO :upnpmenu
:: END UPNP CHECK STATUS


:: BEGIN UPNP DEACTIVATE AND CHECK STATUS AFTER
:upnpdeactivate
IF NOT DEFINED ISUPNPACTIVE GOTO :upnpmenu
IF !ISUPNPACTIVE!==N GOTO :upnpmenu
IF !ISUPNPACTIVE!==Y (
    CLS
    ECHO: & ECHO: & ECHO:
    ECHO   %yellow% UPNP IS CURRENTLY ACTIVE %blue%
    ECHO:
    ECHO   %yellow% DO YOU WANT TO DEACTIVATE IT? %blue%
    ECHO: & ECHO:
    ECHO       %green% 'Y' or 'N' %blue% & ECHO:
    ECHO       Enter your choice: & ECHO:
    SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
    SET /P "DEACTIVATEUPNP="
)
IF /I !DEACTIVATEUPNP! NEQ Y IF /I !DEACTIVATEUPNP! NEQ N GOTO :upnpdeactivate
IF /I !DEACTIVATEUPNP!==N GOTO :upnpmenu
:: Deactivates the port connection used by the MiniUPNP program.
IF /I !DEACTIVATEUPNP!==Y (
    ECHO: & ECHO   %yellow% Attempting to deactivate UPnP port forwarding ... .. . %blue%
    univ-utils\miniupnp\upnpc-static.exe -d %PORT% TCP >nul
    SET ISUPNPACTIVE=N
    FOR /F "delims=" %%E IN ('univ-utils\miniupnp\upnpc-static.exe -l') DO (
        SET UPNPSTATUS=%%E
        IF "!UPNPSTATUS!" NEQ "!UPNPSTATUS:%PORT%=PORT!" SET ISUPNPACTIVE=Y
    )
    IF !ISUPNPACTIVE!==N (
        ECHO: & ECHO:
        ECHO   %yellow% UPNP SUCCESSFULLY DEACTIVATED %blue%
        ECHO:
        PAUSE
        GOTO :upnpmenu
    )
    IF !ISUPNPACTIVE!==Y (
      ECHO: & ECHO: & ECHO:
      ECHO   %red% DEACTIVATION OF UPNP PORT FORWARDING HAS FAILED %blue% & ECHO:
      ECHO   %red% UPNP PORT FORWARDING IS STILL ACTIVE %blue% & ECHO:
      PAUSE
      GOTO :upnpmenu
    )
)
:: END UPNP DEACTIVATE AND CHECK STATUS AFTER


:: BEGIN UPNP FILE DOWNLOAD
:upnpdownload
CLS
ECHO: & ECHO:
ECHO  %yellow% DOWNLOAD MINIUPNP PROGRAM? %blue% & ECHO:
ECHO  ENTERING 'Y' WILL DOWNLOAD THE MINIUPnP PROGRAM FROM THAT PROJECTS WEBSITE AT: & ECHO:
ECHO   http://miniupnp.free.fr/files/ & ECHO:
ECHO   MiniUPnP is published / licensed as a free and open source program. & ECHO:
ECHO  %yellow% DOWNLOAD MINIUPNP PROGRAM? %blue% & ECHO:
ECHO   ENTER YOUR CHOICE: & ECHO:
ECHO   %green%  'Y' - Download file %blue%
ECHO   %green%  'N' - NO  (Back to UPnP menu) %blue% & ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P "ASKUPNPDOWNLOAD="
IF /I !ASKUPNPDOWNLOAD! NEQ N IF /I !ASKUPNPDOWNLOAD! NEQ Y GOTO :upnpdownload
IF /I !ASKUPNPDOWNLOAD!==N GOTO :upnpmenu
:: If download is chosen - download the MiniUPNP Windows client ZIP file, License.  Then unzip out only the standalone miniupnp-static.exe file and delete the ZIP.
IF /I !ASKUPNPDOWNLOAD!==Y IF NOT EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
  CLS
  ECHO: & ECHO: & ECHO   Downloading ZIP file ... ... ... & ECHO:
  IF NOT EXIST "%HERE%\univ-utils\miniupnp" MD "%HERE%\univ-utils\miniupnp"
  powershell -Command "(New-Object Net.WebClient).DownloadFile('http://miniupnp.free.fr/files/upnpc-exe-win32-20220515.zip', 'univ-utils\miniupnp\upnpc-exe-win32-20220515.zip')"
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/miniupnp/miniupnp/master/LICENSE', 'univ-utils\miniupnp\LICENSE.txt')"
  IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-exe-win32-20220515.zip" (
    ECHO   %green% SUCCESSFULLY DOWNLOADED MINIUPNP BINARAIES ZIP FILE %blue%
    PUSHD "%HERE%\univ-utils\miniupnp"
    tar -xf upnpc-exe-win32-20220515.zip upnpc-static.exe >nul
    DEL upnpc-exe-win32-20220515.zip >nul 2>&1
    POPD
  ) ELSE (
      ECHO: & ECHO  %red% DOWNLOAD OF MINIUPNP FILES ZIP FAILED %blue%
      PAUSE
      GOTO :upnpmenu
  )
  IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
    SET FOUNDUPNPEXE=Y
    SET ISUPNPACTIVE=N
    ECHO: & ECHO   %green% MINIUPNP FILE upnpc-static.exe SUCCESSFULLY EXTRACTED FROM ZIP %blue% & ECHO:
    ECHO   %yellow% Checking current UPnP status ... ... ... %blue% & ECHO:
    FOR /F "delims=" %%E IN ('univ-utils\miniupnp\upnpc-static.exe -l') DO (
        SET UPNPSTATUS=%%E
        IF "!UPNPSTATUS!" NEQ "!UPNPSTATUS:%PORT%=PORT!" SET ISUPNPACTIVE=Y
    )
    ECHO       Going back to UPnP menu ... ... ... & ECHO:
    PAUSE
    GOTO :upnpmenu
  ) ELSE (
    SET FOUNDUPNPEXE=N
    ECHO: & ECHO   %green% MINIUPNP BINARY ZIP FILE WAS FOUND TO BE DOWNLOADED %blue% & ECHO   %red% BUT FOR SOME REASON EXTRACTING THE upnpc-static.exe FILE FROM THE ZIP FAILED %blue%
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
ECHO %yellow% Searching 'mods' folder for MCreator mods [Please Wait] %blue%
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
