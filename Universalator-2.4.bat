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
  ::    1- ONLY DO FOLLOWING AFTER SUCCESSFULLY LAUNCHING A SERVER AT LEAST ONCE ALL THE WAY TO WORLD CREATION - THIS GUARANTEES FILES AT LEAST WORK TO THAT POINT
  ::    3- CREATE A ZIP FILE CONTAINING:  
  ::        A- THIS BAT
  ::        B- settings-universalator.txt
  ::        C- THE 'MODS' FOLDER
  ::        D- ANY OTHER SPECIAL FOLDERS/FILES WANTED (FOR EXAMPLE THE 'CONFIGS' AND 'DEFAULTCONFIGS' FOLDERS).
  ::      DO NOT INCLUDE MODLOADER / MINECRAFT FILES/FOLDERS.  'DO NOT INCLUDE' EXAMPLES- LIBRARIES, .FABRIC, server.jar
  ::      ONLY INCLUDE FOLDERS/FILES THAT YOU KNOW ARE REQUIRED OR WANTED.  DEFAULT FOLDERS/FILES NOT INCLUDED WILL GENERATE AUTOMATICALLY WITH DEFAULT VALUES.
:: ------------------------------------------------
:: README ABOVE -- NOTES -- README -- NOTES





:: Enter custom JVM arguments in this ARGS variable
:: DO NOT INCLUDE Xmx -- THAT IS HANDLED BY ANOTHER VARIABLE IN PROGRAM
 SET ARGS=-XX:+IgnoreUnrecognizedVMOptions -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:+DisableExplicitGC -XX:+PerfDisableSharedMem -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -XX:MaxTenuringThreshold=1 -XX:SurvivorRatio=32 -XX:MaxGCPauseMillis=100 -XX:GCPauseIntervalMillis=150 -XX:TargetSurvivorRatio=90 -XX:+UseFastAccessorMethods -XX:+UseCompressedOops -XX:ReservedCodeCacheSize=2048m -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1NewSizePercent=30 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20








:: DO NOT EDIT INFORMATION BELOW - SCRIPT FILE (WILL PROBABLY) BREAK

:: DO NOT EDIT INFORMATION BELOW - SCRIPT FILE (WILL PROBABLY) BREAK

:: DO NOT EDIT INFORMATION BELOW - SCRIPT FILE (WILL PROBABLY) BREAK









ECHO: && ECHO: && ECHO   Loading ... ... ...

:: BEGIN GENERAL PRE-RUN ITEMS
setlocal enabledelayedexpansion
:: Sets the current directory as the working directory - this should fix attempts to run the script as admin.
PUSHD "%~dp0" >nul 2>&1

:: Sets the title and backgound color of the command window
TITLE Universalator
color 1E
:: Additional JVM arguments that will always be applied
SET OTHERARGS=-Dlog4j2.formatMsgNoLookups=true
:: These variables set to exist as blank in case windows is older than 10 and they aren't assigned otherwise
SET "yellow="
SET "blue="
:: Sets a HERE variable equal to the current directory string.
SET "HERE=%cd%"

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

:: If Windows is greater than or equal to version 10 then set some variables to set console output colors!  Then skip OS warning.
IF %major% GEQ 10 (
  SET yellow=[34;103m
  SET blue=[93;44m
  SET green=[93;42m
  SET red=[93;101m
  GOTO :skipwin
)
IF %major% LEQ 9 (
    ECHO:
    ECHO YOUR WINDOWS VERSION IS OLD ENOUGH TO NOT BE SUPPORTED
    ECHO UPDATING TO WINDOWS 10 OR GREATER IS HIGHLY RECOMMENDED
    ECHO:
    PAUSE && EXIT [\B]
)
:skipwin

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
    PAUSE && EXIT [\B]
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
    PAUSE && EXIT [\B]
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
    PAUSE && EXIT [\B]
  )
:skipjavatooloptions

:: Checks to see if the end of this BAT file name ends in ) which is a special case that causes problems with command executions!
SET THISNAME="%~n0"
SET LASTCHAR="%THISNAME:~-2,1%"
IF %LASTCHAR%==")" (
  CLS
  ECHO:
  ECHO   This BAT file was detected to have a file name ending in a closed parentheses character " ) "
  ECHO:
  ECHO    This is a special case character that causes problems with command executions in BAT scripts.
  ECHO    Please rename this file to remove at least that name ending character and try again.
  ECHO:
  PAUSE && EXIT [\B]
)

:: The below SET PATH only applies to this command window launch and isn't permanent to the system's PATH.
SET PATH=%PATH%;"C:\Windows\Syswow64\"

:: Checks to see if CMD is working by checking WHERE for some commands
WHERE FINDSTR >nul 2>&1
IF %ERRORLEVEL% NEQ 0 SET CMDBROKEN=Y
WHERE CERTUTIL >nul 2>&1
IF %ERRORLEVEL% NEQ 0 SET CMDBROKEN=Y
WHERE NETSTAT >nul 2>&1
IF %ERRORLEVEL% NEQ 0 SET CMDBROKEN=Y
WHERE PING >nul 2>&1
IF %ERRORLEVEL% NEQ 0 SET CMDBROKEN=Y
WHERE CURL >nul 2>&1
IF %ERRORLEVEL% NEQ 0 SET CMDBROKEN=Y

IF DEFINED CMDBROKEN IF !CMDBROKEN!==Y (
  ECHO:
  ECHO        %yellow% WARNING - PROBLEM DETECTED %blue%
  ECHO        %yellow% CMD / COMMAND PROMPT FUNCTIONS ARE NOT WORKING CORRECTLY ON YOUR WINDOWS INSTALLATION. %blue%
  ECHO:
  ECHO             FOR REPAIR SOLUTIONS
  ECHO             SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
  ECHO:
  ECHO             https://github.com/nanonestor/universalator/wiki
  ECHO:
  ECHO             or
  ECHO             Web search for fixing / repairing Windows Command prompt function.
  ECHO:
  ECHO        %yellow% WARNING - PROBLEM DETECTED %blue%
  ECHO        %yellow% CMD / COMMAND PROMPT FUNCTIONS ARE NOT WORKING CORRECTLY ON YOUR WINDOWS INSTALLATION. %blue%
  ECHO: & ECHO: & ECHO: & ECHO:
  PAUSE && EXIT [\B]
)

:: Checks to see if Powershell is installed.  If not recognized as command or exists as file it will send a message to install.
:: If exists as file then the path is simply not set and the ELSE sets it for this script run.

WHERE powershell >nul 2>&1
IF %ERRORLEVEL% NEQ 0 IF NOT EXIST "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" (
  ECHO:
  ECHO   Uh oh - POWERSHELL is not detected as installed to your system.
  ECHO:
  ECHO   'Microsoft Powershell' is required for this program to function.
  ECHO   Web search to find an installer for this product!
  ECHO:
  ECHO   FOR ADDITIONAL INFORMATION - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
  ECHO   https://github.com/nanonestor/universalator/wiki
  ECHO:
  PAUSE && EXIT [\B]

) ELSE SET PATH=%PATH%;"C:\Windows\System32\WindowsPowerShell\v1.0\"

:: This is to fix an edge case issue with folder paths ending in ).  Yes this is worked on already above - including this anyways!
SET LOC=%cd:)=]%

SET FOLDER=GOOD
:: Checks folder location this BAT is being run from for various system folders.  Sends appropriate messages if needed.
ECHO "%LOC%" | FINDSTR /i "onedrive documents desktop downloads .minecraft" 1>NUL && SET FOLDER=BAD
ECHO "%LOC%" | FINDSTR /C:"Program Files" >nul 2>&1 && SET FOLDER=BAD
IF "%cd%"=="C:\" SET FOLDER=BAD

IF !FOLDER!==BAD (
    CLS
    ECHO:
    ECHO   %red% %LOC% %blue%
    ECHO:
    ECHO   %yellow% THE SERVER FOLDER THIS IS BEING RUN FROM ^(shown above^) WAS DETECTED TO BE %blue%
    ECHO   %yellow% INSIDE A FOLDER OR SUBFOLDER CONTAINING THE NAME: %blue% && ECHO:
    ECHO       %red%'ONEDRIVE'%blue%
    ECHO       %red%'DOCUMENTS'%blue%
    ECHO       %red%'DESKTOP'%blue%
    ECHO       %red%'PROGRAM FILES'%blue%
    ECHO       %red%'DOWNLOADS'%blue%
    ECHO       %red%'.minecraft'%blue% && ECHO:
    ECHO   %yellow% SERVERS SHOULD NOT RUN IN THESE FOLDERS BECAUSE IT CAN CAUSE ISSUES WITH SYSTEM PERMISSIONS OR FUNCTIONS. %blue%
    ECHO:
    ECHO:
    ECHO         --USE FILE EXPLORER TO MAKE A NEW FOLDER OUTSIDE OF ANY OF THE ABOVE FOLDERS
    ECHO           PLACE THE SERVER FILES - OR - THIS ENTIRE FOLDER IN THIS NEW LOCATION
    ECHO:
    ECHO         --EXAMPLES THAT WORK - ANY NEW OR EXISTING FOLDER NOT INSIDE ONE OF THE ABOVE FOLDERS:
    ECHO           %green% C:\MYNEWSERVER\ %blue%   %green% D:\MYSERVERS\MODDEDSERVERNAME\ %blue%
    ECHO: && ECHO:
    PAUSE && EXIT [\B]
)

:: The following line is purely done to guarantee the current ERRORLEVEL is reset
ver >nul

:: Checks if standalone command line version of 7-zip is present.  If not downloads it.
IF NOT EXIST "%HERE%\univ-utils\7-zip" (
  MD univ-utils\7-zip
)
SET ZIP7="%HERE%\univ-utils\7-zip\7za.exe"
:try7zipagain
IF NOT EXIST %ZIP7% (
  CLS
  ECHO Downloading and installing 7-Zip...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/nanonestor/utilities/raw/main/7zipfiles/7za.exe', 'univ-utils\7-zip\7za.exe')" >nul
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/nanonestor/utilities/main/7zipfiles/license.txt', 'univ-utils\7-zip\license.txt')" >nul
)
IF NOT EXIST %ZIP7% (
  ECHO:
  ECHO   DOWNLOADING THE 7-ZIP COMMAND LINE PROGRAM FILE HAS FAILED
  ECHO   THIS FILE IS REQUIRED FOR THE UNIVERSALATOR SCRIPT FUNCTION
  ECHO:
  ECHO   PRESS ANY KEY TO RETRY DOWNLOAD
  PAUSE
  ECHO     Attempting to download again...
  GOTO :try7zipagain
)
IF EXIST settings-universalator.txt (
  RENAME settings-universalator.txt settings-universalator.bat && CALL settings-universalator.bat && RENAME settings-universalator.bat settings-universalator.txt
)
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
  ECHO: && ECHO:
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
  ECHO   Enter your response:
  SET /P "KILLIT="
  IF /I !KILLIT! NEQ KILL IF /I !KILLIT! NEQ Q GOTO :portwarning
  IF /I !KILLIT!==Q (
    PAUSE && EXIT [\B]
  )
  IF /I !KILLIT!==KILL (
    CLS
    ECHO:
    ECHO   ATTEMPTING TO KILL TASK PLEASE WAIT...
    ECHO:
    TASKKILL /F /PID %PIDNUM%
    ping -n 10 127.0.0.1 > nul
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
  ECHO: && ECHO:  && ECHO: 
  PAUSE && EXIT [\B]
)
IF %ERRORLEVEL%==1 (
  ECHO:
  ECHO   SUCCESS!
  ECHO   IT SEEMS LIKE KILLING THE PROGRAM WAS SUCCESSFUL IN CLEARING THE PORT!
  ECHO:
  ping -n 5 127.0.0.1 > nul
)

:: Below line is purely done to guarantee that the current ERRORLEVEL is reset to 0
:skipportclear
ver > nul
:: END CHECKING IF CURRENT PORT SET IN server.properties IS ALREAY IN USE

:: BEGIN SETTING VARIABLES TO PUBLIC IP AND PORT SETTING
FOR /F %%B IN ('powershell -Command "Invoke-RestMethod api.ipify.org"') DO SET PUBLICIP=%%B
FOR /F %%A IN ('findstr server-port server.properties') DO SET PORTLINE=%%A
IF DEFINED PORTLINE SET PORT=%PORTLINE:~12%
IF NOT DEFINED PORT SET PORT=25565
:: END SETTING VARIABLES TO PUBLIC IP AND PORT SETTING

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

IF NOT DEFINED LOCALIP (
  FOR /F "delims=" %%G IN ('ipconfig') DO (
      SET LOOKFORIPV4=%%G
      IF "!LOOKFORIPV4!" NEQ "!LOOKFORIPV4:IPv4 Address=replace!" (
        FOR /F "tokens=13 delims=: " %%T IN ("!LOOKFORIPV4!") DO SET LOCALIP=%%T
      )
  )
)


:: Sets ASKMODSCHECK to use as default if no settings file exists yet.
SET ASKMODSCHECK=Y

:: BEGIN MAIN MENU


:mainmenu

TITLE Universalator
IF EXIST settings-universalator.txt (
  RENAME settings-universalator.txt settings-universalator.bat && CALL settings-universalator.bat && RENAME settings-universalator.bat settings-universalator.txt
  IF DEFINED MAXRAMGIGS IF !MAXRAMGIGS! NEQ "" SET MAXRAM=-Xmx!MAXRAMGIGS!G
)

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
IF DEFINED MODLOADER IF DEFINED FORGE IF /I !MODLOADER!==FORGE ECHO   %yellow% FORGE VERSION %blue%     !FORGE!
IF DEFINED MODLOADER IF DEFINED FABRICLOADER IF /I !MODLOADER!==FABRIC ECHO   %yellow% FABRIC LOADER %blue%     !FABRICLOADER!
IF DEFINED MODLOADER IF DEFINED FABRICINSTALLER IF /I !MODLOADER!==FABRIC ECHO   %yellow% FABRIC INSTALLER %blue%  !FABRICINSTALLER!
IF DEFINED JAVAVERSION ECHO   %yellow% JAVA VERSION %blue%      !JAVAVERSION!
IF NOT DEFINED JAVAVERSION ECHO   %yellow% JAVA VERSION %blue%      %red% ENTER SETTINGS - 'S' %blue%
IF NOT DEFINED MAXRAMGIGS ECHO   %yellow% MAX RAM / MEMORY %blue%  %red% ENTER SETTINGS - 'S' %blue%
ECHO: && ECHO:
IF DEFINED MAXRAMGIGS ECHO   %yellow% MAX RAM / MEMORY %blue%  !MAXRAMGIGS!
ECHO:
ECHO:
IF DEFINED PORT ECHO   %yellow% CURRENT PORT SET %blue%          !PORT!
IF NOT EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" ECHO   %yellow% UPNP PROGRAM (MINIUPNP) %blue% NOT LOADED
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" ECHO   %yellow% UPNP PROGRAM (MINIUPNP) %blue%   LOADED
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" IF !ISUPNPACTIVE!==N ECHO   %yellow% UPNP STATUS %blue%       %red% NOT ACTIVATED %blue%
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" IF !ISUPNPACTIVE!==Y  ECHO   %yellow% UPNP STATUS %blue%  %green% ACTIVE - FORWARDING PORT %PORT% %blue%
IF EXIST settings-universalator.txt ECHO                                                           %green% L %blue% = LAUNCH SERVER
IF NOT EXIST settings-universalator.txt ECHO                                                           %green% 'S' %blue% = SETTINGS ENTRY
IF EXIST settings-universalator.txt ECHO                                                           %green% 'S' %blue% = RE-ENTER ALL SETTINGS
ECHO:
ECHO                                                           %green% 'UPNP' %blue% = UPNP PORT FORWARDING MENU
IF DEFINED MODLOADER ECHO                                                           %green% 'SCAN' %blue% = SCAN MOD FILES FOR CLIENT MODS && ECHO:
IF EXIST settings-universalator.txt ECHO   %green% ENTRY CHOICES: %blue% %green% 'L',  'S',  'UPNP', 'SCAN', 'J'-(JAVA), 'R'-(RAM), or 'Q'-(quit) %blue%
IF NOT DEFINED MODLOADER ECHO: && ECHO   %green% ENTRY CHOICES: %blue%   %green% 'S'-(settings),  'UPNP'-(menu), or  'Q'-(quit) %blue%
set /P "MAINMENU="
IF DEFINED MODLOADER IF DEFINED MINECRAFT (
  IF /I !MAINMENU! NEQ L IF /I !MAINMENU! NEQ S IF /I !MAINMENU! NEQ R IF /I !MAINMENU! NEQ J IF /I !MAINMENU! NEQ UPNP IF /I !MAINMENU! NEQ Q IF /I !MAINMENU! NEQ SCAN IF /I !MAINMENU! NEQ OVERRIDE IF /I !MAINMENU! NEQ MCREATOR GOTO :mainmenu
)
IF NOT DEFINED MODLOADER (
  IF /I !MAINMENU! NEQ S IF /I !MAINMENU! NEQ UPNP IF /I !MAINMENU! NEQ Q IF /I !MAINMENU! NEQ OVERRIDE IF /I !MAINMENU! NEQ MCREATOR GOTO :mainmenu
)
IF /I !MAINMENU!==Q (
  EXIT [\B]
)
IF /I !MAINMENU!==J GOTO :getmcmajor
IF /I !MAINMENU!==UPNP GOTO :upnpmenu
IF /I !MAINMENU!==R GOTO :justsetram
IF /I !MAINMENU!==S GOTO :startover
IF /I !MAINMENU!==L IF EXIST settings-universalator.txt IF DEFINED MINECRAFT IF DEFINED MODLOADER IF DEFINED JAVAVERSION GOTO :actuallylaunch
IF /I !MAINMENU!==SCAN IF EXIST "%HERE%\mods" GOTO :getmcmajor
IF /I !MAINMENU!==SCAN IF NOT EXIST "%HERE%\mods" GOTO :mainmenu
IF /I !MAINMENU!==OVERRIDE GOTO :override
IF /I !MAINMENU!==MCREATOR IF EXIST "%HERE%\mods" GOTO :mcreator
IF /I !MAINMENU!==MCREATOR IF NOT EXIST "%HERE%\mods" GOTO :mainmenu

:: END MAIN MENU


:startover
:: User entry for Minecraft version
CLS
ECHO: && ECHO:
ECHO   %yellow% ENTER THE MINECRAFT VERSION %blue%
ECHO:
ECHO    example: 1.7.10
ECHO    example: 1.16.5
ECHO    example: 1.19.2
ECHO:
ECHO   %yellow% ENTER THE MINECRAFT VERSION %blue%
ECHO: && ECHO:
SET /P MINECRAFT=

:: IF running SCAN from main menu it gets placed here first to get values for MC major and minor versions.
:getmcmajor

:: Stores the major and minor Minecraft version numbers in their own variables as integers.
FOR /F "tokens=2,3 delims=." %%E IN ("!MINECRAFT!") DO (
    SET /a MCMAJOR=%%E
    SET /a MCMINOR=%%F
)

:: IF running SCAN from main menu now goto actual scan section
IF /I !MAINMENU!==SCAN GOTO :actuallyscanmods
IF /I !MAINMENU!==J GOTO :gojava

:reentermodloader
:: User entry for Modloader version
CLS
ECHO: && ECHO:
ECHO   %yellow% ENTER THE MODLOADER TYPE %blue%
ECHO:
ECHO    Valid entries - %green% FORGE %blue% or %green% FABRIC %blue%
ECHO:
ECHO   %yellow% ENTER THE MODLOADER TYPE %blue%
ECHO: && ECHO:
SET /P "MODLOADER="
IF /I !MODLOADER!==FORGE SET MODLOADER=FORGE
IF /I !MODLOADER!==FABRIC SET MODLOADER=FABRIC
IF /I !MODLOADER! NEQ FORGE IF /I !MODLOADER! NEQ FABRIC (
  GOTO :reentermodloader
)

:: Detects if settings are trying to use some weird old Minecraft Forge version that isn't supported.
:: This is done again later after the settings-universalator.txt is present and this is section is skipped.
IF /I !MODLOADER!==FORGE IF !MCMAJOR! LSS 10 IF !MINECRAFT! NEQ 1.6.4 IF !MINECRAFT! NEQ 1.7.10 IF !MINECRAFT! NEQ 1.8.9 IF !MINECRAFT! NEQ 1.9.4 (
  ECHO:
  ECHO  SORRY - YOUR ENTERED MINECRAFT VERSION - FORGE FOR MINECRAFT !MINECRAFT! - IS NOT SUPPORTED.
  ECHO:
  ECHO  FIND A MODPACK WITH A MORE POPULARLY USED VERSION.
  ECHO  OR
  ECHO  PRESS ANY KEY TO START OVER AND ENTER NEW VERSION NUMBERS
  ECHO:
  PAUSE
  GOTO :startover
)
IF /I !MODLOADER!==FORGE GOTO :usedefaulttryagain

:: If Fabric modloader ask user to enter Fabric Installer and Fabric Loader
:redofabricinstaller
IF /I !MODLOADER!==FABRIC (
  CLS
  ECHO:
  ECHO    %yellow% FABRIC INSTALLER - FABRIC INSTALLER %blue%
  ECHO:
  ECHO    DO YOU WANT TO USE THE RECOMMENDED DEFAULT VERSION OF THE FABRIC %yellow% INSTALLER %blue% FILE?
  ECHO    AS OF FEBRUARY 2023 THIS VERSION WAS %green% 0.11.1 %blue%
  ECHO:
  ECHO    UNLESS YOU KNOW OF A NEWER VERSION OR HAVE A PREFERENCE - ENTER %green% 'Y' %blue%
  ECHO:
  ECHO    %yellow% FABRIC INSTALLER - FABRIC INSTALLER %blue%
  ECHO:
  ECHO    ENTER %green% 'Y' %blue% OR %red% 'N' %blue% && ECHO:
  SET /P "ASKFABRICINSTALLER="
)
IF /I !ASKFABRICINSTALLER! NEQ Y IF /I !ASKFABRICINSTALLER! NEQ N GOTO :redofabricinstaller
IF /I !ASKFABRICINSTALLER!==Y SET FABRICINSTALLER=0.11.1
IF /I !ASKFABRICINSTALLER!==N (
  ECHO   %yellow% ENTER A CUSTOM SET FABRIC INSTALLER VERSION: %blue% && ECHO:
  SET /P FABRICINSTALLER=
)
:redofabricloader
IF /I !MODLOADER!==FABRIC (
  CLS
  ECHO:
  ECHO   %yellow% FABRIC LOADER - FABRIC LOADER %blue%
  ECHO:
  ECHO    DO YOU WANT TO USE THE RECOMMENDED DEFAULT VERSION OF THE FABRIC %yellow% LOADER %blue% FILE?
  ECHO    AS OF FEBRUARY 2023 THE LATEST VERSION WAS %green% 0.14.17 %blue%
  ECHO:
  ECHO    UNLESS YOU KNOW OF A NEWER VERSION OR HAVE A PREFERENCE - ENTER %green% 'Y' %blue%
  ECHO:
  ECHO   %yellow% FABRIC LOADER - FABRIC LOADER %blue%
  ECHO:
  ECHO    ENTER %green% 'Y' %blue% OR %red% 'N' %blue% && ECHO:
  SET /P "ASKFABRICLOADER="
)
IF /I !ASKFABRICLOADER! NEQ Y IF /I !ASKFABRICLOADER! NEQ N GOTO :redofabricloader
IF /I !ASKFABRICLOADER!==Y SET FABRICLOADER=0.14.17
IF /I !ASKFABRICLOADER!==N (
  ECHO   %yellow% ENTER A CUSTOM SET FABRIC LOADER VERSION: %blue% && ECHO:
  SET /P FABRICLOADER=
)



IF /I !MODLOADER!==FABRIC GOTO :gojava
:usedefaulttryagain
:: If modloader is Forge present user with option to select recommended versions of Forge and Java.
SET USEDEFAULT=BLANK
IF !MINECRAFT!==1.6.4 (
  CLS
  ECHO: && ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.6.4 WHICH IS A POPULAR VERSION %blue%
  ECHO:
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO:
  ECHO    FORGE = %green% 9.11.1.1345 %blue% && ECHO:
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.6.4 WHICH IS A POPULAR VERSION %blue%
  ECHO: && ECHO:
  ECHO    ENTER %green% 'Y' %blue% TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER %red% 'N' %blue% TO SELECT DIFFERENT VALUES
  ECHO:
  ECHO:
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=9.11.1.1345
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.7.10 (
  CLS
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.7.10 WHICH IS A POPULAR VERSION %blue%
  ECHO:
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO:
  ECHO    FORGE = %green% 10.13.4.1614 %blue% && ECHO:
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.7.10 WHICH IS A POPULAR VERSION %blue%
  ECHO: && ECHO:
  ECHO    ENTER %green% 'Y' %blue% TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER %red% 'N' %blue% TO SELECT DIFFERENT VALUES
  ECHO:
  ECHO:
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=10.13.4.1614
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.8.9 (
  CLS
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.8.9 WHICH IS A POPULAR VERSION %blue%
  ECHO:
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO:
  ECHO    FORGE = %green% 11.15.1.2318 %blue% && ECHO:
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.8.9 WHICH IS A POPULAR VERSION %blue%
  ECHO: && ECHO:
  ECHO    ENTER %green% 'Y' %blue% TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER %red% 'N' %blue% TO SELECT DIFFERENT VALUES
  ECHO:
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=11.15.1.2318
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.9.4 (
  CLS
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.9.4 WHICH IS A POPULAR VERSION %blue%
  ECHO:
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO:
  ECHO    FORGE = %green% 12.17.0.2317 %blue% && ECHO:
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.9.4 WHICH IS A POPULAR VERSION %blue%
  ECHO: && ECHO:
  ECHO    ENTER %green% 'Y' %blue% TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER %red% 'N' %blue% TO SELECT DIFFERENT VALUES
  ECHO:
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=12.17.0.2317
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.10.2 (
  CLS
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.10.2 WHICH IS A POPULAR VERSION %blue%
  ECHO:
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO:
  ECHO    FORGE = %green% 12.18.3.2511 %blue% && ECHO:
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.10.2 WHICH IS A POPULAR VERSION %blue%
  ECHO: && ECHO:
  ECHO    ENTER %green% 'Y' %blue% TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER %red% 'N' %blue% TO SELECT DIFFERENT VALUES
  ECHO:
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=12.18.3.2511
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.12.2 (
  CLS
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.12.2 WHICH IS A POPULAR VERSION %blue%
  ECHO:
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO:
  ECHO    FORGE = %green% 14.23.5.2860 %blue% && ECHO:
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.12.2 WHICH IS A POPULAR VERSION %blue%
  ECHO: && ECHO:
  ECHO    ENTER %green% 'Y' %blue% TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER %red% 'N' %blue% TO SELECT DIFFERENT VALUES
  ECHO:
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=14.23.5.2860
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.14.4 (
  CLS
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.14.4 WHICH IS A POPULAR VERSION %blue%
  ECHO:
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO:
  ECHO    FORGE = %green% 28.2.26 %blue% && ECHO:
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.14.4 WHICH IS A POPULAR VERSION %blue%
  ECHO: && ECHO:
  ECHO    ENTER %green% 'Y' %blue% TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER %red% 'N' %blue% TO SELECT DIFFERENT VALUES
  ECHO:
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=28.2.26
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.15.2 (
  CLS
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.15.2 WHICH IS A POPULAR VERSION %blue%
  ECHO:
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE AND JAVA?
  ECHO:
  ECHO    FORGE = %green% 31.2.57 %blue% && ECHO:
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.15.2 WHICH IS A POPULAR VERSION %blue%
  ECHO: && ECHO:
  ECHO    ENTER %green% 'Y' %blue% TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER %red% 'N' %blue% TO SELECT DIFFERENT VALUES
  ECHO:
  SET /P "USEDEFAULT="
  IF /I !USEDEFAULT!==Y (
    SET FORGE=31.2.57
    SET JAVAVERSION=8
    GOTO :goramentry
  )
)
IF !MINECRAFT!==1.16.5 (
  CLS
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.16.5 WHICH IS A POPULAR VERSION %blue%
  ECHO:
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSION %blue% OF FORGE?
  ECHO:
  ECHO    FORGE = %green% 36.2.39 %blue%
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.16.5 WHICH IS A POPULAR VERSION %blue%
  ECHO: && ECHO:
  ECHO    ENTER %green% 'Y' %blue% TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER %red% 'N' %blue% TO SELECT DIFFERENT VALUES
  ECHO:
  SET /P "USEDEFAULT="
  IF /I !USEDEFAULT!==Y (
    SET FORGE=36.2.39
    GOTO :gojava
  )
)
IF !MINECRAFT!==1.17.1 (
  CLS
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.17.1 WHICH IS A POPULAR VERSION %blue%
  ECHO:
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSIONS %blue% OF FORGE?
  ECHO:
  ECHO    FORGE = %green% 37.1.1 %blue% && ECHO:
  ECHO    JAVA = 16  **JAVA MUST BE 16**
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.17.1 WHICH IS A POPULAR VERSION %blue%
  ECHO: && ECHO:
  ECHO    ENTER %green% 'Y' %blue% TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER %red% 'N' %blue% TO SELECT DIFFERENT VALUES
  ECHO:
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=37.1.1
  SET JAVAVERSION=16
  GOTO :goramentry
)
IF !MINECRAFT!==1.18.2 (
  CLS
  ECHO: && ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.18.2 WHICH IS A POPULAR VERSION %blue%
  ECHO:
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSIONS %blue% OF FORGE AND JAVA?
  ECHO:
  ECHO    FORGE = %green% 40.2.1 %blue% && ECHO:
  ECHO    JAVA =  %green% 17 %blue%
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.18.2 WHICH IS A POPULAR VERSION %blue%
  ECHO: && ECHO:
  ECHO    ENTER %green% 'Y' %blue% TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER %red% 'N' %blue% TO SELECT DIFFERENT VALUES
  ECHO:
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=40.2.1
  SET JAVAVERSION=17
  GOTO :goramentry
)
IF !MINECRAFT!==1.19.2 (
  CLS
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.19.2 WHICH IS A POPULAR VERSION %blue%
  ECHO:
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSIONS %blue% OF FORGE AND JAVA?
  ECHO:
  ECHO    FORGE = %green% 43.2.6 %blue% && ECHO:
  ECHO    JAVA =  %green% 17 %blue%
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.19.2 WHICH IS A POPULAR VERSION %blue%
  ECHO: && ECHO:
  ECHO    ENTER %green% 'Y' %blue% TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER %red% 'N' %blue% TO SELECT DIFFERENT VALUES
  ECHO:
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=43.2.6
  SET JAVAVERSION=17
  GOTO :goramentry
)
IF !MINECRAFT!==1.19.3 (
  CLS
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.19.3 WHICH IS A POPULAR VERSION %blue%
  ECHO:
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT %green% RECOMMENDED VERSIONS %blue% OF FORGE AND JAVA?
  ECHO:
  ECHO    FORGE = %green% 44.1.21 %blue% && ECHO:
  ECHO    JAVA =  %green% 17 %blue%
  ECHO:
  ECHO   %yellow% YOU HAVE ENTERED 1.19.3 WHICH IS A POPULAR VERSION %blue%
  ECHO: && ECHO:
  ECHO    ENTER %green% 'Y' %blue% TO USE ABOVE RECOMMENDED VERSIONS
  ECHO    ENTER %red% 'N' %blue% TO SELECT DIFFERENT VALUES
  ECHO:
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=44.1.21
  SET JAVAVERSION=17
  GOTO :goramentry
)
IF /I !USEDEFAULT!==BLANK GOTO :enterforge
IF /I !USEDEFAULT! NEQ Y IF /I !USEDEFAULT! NEQ N IF /I !USEDEFAULT! NEQ  BLANK GOTO :usedefaulttryagain


:enterforge
  CLS
  ECHO: && ECHO: 
  ECHO  %yellow% ENTER FORGE VERSION %blue% && ECHO:
  ECHO      example: 14.23.5.2860 && ECHO:
  ECHO      example: 36.2.39 && ECHO:
  ECHO      example: 43.2.4
  ECHO: && ECHO  %yellow% ENTER FORGE VERSION %blue% && ECHO:
  SET /P FORGE=


:gojava

IF /I !MODLOADER!==FORGE IF /I !MCMAJOR! GEQ 17 (
  CLS
  ECHO:
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO:
  ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
  ECHO:
  IF /I !MCMAJOR!==17 (
  ECHO   -JAVA VERSION FOR 1.17/1.17.1 %green% MUST BE %blue% 16
  ECHO: && ECHO: && ECHO:
  ) ELSE (
  ECHO   JAVA VERSIONS AVAILABLE FOR MINECRAFT 1.18 and newer -- %green% 17 %blue% *Target version* / RECOMMENDED && ECHO:
  ECHO                                                        -- %green% 18 %blue% && ECHO:
  ECHO                                                        -- %green% 19 %blue%
  ECHO:
  ECHO:  JAVA 18 OR 19 %green% MAY %blue% OR %red% MAY NOT %blue% WORK - DEPENDING ON MODS BEING LOADED OR CHANGES IN THE FABRIC LOADER
  ECHO   IF YOU TRY JAVA NEWER THAN 17 AND CRASHES HAPPEN -- EDIT SETTINGS TO TRY 17
  )
  ECHO:
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO: && ECHO:
  SET /P JAVAVERSION=
  IF /I !MCMAJOR! NEQ 17 IF !JAVAVERSION! NEQ 17 IF !JAVAVERSION! NEQ 18 IF !JAVAVERSION! NEQ 19 GOTO :gojava
  IF /I !MCMAJOR!==17 IF !JAVAVERSION! NEQ 16 GOTO :gojava
)

IF /I !MODLOADER!==FORGE IF !MINECRAFT!==1.16.5 (
  CLS
  ECHO:
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO:
  ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
  ECHO:
  ECHO   THE ONLY VERSIONS AVAILABLE THAT WORK WITH MINECRAFT / FORGE 1.16.5 ARE %green% 8 AND 11 %blue%
  ECHO:
  ECHO   USING JAVA 11 %green% MAY %blue% OR %red% MAY NOT %blue% WORK DEPENDING ON MODS BEING LOADED
  ECHO:
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO:
  SET /P JAVAVERSION=
  IF !JAVAVERSION! NEQ 8 IF !JAVAVERSION! NEQ 11 GOTO :gojava
)

IF /I !MODLOADER!==FORGE IF /I !MCMAJOR! LEQ 16 IF !MINECRAFT! NEQ 1.16.5 (
  CLS
  ECHO:
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO:
  ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
  ECHO:
  ECHO:
  ECHO   -JAVA VERSION FOR MINECRAFT OLDER THAN 1.16.5 %green% MUST BE %blue% 8
  ECHO:
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO:
  SET /P JAVAVERSION=
  IF !JAVAVERSION! NEQ 8 GOTO :gojava
)

:: IF Fabric ask for Java verison entry
:fabricram
IF !MODLOADER!==FABRIC (
  CLS
  ECHO:
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO:
  ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
  ECHO:
  ECHO:
  IF !MCMAJOR! LEQ 16 ECHO  THE ONLY JAVA VERSION FOR MINECRAFT EQUAL TO AND OLDER THAN 1.16.5 -- *MUST BE* %green% 8 %blue%
  IF !MCMAJOR!==17 ECHO   JAVA VERSION FOR 1.17/1.17.1 -- *MUST BE* %green% 16 %blue%
  IF !MCMAJOR! GEQ 18 (
  ECHO   JAVA VERSIONS AVAILABLE FOR MINECRAFT 1.18 and newer -- %green% 17 %blue% *Target version* / RECOMMENDED && ECHO:
  ECHO                                                        -- %green% 18 %blue% && ECHO:
  ECHO                                                        -- %green% 19 %blue%
  ECHO:
  ECHO:  JAVA 18 OR 19 %green% MAY %blue% OR %red% MAY NOT %blue% WORK - DEPENDING ON MODS BEING LOADED OR CHANGES IN THE FABRIC LOADER
  ECHO   IF YOU TRY JAVA NEWER THAN 17 AND CRASHES HAPPEN -- EDIT SETTINGS TO TRY 17
  )
  ECHO:
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO:
  SET /P JAVAVERSION=
)
IF /I !MODLOADER!==FABRIC IF !MCMAJOR! LEQ 16 IF !JAVAVERSION! NEQ 8 GOTO :fabricram
IF /I !MODLOADER!==FABRIC IF !MCMAJOR!==17 IF !JAVAVERSION! NEQ 16 GOTO :fabricram
IF /I !MODLOADER!==FABRIC IF !MCMAJOR! GEQ 18 IF !JAVAVERSION! NEQ 17 IF !JAVAVERSION! NEQ 18 IF !JAVAVERSION! NEQ 19 GOTO :fabricram

IF /I !MAINMENU!==J GOTO :actuallylaunch

:: BEGIN RAM / MEMORY SETTING
:goramentry
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
:: Ram / Memory setting amount entry menu
  CLS
  ECHO:
  ECHO %yellow%    Computer Total Total Memory/RAM     %blue% = %yellow% !TOTALRAM!.!DECIMALTOTAL! Gigabytes (GB) %blue%
  ECHO %yellow%    Current Available (Free) Memory/RAM %blue% = %yellow% !FREERAM!.!DECIMALFREE! Gigabytes (GB) %blue%
  ECHO:
  ECHO: && ECHO:
  ECHO: && ECHO: && ECHO: && ECHO:
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
  SET /P MAXRAMGIGS=
  SET MAXRAM=-Xmx!MAXRAMGIGS!G

  :: END RAM / MEMORY SETTING

:actuallylaunch

:: Checks to see if the Java version entered is available - this shouldn't even be possible using settings normally, but checking anyways
IF !JAVAVERSION! NEQ 8 IF !JAVAVERSION! NEQ 11 IF !JAVAVERSION! NEQ 16 IF !JAVAVERSION! NEQ 17 IF !JAVAVERSION! NEQ 18 IF !JAVAVERSION! NEQ 19 (
  ECHO:
  ECHO   %yellow% THE JAVA VERSION YOU ENTERED IN SETTINGS IS NOT AVAILABLE FOR THIS LAUNCHER %blue%
  ECHO    AVAILABLE VERSIONS ARE = 8, 11, 16, 17, 19
  ECHO:
  PAUSE
  GOTO :gojava
)



IF /I !MAINMENU!==L SET ASKMODSCHECK=N
:: Generates settings-universalator.txt file if settings-universalator.txt does not exist
IF EXIST settings-universalator.txt DEL settings-universalator.txt

    ECHO :: To reset this file - delete and run launcher again.>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Minecraft version below - example: MINECRAFT=1.18.2 >>settings-universalator.txt
    ECHO SET MINECRAFT=!MINECRAFT!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Modloader type - either FORGE or FABRIC>>settings-universalator.txt
    ECHO SET MODLOADER=!MODLOADER!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Forge version below - example: FORGE=40.1.84 >>settings-universalator.txt
    ECHO SET FORGE=!FORGE!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Fabric Installer version>>settings-universalator.txt
    ECHO SET FABRICINSTALLER=!FABRICINSTALLER!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Fabric Loader version>>settings-universalator.txt
    ECHO SET FABRICLOADER=!FABRICLOADER!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Java version below - MUST BE 8, 11, 16, 17, 18, or 19 >>settings-universalator.txt
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
IF /I !MAINMENU!==J GOTO :mainmenu
IF /I !MAINMENU!==R GOTO :mainmenu

SET MAXRAM=-Xmx!MAXRAMGIGS!G

:: Returns to main menu if asking to scan mods is flagged as done previously once before
:: Otherwise if Y goes to the mod scanning section for each modloader
IF /I !MAINMENU!==S IF NOT EXIST "%HERE%\mods" GOTO :mainmenu
IF /I !MAINMENU!==S IF /I !ASKMODSCHECK!==N GOTO :mainmenu
IF /I !MAINMENU!==S IF /I !ASKMODSCHECK!==Y (
  SET ASKMODSCHECK=N
  GOTO :actuallyscanmods
)

::Stores values in variables depending on Java version entered
IF !JAVAVERSION!==8 (
    SET JAVAFILENAME="jdk8u362-b09/OpenJDK8U-jre_x64_windows_hotspot_8u362b09.zip"
    SET JAVAFOLDER="univ-utils\java\jdk8u362-b09-jre\."
    SET checksumeight=3569dcac27e080e93722ace6ed7a1e2f16d44a61c61bae652c4050af58d12d8b
    SET JAVAFILE="univ-utils\java\jdk8u362-b09-jre\bin\java.exe"
)
IF !JAVAVERSION!==11 (
    SET JAVAFILENAME="jdk-11.0.18%%2B10/OpenJDK11U-jre_x64_windows_hotspot_11.0.18_10.zip"
    SET JAVAFOLDER="univ-utils\java\jdk-11.0.18+10-jre\."
    SET checksumeight=dea0fe7fd5fc52cf5e1d3db08846b6a26238cfcc36d5527d1da6e3cb059071b3
    SET JAVAFILE="univ-utils\java\jdk-11.0.18+10-jre\bin\java.exe"
)
IF !JAVAVERSION!==16 (
    SET JAVAFILENAME="jdk-16.0.2%%2B7/OpenJDK16U-jdk_x64_windows_hotspot_16.0.2_7.zip"
    SET JAVAFOLDER="univ-utils\java\jdk-16.0.2+7\."
    SET checksumeight=40191ffbafd8a6f9559352d8de31e8d22a56822fb41bbcf45f34e3fd3afa5f9e
    SET JAVAFILE="univ-utils\java\jdk-16.0.2+7\bin\java.exe"
)
IF !JAVAVERSION!==17 (
    SET JAVAFILENAME="jdk-17.0.6%%2B10/OpenJDK17U-jre_x64_windows_hotspot_17.0.6_10.zip"
    SET JAVAFOLDER="univ-utils\java\jdk-17.0.6+10-jre\."
    SET checksumeight=85ce690a348977e3739fde3fd729b36c61e86c33da6628bc7ceeba9974a3480b
    SET JAVAFILE="univ-utils\java\jdk-17.0.6+10-jre\bin\java.exe"
)
IF !JAVAVERSION!==18 (
    SET JAVAFILENAME="jdk-18.0.2.1%%2B1/OpenJDK18U-jre_x64_windows_hotspot_18.0.2.1_1.zip"
    SET JAVAFOLDER="univ-utils\java\jdk-18.0.2.1+1-jre\."
    SET checksumeight=ba7976e86e9a7e27542c7cf9d5081235e603a9be368b6cbd49673b417da544b1
    SET JAVAFILE="univ-utils\java\jdk-18.0.2.1+1-jre\bin\java.exe"
)
IF !JAVAVERSION!==19 (
    SET JAVAFILENAME="jdk-19.0.2%%2B7/OpenJDK19U-jre_x64_windows_hotspot_19.0.2_7.zip"
    SET JAVAFOLDER="univ-utils\java\jdk-19.0.2+7-jre\."
    SET checksumeight=daaaa092343e885b0814dd85caa74529b9dec2c1f28a711d5dbc066a9f7af265
    SET JAVAFILE="univ-utils\java\jdk-19.0.2+7-jre\bin\java.exe"
)


:: Checks to see if the mods folder even exists yet
SET NEWRESPONSE=Y
IF NOT EXIST "%HERE%\mods" (
  :nommodsfolder
  CLS
  ECHO: && ECHO: && ECHO: && ECHO:
  ECHO   %yellow% NO 'mods' FOLDER OR NO MOD FILES INSIDE AN EXISTING 'mods' FOLDER WERE DETECTED IN THIS DIRECTORY YET %blue%
  ECHO   %yellow% ARE YOU SURE YOU WANT TO CONTINUE? %blue%
  ECHO: && ECHO:
  ECHO    --- IF "Y" PROGRAM WILL INSTALL CORE SERVER FILES AND LAUNCH BUT THERE ARE NO MODS THAT WILL BE LOADED.
  ECHO:
  ECHO    --- IF "N" PROGRAM WILL RETURN TO MAIN MENU
  ECHO:
  ECHO:
  ECHO   %yellow% TYPE YOUR RESPONSE AND PRESS ENTER: %blue%
  ECHO:
  set /P "NEWRESPONSE=" 
  IF /I !NEWRESPONSE! NEQ N IF /I !NEWRESPONSE! NEQ Y GOTO :nomodsfolder
  IF /I !NEWRESPONSE!==N (
    GOTO :mainmenu
  )
)

:: Downloads java binary file
:javaretry
IF NOT EXIST java.zip IF NOT EXIST %JAVAFOLDER% (
  ECHO:
  ECHO: Java installation not detected - Downloading Java files!...
  ECHO:
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/adoptium/temurin!JAVAVERSION!-binaries/releases/download/%JAVAFILENAME%', 'java.zip')" >nul

)

:: Gets the checksum hash of the downloaded java binary file
set idx=0 
IF EXIST java.zip (
  for /f %%F  in ('certutil -hashfile java.zip SHA256') do (
      set "out!idx!=%%F"
      set /a idx += 1
  )

  IF NOT EXIST java.zip IF NOT EXIST %JAVAFOLDER% (
    ECHO:
    ECHO   !yellow! Something went wrong downloading the Java files. !blue!
    ECHO    Press any key to try again.
    PAUSE
    GOTO :javaretry
  )

)
IF EXIST java.zip (
set filechecksum=%out1%
) ELSE (
    set filechecksum=0a
  )
:: Checks to see if the calculated checksum hash is the same as stored value above - unzips file if valid
IF EXIST java.zip (
    IF /i %checksumeight%==%filechecksum% (
    "%HERE%\univ-utils\7-zip\7za.exe" x java.zip -ouniv-utils\java
    ) && DEL java.zip && ECHO Downloaded Java binary and stored hashfile match values - file is valid
)
IF EXIST java.zip IF %checksumeight% NEQ %filechecksum% (
  ECHO:
  ECHO %yellow% THE JAVA INSTALLATION FILE DID NOT DOWNLOAD CORRECTLY - PLEASE TRY AGAIN %blue%
  DEL java.zip && PAUSE && EXIT [\B]
)
:: Sends console message if Java found
IF EXIST %JAVAFOLDER% (
  ECHO:
  ECHO    Java !JAVAVERSION! installation found! ...
  ECHO:
) ELSE (
  ECHO UH-OH - JAVA folder not detected.
  ECHO Perhaps try resetting all files, delete settings-universalator.txt and starting over.
  PAUSE && EXIT [\B]
)

FOR /F "tokens=2,3 delims=." %%E IN ("!MINECRAFT!") DO (
    SET /a MCMAJOR=%%E
    SET /a MCMINOR=%%F
)

:: BEGIN SPLIT BETWEEN FABRIC AND FORGE SETUP AND LAUNCH - If MODLOADER is FABRIC skips the Forge installation and launch section
IF /I !MODLOADER!==FABRIC GOTO :launchfabric
:: BEGIN FORGE SPECIFIC SETUP AND LAUNCH
:detectforge

IF EXIST libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/. (
  ECHO Detected Installed Forge !FORGE!. Moving on...
  GOTO :foundforge
)

IF EXIST forge-!MINECRAFT!-!FORGE!.jar (
  ECHO Detected Installed Forge !FORGE!. Moving on...
  GOTO :foundforge
)

IF EXIST minecraftforge-universal-!MINECRAFT!-!FORGE!.jar (
  ECHO Detected Installed Forge !FORGE!. Moving on...
  GOTO :foundforge
)

IF EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  ECHO Detected Installed Forge !FORGE!. Moving on...
  GOTO :foundforge
)

IF EXIST forge-!MINECRAFT!-!FORGE!-universal.jar (
  ECHO Detected Installed Forge !FORGE!. Moving on...
  GOTO :foundforge
)

:: Downloads the Minecraft server JAR if version is = OLD and does not exist.  Some old Forge installer files point to dead URL links for this file.  This gets ahead of that and gets it first.
IF !MCMAJOR! LEQ 16 IF NOT EXIST minecraft_server.!MINECRAFT!.jar (
  powershell -Command "(New-Object Net.WebClient).DownloadFile(((Invoke-RestMethod -Method Get -Uri ((Invoke-RestMethod -Method Get -Uri "https://launchermeta.mojang.com/mc/game/version_manifest_v2.json").versions | Where-Object -Property id -Value !MINECRAFT! -EQ).url).downloads.server.url), 'minecraft_server.!MINECRAFT!.jar')"
)

:pingforgeagain
:: Pings the Forge files server to see it can be reached - decides to ping if forge file not present - accounts for extremely annoyng changes in filenames depending on OLD version names.
ECHO Pinging Forge file server...
ECHO:
ping -n 4 maven.minecraftforge.net >nul
IF %ERRORLEVEL% NEQ 0 (
  CLS
  ECHO:
  ECHO A PING TO THE FORGE FILE SERVER HAS FAILED
  ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
  ECHO PRESS ANY KEY TO TRY TO PING FILESERVER AGAIN
  PAUSE
  GOTO :pingforgeagain
)

:: Forge installer file download
:: Detects if installed files or folders exist - if not then deletes existing JAR files and libraries folder to prevent mash-up of various versions installing on top of each other, and then downloads installer JAR
IF !MCMAJOR! GEQ 17 GOTO :skipolddownload

:: 1.6.4
IF !MINECRAFT!==1.6.4 IF NOT EXIST minecraftforge-universal-1.6.4-!FORGE!.jar (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO: && ECHO   Forge !FORGE! Server JAR-file not found.
  ECHO   Any existing JAR files and 'libaries' folder deleted.
  ECHO   Downloading installer... && ECHO:
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')" >nul 2>&1
)

:: 1.7.10
IF !MINECRAFT!==1.7.10 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO: && ECHO   Forge !FORGE! Server JAR-file not found.
  ECHO   Any existing JAR files and 'libaries' folder deleted.
  ECHO   Downloading installer... && ECHO:

  curl -sLfo forge-installer.jar https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!-!MINECRAFT!/forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-installer.jar >nul 2>&1
  IF NOT EXIST forge-installer.jar (
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!-!MINECRAFT!/forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-installer.jar', 'forge-installer.jar')" >nul 2>&1
  )
)

:: 1.8.9
IF !MINECRAFT!==1.8.9 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO: && ECHO   Forge !FORGE! Server JAR-file not found.
  ECHO   Any existing JAR files and 'libaries' folder deleted.
  ECHO   Downloading installer... && ECHO:
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!-!MINECRAFT!/forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-installer.jar', 'forge-installer.jar')" >nul 2>&1
)

:: 1.9.4
IF !MINECRAFT!==1.9.4 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO: && ECHO   Forge !FORGE! Server JAR-file not found.
  ECHO   Any existing JAR files and 'libaries' folder deleted.
  ECHO   Downloading installer... && ECHO:
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!-!MINECRAFT!/forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-installer.jar', 'forge-installer.jar')" >nul 2>&1
)

:: 1.10.2
IF !MINECRAFT!==1.10.2 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-universal.jar (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO: && ECHO   Forge !FORGE! Server JAR-file not found.
  ECHO   Any existing JAR files and 'libaries' folder deleted.
  ECHO   Downloading installer... && ECHO:
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')" >nul 2>&1
)

:: Versions of MC newer than 1.10.2 but older than 17
IF !MCMAJOR! GEQ 11 IF !MCMAJOR! LEQ 16 IF NOT EXIST forge-!MINECRAFT!-!FORGE!.jar (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO: && ECHO   Forge !FORGE! Server JAR-file not found.
  ECHO   Any existing JAR files and 'libaries' folder deleted.
  ECHO   Downloading installer... && ECHO:

  curl -sLfo forge-installer.jar https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar >nul 2>&1
  IF NOT EXIST forge-installer.jar (
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')" >nul 2>&1
  )
)

:skipolddownload
:: For NEW (1.17 and newer) Forge detect if specific version folder is present - if not delete all JAR files and 'install' folder to guarantee no files of different versions conflicting on later install.  Then downloads installer file.
IF !MCMAJOR! GEQ 17 IF NOT EXIST libraries\net\minecraftforge\forge\!MINECRAFT!-!FORGE!\. (
  DEL *.jar >nul 2>&1
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  ECHO: && ECHO   Forge !FORGE! Server JAR-file not found.
  ECHO   Any existing JAR files and 'libaries' folder deleted.
  ECHO   Downloading installer... && ECHO:

  curl -sLfo forge-installer.jar https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar >nul 2>&1
  IF NOT EXIST forge-installer.jar (
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')" >nul 2>&1
  )
)

IF EXIST "%HERE%\forge-installer.jar" GOTO :useforgeinstaller
CLS
ECHO  !MCMAJOR!
ECHO forge-installer.jar not found. Maybe the Forge servers are having trouble.
ECHO Please try again in a couple of minutes.
ECHO:
ECHO %yellow% THIS COULD ALSO MEAN YOU HAVE INCORRECT MINECRAFT OR FORGE VERSION NUMBERS ENTERED - CHECK THE VALUES ENTERED %blue%
ECHO         MINECRAFT - !MINECRAFT!
ECHO         FORGE ----- !FORGE!
ECHO:
ECHO Press any key to try to download forge installer file again.
PAUSE
GOTO :pingforgeagain

:: Installs forge, detects if successfully made the main JAR file, deletes extra new style files that this BAT replaces
:useforgeinstaller
IF EXIST forge-installer.jar (
  ECHO: && ECHO Installer downloaded. Installing...
  !JAVAFILE! -Djava.net.preferIPv4Stack=true -XX:+UseG1GC -jar forge-installer.jar --installServer
  DEL forge-installer.jar >nul 2>&1
  DEL forge-installer.jar.log >nul 2>&1
  ECHO: && ECHO Installation complete. forge-installer.jar deleted. && ECHO:
  GOTO :detectforge
)

ECHO THE FORGE INSTALLATION FILE DID NOT DOWNLOAD OR INSTALL CORRECTLY - IT WAS NOT FOUND
ECHO - PLEASE RESET FILES AND TRY AGAIN -
PAUSE && EXIT [\B]

:foundforge

:: Forge was found to exist at this point - delete the files which Forge installs that this script replaces the functions of.
IF !MCMAJOR! GEQ 17 (
  DEL "%HERE%\run.*" >nul 2>&1
  IF EXIST "%HERE%\user_jvm_args.txt" DEL "%HERE%\user_jvm_args.txt"
)

:eula
::If eula.txt doens't exist yet 
SET RESPONSE=IDKYET
IF NOT EXIST eula.txt (
  CLS
  ECHO:
  ECHO:
  ECHO   Mojang's EULA has not yet been accepted. In order to run a Minecraft server, you must accept Mojang's EULA.
  ECHO   Mojang's EULA is available to read at https://account.mojang.com/documents/minecraft_eula
  ECHO:
  ECHO     %yellow% If you agree to Mojang's EULA then type 'AGREE' %blue%
  ECHO:
  ECHO     %yellow% ENTER YOUR RESPONSE %blue%
  ECHO:
  SET /P RESPONSE=
)
IF /I !RESPONSE!==AGREE (
  ECHO:
  ECHO User agreed to Mojang's EULA.
  ECHO:
  ECHO eula=true> eula.txt
)
IF /I !RESPONSE! NEQ AGREE IF NOT EXIST eula.txt (
  GOTO :eula
)
IF EXIST eula.txt (
  ECHO:
  ECHO eula.txt file found! ..
  ECHO:
)

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
IF /I !MAINMENU!==L IF /I !MODLOADER!==FORGE GOTO :launchforge
IF /I !MAINMENU!==L IF /I !MODLOADER!==FABRIC GOTO :fabricmain

:: MODULE TO CHECK FOR CLIENT SIDE MODS
:actuallyscanmods
SET ASKMODSCHECK=N
IF NOT EXIST "%HERE%\mods" GOTO :mainmenu
  CLS
  ECHO:
  ECHO:
  ECHO   %yellow% CLIENT MOD SCANNING - CLIENT MOD SCANNING %blue% && ECHO:
  ECHO      %green% WOULD YOU LIKE TO SCAN THE MODS FOLDER FOR MODS THAT ARE NEEDED ONLY ON CLIENTS? %blue%
  ECHO      %green% FOUND CLIENT MODS CAN BE AUTOMATICALLY MOVED TO A DIFFERENT FOLDER FOR STORAGE. %blue%
  ECHO:
  ECHO       --MANY CLIENT MODS ARE NOT CODED TO SELF DISABLE ON SERVERS AND MAY CRASH THEM
  ECHO: && ECHO: && ECHO:
  ECHO       --THE UNIVERSALATOR SCRIPT CAN SCAN THE MODS FOLDER AND SEE IF ANY ARE PRESENT && ECHO:
  ECHO         For an explanation of how the script scans files - visit the official wiki at:
  ECHO         https://github.com/nanonestor/universalator/wiki
  ECHO:
  ECHO:
  ECHO   %yellow% CLIENT MOD SCANNING - CLIENT MOD SCANNING %blue% && ECHO:
  ECHO:
  ECHO:
  ECHO             %yellow% Please choose 'Y' or 'N' %blue%
  ECHO:
  SET /P DOSCAN=

  IF /I !DOSCAN! NEQ N IF /I !DOSCAN! NEQ Y GOTO :actuallyscanmods
  IF /I !DOSCAN!==N GOTO :mainmenu

  ECHO Searching for client only mods . . .
  :: Goes to mods folder and gets file names lists.  FINDSTR prints only files with .jar found
  
:: Creates list of all mod file names.  Sends the working dir to the mods folder and uses a loop and the 'dir' command to create an array list of file names.
:: A For loop is used with delayedexpansion turned off with a funciton called to record each filename because this allows capturing
:: filenames with exclamation marks in the name.  eol=| ensures that filenames with some weird characters aren't ignored.
SET SERVERMODSCOUNT=0
PUSHD mods
setlocal enableextensions
setlocal disabledelayedexpansion
 FOR /F "eol=| delims=" %%J IN ('"dir *.jar /b /a-d"') DO (
  SET "FILENAME=%%J"
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
    PAUSE && EXIT [\B]
  )



:: If MC version is old (MC <1.12.2) then skips ahead to old mod info file.
IF !MCMAJOR! LEQ 12 GOTO :scanmcmodinfo

:: BEGIN SCANNING NEW STYLE (MC >1.12.2) mods.toml FILES IN MODS

:: For each found jar file - uses 7zip to output using STDOUT the contents of the mods.toml.  For each line in the STDOUT output the line is checked.
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
   FOR /F "delims=" %%X IN ('univ-utils\7-zip\7za.exe e -so "mods\!SERVERMODS[%%T].file!" "META-INF\mods.toml"') DO (
      SET "TEMP=%%X"
      IF !FOUNDMODPLACE!==Y (
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
:: For each found jar file - uses 7zip to output using STDOUT the contents of the mods.toml.  For each line in the STDOUT output the line is checked.
:: First a trigger is needed to determine if the [mods] section has been detected yet in the JSON.  Once that trigger variable has been set to Y then 
:: the script scans to find the modID line.  A fancy function replaces the = sign with _ for easier string comparison to determine if the modID= line was found.
:: This should ensure that no false positives are recorded.
SET "TABCHAR=	"
FOR /L %%t IN (0,1,!SERVERMODSCOUNT!) DO (
  SET COUNT=%%t
  SET /a COUNT+=1
  ECHO SCANNING !COUNT!/!ACTUALMODSCOUNT! - !SERVERMODS[%%t].file!
  FOR /F "delims=" %%X IN ('univ-utils\7-zip\7za.exe e -so "%HERE%\mods\!SERVERMODS[%%t].file!" "mcmod.info"') DO (
    :: Sets ID to undefined if it was previously defined
    SET "ID="
    :: Sets a temp variable equal to the current line for processing, and replaces " with ; for easier loop delimiting later.
    SET "TEMP=%%X"
    SET "TEMP=!TEMP:"=;!"
    :: If the line contains the modid then further process line and then set ID equal to the actual modid entry.
    IF "!TEMP!" NEQ "!TEMP:;modid;=x!" (
      SET "TEMP=!TEMP:%TABCHAR%=!"
      SET "TEMP=!TEMP: =!"
      SET "TEMP=!TEMP::=!"
      FOR /F "tokens=2 delims=;" %%Y IN ("!TEMP!") DO (
        SET SERVERMODS[%%t].id=%%Y
        REM ECHO %%Y
      )
    )
  )
  :: If ID was found record it to the array entry of the current mod number, otherwise set the ID of that mod equal to a dummy string x.
  IF NOT DEFINED SERVERMODS[%%t].id SET SERVERMODS[%%t].id=x
)
:: END SCANNING OLD STYLE MCMOD.INFO
:finishedscan

IF EXIST allmodidsandfiles.txt DEL allmodidsandfiles.txt >nul 2>&1

:: Enters all modIds and corresponding file names to a single txt file for FINDSTR comparison with client mod list.
FOR /L %%b IN (0,1,!SERVERMODSCOUNT!) DO (
  ECHO !SERVERMODS[%%b].id!;!SERVERMODS[%%b].file! >>univ-utils\allmodidsandfiles.txt
)
:: FINDSTR compares each line of the client only mods list to the list containing all found modIds and returns only lines with matches.
FINDSTR /b /g:univ-utils\clientonlymods.txt univ-utils\allmodidsandfiles.txt>univ-utils\foundclients.txt


:: If foundclients.txt isn't found then assume none were found and GOTO section stating none found.
IF NOT EXIST univ-utils\foundclients.txt (
  DEL univ-utils\allmodidsandfiles.txt >nul
  GOTO :noclients
)

:: Loops/Reads through the foundclients.txt and enters values into an array.
SET /a NUMCLIENTS=0
FOR /F "tokens=1,2 delims=;" %%b IN (univ-utils\foundclients.txt) DO (
   SET FOUNDCLIENTS[!NUMCLIENTS!].id=%%b
   SET FOUNDCLIENTS[!NUMCLIENTS!].file=%%c
   SET /a NUMCLIENTS+=1
)

  :: Prints report to user - showing client mod file names and corresponding modid's.
  CLS
  ECHO:
  ECHO:
  ECHO   %yellow% THE FOLLOWING CLIENT ONLY MODS WERE FOUND %blue%
  ECHO:
  IF !HOWOLD!==SUPEROLD (
  ECHO    *NOTE - IT IS DETECTED THAT YOUR MINECRAFT VERSION STORES ITS ID NUMBER IN THE OLD WAY*
  ECHO     SOME CLIENT ONLY MODS MAY NOT BE DETECTED BY THE SCAN - I.E. MODS THAT DO NOT USE A MCMOD.INFO FILE
  )
  ECHO:
  ECHO    ------------------------------------------------------
  :: Prints to the screen all of the values in the array that are not equal to forge or null
FOR /L %%c IN (0,1,%NUMCLIENTS%) DO (
  IF "!FOUNDCLIENTS[%%c].file!" NEQ "" (
    ECHO        !FOUNDCLIENTS[%%c].file! - !FOUNDCLIENTS[%%c].id!
) )
  ECHO    ------------------------------------------------------
  ECHO:
  ECHO:
  ECHO:
  ECHO:
  ECHO   %green% *** DO YOU WANT TO MOVE THESE CLIENT MODS TO A DIFFERENT FOLDER FOR SAFE KEEPING? *** %blue%
  ECHO:
  ECHO         If 'Y' they will NOT be deleted - they WILL be moved to a new folder in the server named %green% CLIENTMODS %blue%
  ECHO         SOME CLIENT MODS ARE NOT CODED TO SELF DISABLE AND WILL CRASH SERVERS IF LEFT IN THE MODS FOLDER
  ECHO:
  ECHO:
  ECHO      - IF YOU THINK THE CURRENT MASTER LIST IS INNACURATE OR HAVE FOUND A MOD TO ADD -
  ECHO         PLEASE CONTACT THE LAUNCHER AUTHOR OR
  ECHO         FILE AN ISSUE AT https://github.com/nanonestor/universalator/issues !
  ECHO:
  :typo
  ECHO    ------------------------------------------------------
  ECHO:
  ECHO       %yellow% ENTER YOUR RESPONSE - 'Y' OR 'N' %blue%
  ECHO:
  SET /P MOVEMODS=
  IF /I !MOVEMODS!==N (
    DEL univ-utils\foundclients.txt >nul
    DEL univ-utils\allmodidsandfiles.txt >nul
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
  FOR /L %%L IN (0,1,%NUMCLIENTS%) DO (
    IF DEFINED FOUNDCLIENTS[%%L].file (
      MOVE "%HERE%\mods\!FOUNDCLIENTS[%%L].file!" "%HERE%\CLIENTMODS\!FOUNDCLIENTS[%%L].file!" >nul
      ECHO   MOVED - !FOUNDCLIENTS[%%L].file!
  ) ) 
  
  ECHO:
  ECHO      %yellow%   CLIENT MODS MOVED TO THIS FOLDER AS STORAGE:     %blue%
  ECHO      %yellow%   "%HERE%\CLIENTMODS"
  ECHO:
  ECHO:
  ECHO      %yellow% -PRESS ANY KEY TO CONTINUE- %blue%
  ECHO:
  DEL univ-utils\foundclients.txt >nul
  DEL univ-utils\allmodidsandfiles.txt >nul
  PAUSE
  
GOTO :mainmenu

:noclients
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

:: FINALLY LAUNCH FORGE SERVER!
:launchforge

CLS
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO            %yellow%   Universalator - Server launcher script    %blue%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO   %yellow% READY TO LAUNCH FORGE SERVER! %blue%
ECHO:
ECHO        CURRENT SERVER SETTINGS:
ECHO        MINECRAFT - !MINECRAFT!
ECHO        FORGE - !FORGE!
IF !OVERRIDE!==N ECHO        JAVA - !JAVAVERSION!
IF !OVERRIDE!==Y ECHO        JAVA - CUSTOM OVERRIDE
ECHO ============================================
ECHO   %yellow% CURRENT NETWORK SETTINGS:%blue%
IF NOT EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" ECHO:
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" IF DEFINED UPNPSTATUS IF /I !UPNPSTATUS!==ON ECHO       %yellow% UPNP STATUS %blue% - %green% ENABLED %blue%
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" IF DEFINED UPNPSTATUS IF /I !UPNPSTATUS!==OFF ECHO       %yellow% UPNP STATUS %blue% ------------------ %red% NOT ACTIVE %blue%
ECHO:
ECHO        PUBLIC IPv4 AND PORT ADDRESS - %green% %PUBLICIP%:%PORT% %blue%
ECHO            --%green% CLIENTS OUTSIDE %blue% THE CURRENT ROUTER NETWORK USE THIS ADDRESS TO CONNECT
IF NOT DEFINED UPNPSTATUS ECHO            --PORT FORWARDING MUST BE SET UP IN YOUR NETWORK ROUTER %yellow% OR %blue% HAVE UPNP FORWARDING ENABLED
IF DEFINED UPNPSTATUS IF /I !UPNPSTATUS!==OFF ECHO            --PORT FORWARDING MUST BE SET UP IN YOUR NETWORK ROUTER %yellow% OR %blue% HAVE UPNP FORWARDING ENABLED
IF DEFINED UPNPSTATUS IF /I !UPNPSTATUS!==ON ECHO:
ECHO:
IF DEFINED LOCALIP ECHO        INTERNAL IPv4 AND PORT ADDRESS - %green% !LOCALIP!:%PORT% %blue%
IF NOT DEFINED LOCALIP (
ECHO        LOCAL IPv4 AND PORT ADDRESS 
ECHO            --ENTER 'ipconfig' FROM A COMMAND PROMPT TO FIND
)
ECHO            --%green% CLIENTS INSIDE %blue% THE CURRENT ROUTER NETWORK USE THIS ADDRESS TO CONNECT
ECHO:
ECHO        SAME COMPUTER
ECHO            --THE WORD '%green%localhost%blue%' WORKS FOR CLIENTS ON SAME COMPUTER INSTEAD OF ENTERING AN IP ADDRESS && ECHO:
ECHO ============================================
ECHO   %yellow% READY TO LAUNCH FORGE SERVER! %blue%
ECHO:
ECHO            %yellow% ENTER 'M' FOR MAIN MENU %blue%
ECHO            %yellow% ENTER ANY OTHER KEY TO START SERVER LAUNCH %blue%
ECHO:
SET /P "FORGELAUNCH="
IF /I !FORGELAUNCH!==M GOTO :mainmenu


ECHO: && ECHO   Launching... && ping -n 2 127.0.0.1 > nul && ECHO   Launching.. && ping -n 2 127.0.0.1 > nul && ECHO   Launching. && ECHO:
:: Starts forge depending on what java version is set.  Only correct combinations will launch - others will crash.

IF !OVERRIDE!==Y SET "JAVAFILE=java"
TITLE Universalator - !MINECRAFT! Forge
ver >nul

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

:: General case for NEW (1.17 and newer) Minecraft versions.  This remains unchanged at least until 1.19.3.
IF !MCMAJOR! GEQ 17 (
%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% @libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/win_args.txt nogui %*
)

:: Complaints to report in console output if launch attempt crashes

:: Looks for the stopping the server text to decide if the server was shut down on purpose.  If so goes to main menu.
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"Stopping the server" >nul 2>&1 && PAUSE && GOTO :mainmenu

TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"Unsupported class file major version" >nul 2>&1
IF !ERRORLEVEL!==0 (
  ECHO: && ECHO        %red% --SPECIAL NOTE-- %blue%
  ECHO    %yellow% FROM SCANNING THE LOGS IT LOOKS LIKE YOUR SERVER MAY HAVE CRASHED FOR ONE OF TWO REASONS:  %blue%
  ECHO    %yellow% --YOUR SELECTED JAVA VERSION IS CRASHING WITH THE CURRENT FORGE AND MODS VERSIONS %blue%
  ECHO    %yellow% --AT LEAST ONE MOD FILE IN THE MODS FOLDER IS FOR A DIFFERENT VERSION OF FORGE / MINECRAFT %blue% && ECHO:
  ECHO        %red% --SPECIAL NOTE-- %blue% && ECHO:
)

  :: Search if the standard client side mod message was found.  Ignore if java 19 is detected as probably the more important item.
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"invalid dist DEDICATED_SERVER" >nul 2>&1
IF !ERRORLEVEL!==0 (
  ECHO: && ECHO        %red% --- SPECIAL MESSAGE --- %blue%
  ECHO    THE TEXT 'invalid dist DEDICATED_SERVER' WAS FOUND IN THE LOG FILE
  ECHO    THIS COULD MEAN YOU HAVE CLIENT MODS CRASHING THE SERVER - OTHERWISE SOME MOD AUTHORS DID NOT SILENCE THAT MESSAGE.
  ECHO:
  ECHO    TRY USING THE UNIVERSALATOR %green% 'SCAN' %blue% OPTION TO FIND CLIENT MODS.
  ECHO        %red% --- SPECIAL MESSAGE --- %blue% && ECHO:
)

PAUSE
GOTO :mainmenu
:: END FORGE MAIN SECTION

:launchfabric
:: BEGIN FABRIC MAIN SECTION

:: Skips installation if already present
IF EXIST fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar GOTO :launchfabric

:: Deletes existing core files and folders if this specific desired Fabric launch file not present.  This forces a fresh installation and prevents getting a mis-match of various minecraft and/or fabric version files conflicting.
IF NOT EXIST fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar (
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  DEL *.jar >nul 2>&1
)

:: Pings the Fabric file server
:fabricserverpingagain
 ping -n 3 maven.fabricmc.net >nul
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
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.fabricmc.net/net/fabricmc/fabric-installer/!FABRICINSTALLER!/fabric-installer-!FABRICINSTALLER!.jar', 'fabric-installer.jar')" >nul
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.fabricmc.net/net/fabricmc/fabric-installer/!FABRICINSTALLER!/fabric-installer-!FABRICINSTALLER!.jar.sha256', 'fabric-installer.jar.sha256')" >nul


:: Sends script execution back if no installer file found.
  IF NOT EXIST "fabric-installer.jar" (
    ECHO:
    ECHO    Something went wrong downloading the Fabric Installer file.
    ECHO    Press any key to try again.
    PAUSE
    GOTO :launchfabric
  )

:: Sets variable equal to the value in the sha256 file.
IF EXIST fabric-installer.jar.sha256 (
  SET /P INSTALLERVAL=<fabric-installer.jar.sha256
)
set idf=0 
IF EXIST "fabric-installer.jar" (
  for /f %%F  in ('certutil -hashfile "fabric-installer.jar" SHA256') do (
      set "Fout!idf!=%%F"
      set /a idf += 1
  )
)
IF EXIST fabric-installer.jar (
set fabricinstallerhecksum=%Fout1%
) ELSE (
    set fabricinstallerhecksum=0a
  )

:: Checks to see if the calculated checksum hash is the same as the value from the downloaded SHA256 file value
:: IF yes then install fabric server files
IF EXIST fabric-installer.jar (
    IF /I %INSTALLERVAL%==%fabricinstallerhecksum% (
      %JAVAFILE% -XX:+UseG1GC -jar fabric-installer.jar server -loader !FABRICLOADER! -mcversion !MINECRAFT! -downloadMinecraft
    ) ELSE (
      DEL fabric-installer.jar
      ECHO:
      ECHO   FABRIC INSTALLER FILE CHECKSUM VALUE DID NOT MATCH THE CHECKSUM IT WAS SUPPOSED TO BE
      ECHO   THIS LIKELY MEANS A CORRUPTED DOWNLOAD.
      ECHO:
      ECHO   PRESS ANY KEY TO TRY DOWNLOADING AGAIN!
      PAUSE
      GOTO :launchfabric
    )
)
IF EXIST fabric-installer.jar DEL fabric-installer.jar
IF EXIST fabric-installer.jar.sha256 DEL fabric-installer.jar.sha256
IF EXIST fabric-server-launch.jar (
  RENAME fabric-server-launch.jar fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar
)

::If eula.txt doens't exist yet 

:fabriceula
SET RESPONSE=IDKYET
IF NOT EXIST eula.txt (
  CLS
  ECHO:
  ECHO   Mojang's EULA has not yet been accepted. In order to run a Minecraft server, you must accept Mojang's EULA.
  ECHO   Mojang's EULA is available to read at https://account.mojang.com/documents/minecraft_eula
  ECHO:
  ECHO     %yellow% If you agree to Mojang's EULA then type 'AGREE' %blue%
  ECHO:
  ECHO     %yellow% ENTER YOUR RESPONSE %blue%
  ECHO:
  SET /P "RESPONSE="
)
IF /I !RESPONSE!==AGREE (
  ECHO:
  ECHO User agreed to Mojang's EULA.
  ECHO:
  ECHO eula=true> eula.txt
)
IF /I !RESPONSE! NEQ AGREE IF !RESPONSE! NEQ IDKYET GOTO :fabriceula

IF EXIST eula.txt (
  ECHO:
  ECHO eula.txt file found! ..
  ECHO:
)
GOTO :launchfabric

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

  REM Uses STDOUT from 7zip to loop through each line in the fabric.mod.json file of each mod file.

  FOR /F "delims=" %%I IN ('univ-utils\7-zip\7za.exe e -so "%HERE%\mods\!SERVERMODS[%%f].file!" "fabric.mod.json"') DO (
    
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
        SET SERVERMODS[%%f].id=%%Q
      )
    )
    REM Detects with the string replacement method if the enviroment value is present, and then if found whether the client entry is present.  Otherwise if environment is found but client not - mark mod as not client.
    IF "!TEMP!" NEQ "!TEMP:;environment;=x!" (
      IF "!TEMP!" NEQ "!TEMP:;client;=x!" (
        SET SERVERMODS[%%f].environ=C
        SET FOUNDFABRICCLIENTS=Y
      ) ELSE ( 
        SET SERVERMODS[%%f].environ=N
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
  ) 
)
REM Goes to the no clients found message.  If any environment client mods were found this trigger variable will be Y instead.
IF !FOUNDFABRICCLIENTS!==N GOTO :noclientsfabric

:: Loops through each mod file/id array value to make a final array for mods with the clients environment which also don't have any matches for their mod id in the dependencies.
SET /a CLIENTSCOUNT=0
FOR /L %%r IN (0,1,!SERVERMODSCOUNT!) DO (
  IF !SERVERMODS[%%r].environ!==C (
    FINDSTR "!SERVERMODS[%%r].id!" univ-utils\allfabricdeps.txt >nul
    IF !ERRORLEVEL! NEQ 0 (
      SET FABRICCLIENTS[!CLIENTSCOUNT!].file=!SERVERMODS[%%r].file!
      SET FABRICCLIENTS[!CLIENTSCOUNT!].id=!SERVERMODS[%%r].id!
      SET /a CLIENTSCOUNT+=1
    )
  )
)
IF EXIST univ-utils\allfabricdeps.txt DEL univ-utils\allfabricdeps.txt >nul


  :: Prints report to user - echos all entries without the modID name = forge
  CLS
  ECHO:
  ECHO:
  ECHO   %yellow% THE FOLLOWING FABRIC - CLIENT MARKED MODS WERE FOUND %blue%
  ECHO:
  ECHO    ------------------------------------------------------
  REM Prints to the screen all of the values in the array that are not equal to forge or null
  FOR /L %%T IN (0,1,!CLIENTSCOUNT!) DO (
    IF /I "!FABRICCLIENTS[%%T].file!" NEQ "" (
      ECHO        !FABRICCLIENTS[%%T].file! - !FABRICCLIENTS[%%T].id!
    )
  )
  ECHO    ------------------------------------------------------
  ECHO:
  ECHO:
  ECHO   %green% *** DO YOU WANT TO MOVE THESE CLIENT MODS TO A DIFFERENT FOLDER FOR SAFE KEEPING? *** %blue%
  ECHO:
  ECHO         If 'Y' they will NOT be deleted - they WILL be moved to a new folder in the server named %green% CLIENTMODS %blue%
  ECHO         SOME CLIENT MODS ARE NOT CODED TO SELF DISABLE AND WILL CRASH SERVERS IF LEFT IN THE MODS FOLDER
  ECHO:
  :typo
  ECHO:
  ECHO    ------------------------------------------------------
  ECHO:
  ECHO       %yellow% ENTER YOUR RESPONSE - 'Y' OR 'N' %blue%
  ECHO:
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

::END FABRIC CLIENT ONLY MODS SCANNING


:: FINALLY LAUNCH FABRIC SERVER!
:launchfabric
CLS
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO            %yellow%   Universalator - Server launcher script    %blue%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO:
ECHO   %yellow% READY TO LAUNCH FABRIC SERVER! %blue%
ECHO:
ECHO      CURRENT SERVER SETTINGS:
ECHO        MINECRAFT ----- !MINECRAFT!
ECHO        FABRIC LOADER - !FABRICLOADER!
IF !OVERRIDE!==N ECHO        JAVA - !JAVAVERSION!
IF !OVERRIDE!==Y ECHO        JAVA - CUSTOM OVERRIDE
ECHO:
ECHO:
ECHO ============================================
ECHO   %yellow% CURRENT NETWORK SETTINGS:%blue%
ECHO:
ECHO    PUBLIC IPv4 AND PORT ADDRESS  - %green% %PUBLICIP%:%PORT% %blue%
ECHO        --THIS IS WHAT CLIENTS OUTSIDE THE CURRENT ROUTER NETWORK USE TO CONNECT
IF NOT DEFINED UPNPSTATUS ECHO        --PORT FORWARDING MUST BE SET UP IN YOUR NETWORK ROUTER OR HAVE UPNP FORWARDING ENABLED
IF DEFINED UPNPSTATUS IF /I !UPNPSTATUS!==OFF ECHO        --PORT FORWARDING MUST BE SET UP IN YOUR NETWORK ROUTER %yellow% OR %blue% HAVE UPNP FORWARDING ENABLED
ECHO:
IF DEFINED LOCALIP ECHO    INTERNAL IPv4 ADDRESS  - %green% !LOCALIP!:%PORT% %blue%
IF NOT DEFINED LOCALIP (
ECHO    INTERNAL IPv4 ADDRESS  - ENTER 'ipconfig' FROM A COMMAND PROMPT
)
ECHO        --THIS IS WHAT CLIENTS INSIDE THE CURRENT ROUTER NETWORK USE TO CONNECT
ECHO:
ECHO    THE WORD '%green%localhost%blue%' INSTEAD OF AN IP ADDRESS WORKS FOR CLIENTS ON SAME COMPUTER
ECHO:
ECHO ============================================
ECHO   %yellow% READY TO LAUNCH FABRIC SERVER! %blue%
ECHO:
ECHO            ENTER %green% 'M' %blue% FOR MAIN MENU
ECHO            ENTER %green% ANY OTHER %blue% KEY TO START SERVER LAUNCH 
ECHO:
SET /P "FABRICLAUNCH="
IF /I !FABRICLAUNCH!==M GOTO :mainmenu


ECHO: && ECHO   Launching... && ping -n 2 127.0.0.1 > nul && ECHO   Launching.. && ping -n 2 127.0.0.1 > nul && ECHO   Launching. && ECHO:

IF !OVERRIDE!==Y SET "JAVAFILE=java"
TITLE Universalator - !MINECRAFT! Fabric

%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% -jar fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar nogui

:: Complains in console output if launch attempt crashes
:: Looks for the stopping the server text to decide if the server was shut down on purpose.  If so goes to main menu.
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"Stopping the server" >nul 2>&1 && PAUSE && GOTO :mainmenu

:: Search if java version mismatch is found
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"Unsupported class file major version" >nul 2>&1
IF !ERRORLEVEL!==0 (
  ECHO: && ECHO        %red% --SPECIAL NOTE-- %blue%
  ECHO    %yellow% FROM SCANNING THE LOGS IT LOOKS LIKE YOUR SERVER MAY HAVE CRASHED FOR ONE OF TWO REASONS:  %blue%
  ECHO    %yellow% --YOUR SELECTED JAVA VERSION IS CRASHING WITH THE CURRENT FORGE AND MODS VERSIONS %blue%
  ECHO    %yellow% --AT LEAST ONE MOD FILE IN THE MODS FOLDER IS FOR A DIFFERENT VERSION OF FORGE / MINECRAFT %blue% && ECHO:
  ECHO        %red% --SPECIAL NOTE-- %blue% && ECHO:
)

:: Search if the standard client side mod message was found.  Ignore if java 19 is detected as probably the more important item.
TYPE "%HERE%\logs\latest.log" | FINDSTR /C:"invalid dist DEDICATED_SERVER" >nul 2>&1
IF !ERRORLEVEL!==0 (
  ECHO: && ECHO        %red% --- SPECIAL MESSAGE --- %blue%
  ECHO    THE TEXT 'invalid dist DEDICATED_SERVER' WAS FOUND IN THE LOG FILE
  ECHO    THIS COULD MEAN YOU HAVE CLIENT MODS CRASHING THE SERVER - OTHERWISE SOME MOD AUTHORS DID NOT SILENCE THAT MESSAGE.
  ECHO:
  ECHO    TRY USING THE UNIVERSALATOR %green% 'SCAN' %blue% OPTION TO FIND CLIENT MODS.
  ECHO        %red% --- SPECIAL MESSAGE --- %blue% && ECHO:
)

PAUSE
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
ECHO:
IF NOT EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
ECHO   %yellow% MiniUPnP PROGRAM %blue% - %red% NOT YET INSTALLED / DOWNLOADED %blue%
ECHO   Port forwarding done in one way or another is requied for people outside your router network to connect.
ECHO   ---------------------------------------------------------------------------------------------
ECHO   %yellow% SETTING UP PORT FORWARDING: %blue%
ECHO   1- THE PREFERRED METHOD IS MANUALLY SETTING UP PORT FORWARDING IN YOUR ROUTER
ECHO        Manual setting of port forwarding introduces less risk allowing connections than using UPnP.  
ECHO:
ECHO   2- UPnP CAN BE USED IF YOU HAVE A COMPATIBLE NETWORK ROUTER WITH UPnP SET TO ENABLED
ECHO        UPnP is a connection method with which networked computers can open ports on network routers.
ECHO        Not all routers have UPnP - and if yours does it needs to be enabled in settings  - it often is by default.
ECHO: && ECHO:
ECHO        For personal preference the tool used by the Universalator to do UPnP functions - MiniUPnP - is not downloaded
ECHO        by default.  To check if your router can use UPnP, and use it for setting up port forwarding - you can
ECHO        enter %yellow% DOWNLOAD %blue% to get the file and enable Universalator script UPnP functions.
ECHO: && ECHO:
ECHO      %yellow% FOR MORE INFORMATION ON PORT FORWARDING AND UPnP - VISIT THE UNIVERSALATOR WIKI AT: %blue%
ECHO      %yellow% https://github.com/nanonestor/universalator/wiki                                    %blue%
ECHO: && ECHO   ENTER YOUR SELECTION && ECHO      %green% 'DOWNLOAD' - Download UPnP Program %blue% && ECHO      %green% 'M' - Main Menu %blue%
)

IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
ECHO: && ECHO   %yellow% MiniUPnP PROGRAM %blue% - %green% DOWNLOADED %blue%
IF !ISUPNPACTIVE!==N ECHO   %yellow% UPNP STATUS %blue% -      %red% NOT ACTIVATED: %blue% && ECHO                        %red% 'A' - ACTIVATE %yellow% OR %red% SET UP AND USE MANUAL NETWORK ROUTER PORT FORWARDING %blue% && ECHO:
IF !ISUPNPACTIVE!==Y  ECHO   %yellow% UPNP STATUS %blue% - %green% ACTIVE - FORWARDING PORT %PORT% %blue% && ECHO:
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
ECHO: && ECHO   %green% M - Main Menu %blue%
ECHO: && ECHO   Enter your choice:
)
ECHO:

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
    ECHO: && ECHO:
    ECHO   %red% NO UPNP ENABLED NETWORK ROUTER WAS FOUND - SORRY. %blue% && ECHO:
    ECHO   IT IS POSSIBLE THAT YOUR ROUTER DOES HAVE UPNP COMPATIBILITY BUT IT IS CURRENTLY
    ECHO   SET TO DISABLED.  CHECK YOUR NETWORK ROUTER SETTINGS.
    ECHO: && ECHO   or && ECHO:
    ECHO   YOU WILL NEED TO CONFIGURE PORT FORWARDING ON YOUR NETWORK ROUTER MANUALLY
    ECHO   FOR INSRUCTIONS YOU CAN WEB SEARCH PORT FORWARDING MINECRAFT SERVERS
    ECHO   OR
    ECHO   VISIT THE UNIVERSALATOR WIKI AT:
    ECHO   https://github.com/nanonestor/universalator/wiki
    ECHO: && ECHO:
    PAUSE
    GOTO :upnpmenu
)
IF !FOUNDVALIDUPNP!==Y (
    CLS
    ECHO: && ECHO: && ECHO:
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
ECHO: && ECHO: && ECHO:
ECHO       %yellow% ENABLE UPNP PORT FORWARDING? %blue%
ECHO: && ECHO:
ECHO         Enter your choice:
ECHO:
ECHO         %green% 'Y' or 'N' %blue%
ECHO:
SET /P "ENABLEUPNP="
IF /I !ENABLEUPNP! NEQ N IF /I !ENABLEUPNP! NEQ Y GOTO :upnpactivate
IF /I !ENABLEUPNP!==N GOTO :upnpmenu
SET /a CYCLE=1
SET ACTIVATING=Y
:activatecycle
:: Tries several different command methods to activate the port forward using miniUPnP.  Each attempt then goes to get checked for success in the upnpstatus section.
IF !CYCLE!==1 (
  univ-utils\miniupnp\upnpc-static.exe -a !LOCALIP! %PORT% %PORT% TCP 0
  SET /a CYCLE+=1
  GOTO :activatestatus
)
IF !CYCLE!==2 (
  univ-utils\miniupnp\upnpc-static.exe -r %PORT% TCP
  SET /a CYCLE+=1
  GOTO :activatestatus
)
IF !CYCLE!==3 (
  univ-utils\miniupnp\upnpc-static.exe -a %PUBLICIP% %PORT% %PORT% TCP
  SET /a CYCLE+=1
  GOTO :activatestatus
)
SET ACTIVATING=N
:: Activating if reaching here has failed - run a scan of the first activation method to try and produce an error code to read



ECHO   %red% SORRY - The activation of UPnP port forwarding was not detected to have worked. %blue%
PAUSE
GOTO :upnpmenu

:: END UPNP ACTIVATE PORT FORWARD


:: BEGIN UPNP CHECK STATUS
:upnpstatus
:: Loops through the lines in the -l flag to list MiniUPNP active ports - looks for a line that is different with itself compated to itself but
:: trying to replace any string inside that matches the port number with a random different string - in this case 'PORT' for no real reason.
:: Neat huh?  Is proabably faster than piping an echo of the variables to findstr and then checking errorlevels (other method to do this).
ECHO   %red% Checking Status of UPnP Port Forward ... ... ... %blue% && ECHO:
:activatestatus
SET ISUPNPACTIVE=N
FOR /F "delims=" %%E IN ('univ-utils\miniupnp\upnpc-static.exe -l') DO (
    SET UPNPSTATUS=%%E
    IF "!UPNPSTATUS!" NEQ "!UPNPSTATUS:%PORT%=PORT!" SET ISUPNPACTIVE=Y
)
:: IF detected port is active then reset var set if sent here by activating code, then either way go back to upnp menu.
IF !ISUPNPACTIVE!==Y (
  IF DEFINED ACTIVATING SET ACTIVATING=N
  ECHO   %green% ACTIVE - Port forwarding using UPnP is active for port %PORT% %blue%
  PAUSE
  GOTO :upnpmenu
)
:: if script was sent here by the activating section and port forward still not active - goes back there.
IF !ISUPNPACTIVE!==N IF DEFINED ACTIVATING IF !ACTIVATING!==Y GOTO :activatecycle
:: Otherwise goes back to upnpmenu
IF !ISUPNPACTIVE!==N ECHO   %red% NOT ACTIVE - Port forwarding using UPnP is not active for port %PORT% %blue%
PAUSE
GOTO :upnpmenu
:: END UPNP CHECK STATUS


:: BEGIN UPNP DEACTIVATE AND CHECK STATUS AFTER
:upnpdeactivate
IF NOT DEFINED ISUPNPACTIVE GOTO :upnpmenu
IF !ISUPNPACTIVE!==N GOTO :upnpmenu
IF !ISUPNPACTIVE!==Y (
    CLS
    ECHO: && ECHO: && ECHO:
    ECHO   %yellow% UPNP IS CURRENTLY ACTIVE %blue%
    ECHO:
    ECHO   %yellow% DO YOU WANT TO DEACTIVATE IT? %blue%
    ECHO: && ECHO:
    ECHO       %green% 'Y' or 'N' %blue% && ECHO:
    ECHO       Enter your choice: && ECHO:
    SET /P "DEACTIVATEUPNP="
)
IF /I !DEACTIVATEUPNP! NEQ Y IF /I !DEACTIVATEUPNP! NEQ N GOTO :upnpdeactivate
IF /I !DEACTIVATEUPNP!==N GOTO :upnpmenu
:: Deactivates the port connection used by the MiniUPNP program.
IF /I !DEACTIVATEUPNP!==Y (
    univ-utils\miniupnp\upnpc-static.exe -d %PORT% TCP
    SET ISUPNPACTIVE=N
    FOR /F "delims=" %%E IN ('univ-utils\miniupnp\upnpc-static.exe -l') DO (
        SET UPNPSTATUS=%%E
        IF "!UPNPSTATUS!" NEQ "!UPNPSTATUS:%PORT%=PORT!" SET ISUPNPACTIVE=Y
    )
    IF !ISUPNPACTIVE!==N (
        CLS
        ECHO:
        ECHO     UPNP SUCCESSFULLY DEACTIVATED
        ECHO:
        PAUSE
        GOTO :upnpmenu
    )
    IF !ISUPNPACTIVE!==Y (
      ECHO:
      ECHO   %red% DEACTIVATION OF UPNP PORT FORWARDING HAS FAILED %blue% && ECHO:
      ECHO   %red% UPNP PORT FORWARDING IS STILL ACTIVE %blue% && ECHO:
      PAUSE
      GOTO :upnpmenu
    )
)
:: END UPNP DEACTIVATE AND CHECK STATUS AFTER


:: BEGIN UPNP FILE DOWNLOAD
:upnpdownload
CLS
ECHO: && ECHO:
ECHO  %yellow% DOWNLOAD MINIUPNP PROGRAM? %blue% && ECHO:
ECHO  THE SCRIPT WILL DOWNLOAD THE MINIUPnP PROGRAM FROM THAT PROJECTS WEBSITE AT: && ECHO:
ECHO   http://miniupnp.free.fr/files/ && ECHO:
ECHO   MiniUPnP is published / licensed as a free and open source program. && ECHO:
ECHO  %yellow% DOWNLOAD MINIUPNP PROGRAM? %blue% && ECHO:
ECHO   ENTER YOUR CHOICE: && ECHO:
ECHO   %green%  'Y' - Download file %blue%
ECHO   %green%  'N' - NO  (Back to UPnP menu) %blue% && ECHO:
SET /P "ASKUPNPDOWNLOAD="
IF /I !ASKUPNPDOWNLOAD! NEQ N IF /I !ASKUPNPDOWNLOAD! NEQ Y GOTO :upnpdownload
IF /I !ASKUPNPDOWNLOAD!==N GOTO :upnpmenu
:: If download is chosen - download the MiniUPNP Windows client ZIP file, License.  Then unzip out only the standalone miniupnp-static.exe file and delete the ZIP.
IF /I !ASKUPNPDOWNLOAD!==Y IF NOT EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
  CLS
  ECHO: && ECHO: && ECHO   Downloading ZIP file ... ... ... && ECHO:
  IF NOT EXIST "%HERE%\univ-utils\miniupnp" MD "%HERE%\univ-utils\miniupnp"
  powershell -Command "(New-Object Net.WebClient).DownloadFile('http://miniupnp.free.fr/files/upnpc-exe-win32-20220515.zip', 'univ-utils\miniupnp\upnpc-exe-win32-20220515.zip')"
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/miniupnp/miniupnp/master/LICENSE', 'univ-utils\miniupnp\LICENSE.txt')"
  IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-exe-win32-20220515.zip" (
    ECHO   %green% SUCCESSFULLY DOWNLOADED MINIUPNP BINARAIES ZIP FILE %blue%
    "%HERE%\univ-utils\7-zip\7za.exe" e -aoa "%HERE%\univ-utils\miniupnp\upnpc-exe-win32-20220515.zip" "upnpc-static.exe" -ouniv-utils\miniupnp >nul
    DEL "%HERE%\univ-utils\miniupnp\upnpc-exe-win32-20220515.zip" >nul 2>&1
  ) ELSE (
      ECHO: && ECHO  %red% DOWNLOAD OF MINIUPNP FILES ZIP FAILED %blue%
      PAUSE
      GOTO :upnpmenu
  )
  IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" (
    SET FOUNDUPNPEXE=Y
    SET ISUPNPACTIVE=N
    ECHO: && ECHO   %green% MINIUPNP FILE upnpc-static.exe SUCCESSFULLY EXTRACTED FROM ZIP %blue% && ECHO:
    ECHO   %yellow% Checking current UPnP status ... ... ... %blue% && ECHO:
    FOR /F "delims=" %%E IN ('univ-utils\miniupnp\upnpc-static.exe -l') DO (
        SET UPNPSTATUS=%%E
        IF "!UPNPSTATUS!" NEQ "!UPNPSTATUS:%PORT%=PORT!" SET ISUPNPACTIVE=Y
    )
    ECHO       Going back to UPnP menu ... ... ... && ECHO:
    PAUSE
    GOTO :upnpmenu
  ) ELSE (
    SET FOUNDUPNPEXE=N
    ECHO: && ECHO   %green% MINIUPNP BINARY ZIP FILE WAS FOUND TO BE DOWNLOADED %blue% && ECHO   %red% BUT FOR SOME REASON EXTRACTING THE upnpc-static.exe FILE FROM THE ZIP FAILED %blue%
    PAUSE 
  )
  GOTO :upnpmenu
) ELSE GOTO :upnpmenu

:: END UPNP SECTION

:: BEGIN JAVA OVERRIDE SECTION
:override
CLS
ECHO: && ECHO: && ECHO   %green% JAVA OVERRIDE FOR THE CURRENT PROGRAM SESSION ENABLED %blue% && ECHO   %yellow% Using the following system Path Java %blue% && ECHO:
FOR /F "delims=" %%J IN ('java -version') DO ECHO %%J
ECHO: && ECHO   %yellow% GOOD LUCK WITH THAT !! %blue% && ECHO: && ECHO   %green% JAVA OVERRIDE FOR THE CURRENT PROGRAM SESSION ENABLED %blue% && ECHO:
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
  ECHO: && ECHO  %green% NO MCREATOR MADE MODS WERE DETECTED IN THE MODS FOLDER %blue% && ECHO:
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
ECHO: && ECHO: && ECHO:
ECHO    The above mod files were created using MCreator.
ECHO    %red% They are known to often cause severe problems because of the way they get coded. %blue% && ECHO:
ECHO    A text tile has been generated in this directory named mcreator-mods.txt listing
ECHO      the mod file names for future reference. && ECHO:
PAUSE
GOTO :mainmenu
:: END MCREATOR SECTION
