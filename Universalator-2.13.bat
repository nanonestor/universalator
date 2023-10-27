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
prompt [universalator]:
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
:: If Windows is older than 10 tells user the sad news that they are not supported.
:: If Windows is greater than or equal to version 10 then set some variables to set console output colors!  Then skip OS warning.
IF %major% LEQ 9 (
    ECHO: & ECHO: & ECHO:
    ECHO   YOUR WINDOWS VERSION IS OLD ENOUGH TO NOT BE SUPPORTED & ECHO:
    ECHO   UPDATING TO WINDOWS 10 OR GREATER IS HIGHLY RECOMMENDED
    ECHO:
    PAUSE && EXIT [\B]
)
IF %major% GEQ 10 (
  SET yellow=[34;103m
  SET blue=[93;44m
  SET green=[93;42m
  SET red=[93;101m
)

:: Checks the last character of the folder name the script was run from.  If that last character is found in a FINDSTR of the string of bad characters then prompt user to change the folder name or move the server files and pause/exit.
:: Handling the character needs to be done carefully because it will be null in some cases without character escaping ^ or echo without entering variables as string.  Special characters at the end of the working folder breaks certain CMD commands.
SET "LASTCHAR=%cd:~-1%"
SET "BADS=& ( )"
ECHO "%BADS%" | FINDSTR "%LASTCHAR%" >nul && (
  CLS
  ECHO. & ECHO. & ECHO. & ECHO   %yellow% PROBLEM DETECTED %blue% & ECHO. & ECHO  %red% "%cd%" %blue% & ECHO. & ECHO      THE ABOVE FOLDER LOCATION ENDS IN A SPECIAL CHARACTER - %red% ^%LASTCHAR% %blue% & ECHO.
  ECHO      REMOVE THIS SPECIAL CHARACTER FROM THE END OF OF THE FOLDER NAME OR USE A DIFFERENT FOLDER
  ECHO      SPECIAL CHARACTERS AT THE END OF FOLDER NAMES BREAKS CERTAIN COMMAND FUNCTIONS THE SCRIPT USES
  ECHO. & ECHO      Example of good location:  C:\MYSERVERS\MYSERVER1
  ECHO. & ECHO   %yellow% PROBLEM DETECTED %blue% & ECHO. & ECHO. & ECHO.
  PAUSE && EXIT [\B]
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


:: Checks to see if CMD is working by checking WHERE for some commands
:testcmdagain

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
WHERE TAR >nul 2>&1
IF %ERRORLEVEL% NEQ 0 SET CMDBROKEN=Y

:: The below SET PATH only applies to this command window launch and isn't permanent to the system's PATH.
:: It's only done if the above tests fail, after the second round of tests if still fail prompt user with message.

IF DEFINED CMDBROKEN IF !CMDBROKEN!==Y IF NOT DEFINED CMDFIX (
  SET "PATH=%PATH%C:\Windows\System32;"
  SET "PATH=%PATH%C:\Windows\SysWOW64;"
  SET CMDFIX=TRIED
  GOTO :testcmdagain
)
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

:: Checks to see if Powershell is installed.  If the powershell command isn't found then an attempt is made to add it to the path for this command window session.
:: If still not recognized as command user is prompted with a message about the problem.

WHERE powershell >nul 2>&1
IF %ERRORLEVEL% NEQ 0 SET "PATH=%PATH%C:\Windows\System32\WindowsPowerShell\v1.0\;"
ver >nul
WHERE powershell >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
  ECHO:
  ECHO   Uh oh - POWERSHELL is not detected as installed to your system - or not installed correctly to system PATH.
  ECHO:          
  ECHO   'Microsoft Powershell' is required for this program to function.
  ECHO   Web search to find an installer for this product!
  ECHO:
  ECHO   FOR ADDITIONAL INFORMATION - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
  ECHO   https://github.com/nanonestor/universalator/wiki
  ECHO: & ECHO:
  PAUSE && EXIT [\B]
)

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
    ECHO         %yellow% WARNING WARNING WARNING %blue%
    ECHO         %red% DO NOT PUT SERVER FOLDERS INSIDE OF SYSTEM FOLDERS %blue%
    ECHO         %yellow% WARNING WARNING WARNING %blue%
    ECHO:
    ECHO   %red% %LOC% %blue%
    ECHO   %yellow% The folder this is being run from ^(shown above^) was detected to be %blue%
    ECHO   %yellow% inside a folder or subfolder containing one of the names: %blue% && ECHO:
    ECHO   %red%'DESKTOP'%blue%  %red%'DOCUMENTS'%blue% %red%'ONEDRIVE'%blue% %red%'PROGRAM FILES'%blue% %red%'DOWNLOADS'%blue% %red%'.minecraft'%blue%
ECHO: && ECHO ------------------------------------------------------------------------- && ECHO:
    ECHO   %yellow% Servers should not run in these folders because it can cause issues with file access by games, system permissions, %blue%
    ECHO   %yellow% and could be set as cloud storage. %blue%
    ECHO: && ECHO: && ECHO:
    ECHO         %green% USE FILE EXPLORER TO MAKE A NEW FOLDER OR MOVE THIS FOLDER TO A NON-SYSTEM FOLDER LOCATION. %blue%
    ECHO:
    ECHO         %green% --EXAMPLES THAT WORK -- %blue%
    ECHO:
    ECHO         %green% C:\MYNEWSERVER\ %blue%   %green% D:\MYSERVERS\MODDEDSERVERNAME\ %blue%
    ECHO: && ECHO:
    PAUSE && EXIT [\B]
)

:: The following line is purely done to guarantee the current ERRORLEVEL is reset
ver >nul

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
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
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
FOR /F %%B IN ('powershell -Command "Invoke-RestMethod https://api.ipify.org"') DO SET PUBLICIP=%%B

REM Another different method to return the public IP from the same website
REM FOR /F %%B IN ('curl -w "\n" -s https://api.ipify.org') DO SET PUBLICIP=%%B

FOR /F %%A IN ('findstr server-port server.properties') DO SET PORTLINE=%%A
IF DEFINED PORTLINE SET PORT=%PORTLINE:~12%
IF NOT DEFINED PORT SET PORT=25565

IF !PORT! LSS 10000 (
  CLS
  ECHO: & ECHO: & ECHO   %red% CURRENT PORT SET IN server.properties FILE - %blue%%yellow% !PORT! %blue%
  ECHO: & ECHO   %red% DO NOT SET THE PORT TO BE USED BELOW 10000 - BELOW THAT NUMBER IS NOT A GOOD IDEA %blue%
  ECHO: & ECHO   %red% OTHER CRITICAL PROCESSES MAY ALREADY USE PORTS BELOW THIS NUMBER %blue% & ECHO:
  PAUSE && EXIT [\B]
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
ECHO: && ECHO:
IF DEFINED MAXRAMGIGS ECHO   %yellow% MAX RAM / MEMORY %blue%  !MAXRAMGIGS!
ECHO:
ECHO:
IF DEFINED PORT ECHO   %yellow% CURRENT PORT SET %blue%          !PORT!                            %green% MENU OPTIONS %blue%
IF NOT EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" ECHO   %yellow% UPNP PROGRAM (MINIUPNP) %blue% NOT LOADED
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" ECHO   %yellow% UPNP PROGRAM (MINIUPNP) %blue%   LOADED
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" IF !ISUPNPACTIVE!==N ECHO   %yellow% UPNP STATUS %blue%       %red% NOT ACTIVATED %blue%
IF EXIST "%HERE%\univ-utils\miniupnp\upnpc-static.exe" IF !ISUPNPACTIVE!==Y  ECHO   %yellow% UPNP STATUS %blue%  %green% ACTIVE - FORWARDING PORT %PORT% %blue%
IF EXIST settings-universalator.txt ECHO                                                           %green% L %blue% = LAUNCH SERVER
IF NOT EXIST settings-universalator.txt ECHO                                                           %green% S %blue% = SETTINGS ENTRY
IF EXIST settings-universalator.txt ECHO                                                           %green% S %blue% = RE-ENTER ALL SETTINGS
ECHO                                                           %green% R %blue% = SET (ONLY)RAM MAXIMUM
ECHO                                                           %green% J %blue% = SET (ONLY) JAVA VERSION
ECHO                                                           %green% UPNP %blue% = UPNP PORT FORWARDING MENU
ECHO                                                           %green% SCAN %blue% = SCAN MOD FILES FOR CLIENT mods
ECHO                                                           %green% A %blue% = LIST ALL POSSIBLE MENU OPTIONS
SET /P SCRATCH="%blue%  %green% ENTER A MENU OPTION:%blue% " <nul
SET /P "MAINMENU="

IF /I !MAINMENU!==Q EXIT [\B]
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
IF /I !MAINMENU!==A GOTO :allcommands

:: If no recognized entries were made then go back to main menu
IF !MAINMENU!=="" GOTO :mainmenu
GOTO :mainmenu

:allcommands
CLS
ECHO:%yellow%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO    Welcome to the Universalator - A modded Minecraft server installer / launcher    
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%blue%
ECHO: & ECHO: & ECHO:
ECHO:    %green% S %blue% = RE-ENTER ALL SETTINGS
ECHO:    %green% L %blue% = LAUNCH SERVER
ECHO:    %green% R %blue% = SET RAM MAXIMUM AMOUNT
ECHO:    %green% J %blue% = SET JAVA VERSION
ECHO:    %green% UPNP %blue% = UPNP PORT FORWARDING MENU
ECHO:    %green% Q %blue% = QUIT
ECHO:
ECHO:    %green% SCAN %blue% = SCAN MOD FILES FOR CLIENT ONLY MODS
ECHO:
ECHO:    %green% MCREATOR %blue% = SCAN MOD FILES FOR MCREATOR MADE MODS
ECHO:
ECHO:    %green% OVERRIDE %blue% = USE CURRENTLY SET SYSTEM JAVA PATH INSTEAD OF UNIVERSALATOR JAVA
ECHO: & ECHO: & ECHO: & ECHO:
PAUSE
GOTO :mainmenu


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

IF /I !MODLOADER!==QUILT GOTO :enterquilt
IF /I !MODLOADER!==FORGE GOTO :enterforge
IF /I !MODLOADER!==NEOFORGE GOTO :enterforge
IF /I !MODLOADER!==VANILLA GOTO :fabricandquiltandvanillaram

:: If Fabric modloader ask user to enter Fabric and Fabric Loader

:redofabricloader
IF /I !MODLOADER!==FABRIC (
FOR /F %%A IN ('powershell -Command "$url = 'https://maven.fabricmc.net/net/fabricmc/fabric-loader/maven-metadata.xml'; $data =[xml](New-Object System.Net.WebClient).DownloadString($url); $data.metadata.versioning.release"') DO SET FABRICLOADER=%%A
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
IF /I !ASKFABRICLOADER!==Y GOTO :fabricandquiltandvanillaram
IF /I !ASKFABRICLOADER!==N (
  ECHO   %yellow% ENTER A CUSTOM SET FABRIC LOADER VERSION: %blue% && ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P FABRICLOADER=
)
:: Checks if any blank spaces were in the entry.
IF "!FABRICLOADER!" NEQ "!FABRICLOADER: =!" GOTO :redofabricloader

:: If custom Fabric Loader was entered check on the maven XML file that it is a valid version
FOR /F %%A IN ('powershell -Command "$url = 'https://maven.fabricmc.net/net/fabricmc/fabric-loader/maven-metadata.xml'; $data =[xml](New-Object System.Net.WebClient).DownloadString($url); $data.metadata.versioning.versions.version"') DO (
  IF %%A==!FABRICLOADER! GOTO :fabricandquiltandvanillaram
)
:: If this point is reached then no valid Fabric Loader version was found on the maven - go to the oops message
GOTO :oopsnovalidfabricqulit

:: If Quilt modloader ask user to enter Fabric and Fabric Loader
:enterquilt
FOR /F %%A IN ('powershell -Command "$url = 'https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-loader/maven-metadata.xml'; $data =[xml](New-Object System.Net.WebClient).DownloadString($url); $data.metadata.versioning.release"') DO SET QUILTLOADER=%%A
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
  ECHO   %yellow% ENTER A CUSTOM SET QUILT LOADER VERSION: %blue% && ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P QUILTLOADER=
)

:: Checks if any blank spaces were in the entry.
IF "!QUILTLOADER!" NEQ "!QUILTLOADER: =!" GOTO :redofabricloader

:: If custom Quilt Loader was entered check on the maven XML file that it is a valid version
FOR /F %%A IN ('powershell -Command "$url = 'https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-loader/maven-metadata.xml'; $data =[xml](New-Object System.Net.WebClient).DownloadString($url); $data.metadata.versioning.versions.version"') DO (
  IF %%A==!QUILTLOADER! GOTO :fabricandquiltandvanillaram
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

:: If Forge get newest Forge version available of the selected minecraft version.
IF /I !MODLOADER!==FORGE (
  SET /a idx=0
  SET "ARRAY[!idx!]="
  FOR /F "tokens=1,2 delims=-" %%A IN ('powershell -Command "$url = 'https://maven.minecraftforge.net/net/minecraftforge/forge/maven-metadata.xml'; $data =[xml](New-Object System.Net.WebClient).DownloadString($url); $data.metadata.versioning.versions.version"') DO (
    IF %%A==%MINECRAFT% (
        SET ARRAY[!idx!]=%%B
        SET /a idx+=1
    )
  )
  SET NEWESTFORGE=!ARRAY[0]!
  IF "!ARRAY[0]!" EQU "" (
    CLS
    ECHO: & ECHO: & ECHO: & ECHO   %red% OOPS %blue% - %yellow% NO FORGE VERSIONS EXIST FOR THIS MINECRAFT VERSION %blue% - !MINECRAFT! & ECHO:
    ECHO   %yellow% PRESS ANY KEY TO TRY A DIFFERENT COMBINATION OF MINECRAFT VERSION AND MODLOADER TYPE %blue% & ECHO: & ECHO: & ECHO:
    PAUSE
    GOTO :startover
  )
)

:: If Neoforge get newest Forge version available of the selected minecraft version.
IF /I !MODLOADER!==NEOFORGE (
  SET "NEWESTNEOFORGE="
  FOR /F "tokens=1,2 delims=-" %%A IN ('powershell -Command "$url = 'https://maven.neoforged.net/releases/net/neoforged/forge/maven-metadata.xml'; $data =[xml](New-Object System.Net.WebClient).DownloadString($url); $data.metadata.versioning.versions.version"') DO (
    IF %%A==%MINECRAFT% (
        SET NEWESTNEOFORGE=%%B
    )
  )
  IF "!NEWESTNEOFORGE!" EQU "" (
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
  ECHO   %yellow% FORGE VERSION - FORGE VERSION %blue% & ECHO:

ECHO     THE NEWEST VERSION OF !MODLOADER! FOR MINECRAFT VERSION !MINECRAFT!
ECHO     WAS DETECTED TO BE:
IF /I !MODLOADER!==FORGE ECHO                      %green% !NEWESTFORGE! %blue%
IF /I !MODLOADER!==NEOFORGE ECHO                      %green% !NEWESTNEOFORGE! %blue%
ECHO:
ECHO     -ENTER %green% 'Y' %blue% TO USE THIS NEWEST VERSION & ECHO: & ECHO      %yellow% OR %blue% & ECHO:
ECHO     -ENTER A VERSION NUMBER TO USE INSTEAD
ECHO        example: 14.23.5.2860
ECHO        example: 47.1.3
ECHO: & ECHO   %yellow% FORGE VERSION - FORGE VERSION %blue% & ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P "FROGEENTRY="
IF NOT DEFINED FROGEENTRY GOTO :redoenterforge
IF /I "!FROGEENTRY!"=="Y" (
  IF !MODLOADER!==FORGE SET FORGE=!NEWESTFORGE!
  IF !MODLOADER!==NEOFORGE SET NEOFORGE=!NEWESTNEOFORGE!
  :: Skips ahead if Y to select the already found newest version was entered
  GOTO :skipvalidcheck
)
:: Checks if any blank spaces were in the entry.
IF "!FROGEENTRY!" NEQ "!FROGEENTRY: =!" GOTO :redoenterforge

:: Checks to see if there were any a-z or A-Z characters in the entry.
ECHO:
SET FORGEENTRYCHECK=IDK
ECHO !FROGEENTRY! | FINDSTR "[a-z] [A-Z]" && SET FORGEENTRYCHECK=LETTER
 IF !FORGEENTRYCHECK!==IDK (
    IF /I !MODLOADER!==FORGE SET FORGE=!FROGEENTRY!
    IF /I !MODLOADER!==NEOFORGE SET NEOFORGE=!FROGEENTRY!
) ELSE (
  ECHO: & ECHO OOPS NOT A VALID ENTRY MADE - PRESS ANY KEY AND TRY AGAIN & ECHO:
  PAUSE
  GOTO :redoenterforge
)

:: Checks maven website to determine if non-newest version entered does in fact exist
:: Compares the Minecraft version and FORGE/NEOFORGE entry input above to the Maven manifest file for either modloader that is selected
IF /I !MODLOADER!==FORGE (
  FOR /F "tokens=1,2 delims=-" %%A IN ('powershell -Command "$url = 'https://maven.minecraftforge.net/net/minecraftforge/forge/maven-metadata.xml'; $data =[xml](New-Object System.Net.WebClient).DownloadString($url); $data.metadata.versioning.versions.version"') DO (
    IF %%A==!MINECRAFT! IF %%B==!FROGEENTRY! GOTO :foundvalidforgeversion
    )
)
IF /I !MODLOADER!==NEOFORGE (
  FOR /F "tokens=1,2 delims=-" %%A IN ('powershell -Command "$url = 'https://maven.neoforged.net/releases/net/neoforged/forge/maven-metadata.xml'; $data =[xml](New-Object System.Net.WebClient).DownloadString($url); $data.metadata.versioning.versions.version"') DO (
    IF %%A==!MINECRAFT! IF %%B==!FROGEENTRY! GOTO :foundvalidforgeversion
  )
)
:: If no valid version was detected on the maven file server XML list then no skip ahead was done to the foundvalidforgeversion label - display error and go back to enter another version
CLS
ECHO: & ECHO: & ECHO: & ECHO: & ECHO: & ECHO   %red% OOPS - THE VERSION OF %yellow% !MODLOADER! %red% ENTERED : %yellow% %MINECRAFT% - %FROGEENTRY% %blue% & ECHO:
ECHO   %red% DOES NOT SEEM TO EXIST ON THE FORGE FILE SERVER %blue% & ECHO:
ECHO   %red% ENTER A DIFFERENT VERSION NUMBER THAT IS KNOWN TO EXIST %blue% & ECHO: & ECHO:
PAUSE
GOTO :redoenterforge

:foundvalidforgeversion

:: Pre-sets Java versions as default set versions in case any funny business happens later
:skipvalidcheck
IF %MCMAJOR% LEQ 16 SET JAVAVERSION=8
IF %MCMAJOR%==17 SET JAVAVERSION=16
IF %MCMAJOR% GEQ 18 SET JAVAVERSION=17

:gojava
IF /I !MODLOADER!==FABRIC GOTO :fabricandquiltandvanillaram
IF /I !MODLOADER!==QUILT GOTO :fabricandquiltandvanillaram
IF DEFINED OVERRIDE SET OVERRIDE=N
:: This section is for Forge and Neoforge Java setting
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
:: Minecraft 1.17.x requires only Java 16 and no other works
IF !MCMAJOR!==17 SET JAVAVERSION=16

:: Minecraft equal to and newer than 1.18
IF !MCMAJOR! GEQ 18 (
  ECHO: & ECHO: & ECHO: & ECHO:
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO:
  ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
  ECHO:
  IF /I !MCMAJOR!==17 (
  ECHO   -JAVA VERSION FOR 1.17/1.17.1 %green% MUST BE %blue% 16
  ECHO: && ECHO: && ECHO:
  ) ELSE (
  ECHO   JAVA VERSIONS AVAILABLE FOR MINECRAFT 1.18 and newer -- %green% 17 %blue% *Target version* / RECOMMENDED & ECHO:
  ECHO                                                        -- %green% 18 %blue% & ECHO:
  ECHO:
  ECHO:  JAVA 18 %green% MAY %blue% OR %red% MAY NOT %blue% WORK - DEPENDING ON MODS BEING LOADED OR CHANGES IN THE MODLOADER VERSION
  ECHO   IF YOU TRY JAVA NEWER THAN 17 AND CRASHES HAPPEN -- EDIT SETTINGS TO TRY 17
  )
  ECHO:
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO: & ECHO:
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P JAVAVERSION=
  IF !JAVAVERSION! NEQ 17 IF !JAVAVERSION! NEQ 18 GOTO :gojava
)

:: Minecraft Forge 1.16.5 is a special version that a few different Javas can work with
IF !MINECRAFT!==1.16.5 (
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
  IF !JAVAVERSION! NEQ 8 IF !JAVAVERSION! NEQ 11 GOTO :gojava
)

:: Minecraft 1.16 and older
IF /I !MCMAJOR! LEQ 16 IF !MINECRAFT! NEQ 1.16.5 (
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
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P JAVAVERSION=
  IF !JAVAVERSION! NEQ 8 GOTO :gojava
)
IF /I !MODLOADER!==FORGE GOTO :skipthatram
IF /I !MODLOADER!==NEOFORGE GOTO :skipthatram

:: IF Fabric or Quilt ask for Java verison entry
:fabricandquiltandvanillaram

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
  ECHO: && ECHO: && ECHO: && ECHO:
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
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P JAVAVERSION=

IF !MCMAJOR! LEQ 16 IF !JAVAVERSION! NEQ 8 GOTO :fabricandquiltandvanillaram
IF !MCMAJOR!==17 IF !JAVAVERSION! NEQ 16 GOTO :fabricandquiltandvanillaram
IF !MCMAJOR! GEQ 18 IF !JAVAVERSION! NEQ 17 IF !JAVAVERSION! NEQ 18 IF !JAVAVERSION! NEQ 19 GOTO :fabricandquiltandvanillaram

:skipthatram
IF /I !MAINMENU!==J GOTO :setconfig

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
    ECHO :: Modloader type - FORGE / NEOFORGE / FABRIC / QUILT>>settings-universalator.txt
    ECHO SET MODLOADER=!MODLOADER!>>settings-universalator.txt
    ECHO ::>>settings-universalator.txt
    ECHO :: Enter the version number of the modloader type set above>>settings-universalator.txt
    IF /I !MODLOADER!==FORGE ECHO SET MODLOADERVERSION=!FORGE!>>settings-universalator.txt
    IF /I !MODLOADER!==NEOFORGE ECHO SET MODLOADERVERSION=!NEOFORGE!>>settings-universalator.txt
    IF /I !MODLOADER!==FABRIC ECHO SET MODLOADERVERSION=!FABRICLOADER!>>settings-universalator.txt
    IF /I !MODLOADER!==QUILT ECHO SET MODLOADERVERSION=!QUILTLOADER!>>settings-universalator.txt
    IF /I !MODLOADER!==VANILLA ECHO SET MODLOADERVERSION=>>settings-universalator.txt
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
    SET JAVAFILENAME="jdk8u382-b05/OpenJDK8U-jre_x64_windows_hotspot_8u382b05.zip"
    SET JAVAFOLDER="univ-utils\java\jdk8u382-b05-jre\."
    SET checksumeight=976068897ed670ff775f14227982a71af88dfdeee03f9070f7c75356c2c05890
    SET JAVAFILE="univ-utils\java\jdk8u382-b05-jre\bin\java.exe"
)
IF !JAVAVERSION!==11 (
    SET JAVAFILENAME="jdk-11.0.20%%2B8/OpenJDK11U-jre_x64_windows_hotspot_11.0.20_8.zip"
    SET JAVAFOLDER="univ-utils\java\jdk-11.0.20+8-jre\."
    SET checksumeight=06b88b61d85d069483d22ff4b0b8dbdfdb321bd55d8bbfe8e847980a2586b714
    SET JAVAFILE="univ-utils\java\jdk-11.0.20+8-jre\bin\java.exe"
)
IF !JAVAVERSION!==16 (
    SET JAVAFILENAME="jdk-16.0.2%%2B7/OpenJDK16U-jdk_x64_windows_hotspot_16.0.2_7.zip"
    SET JAVAFOLDER="univ-utils\java\jdk-16.0.2+7\."
    SET checksumeight=40191ffbafd8a6f9559352d8de31e8d22a56822fb41bbcf45f34e3fd3afa5f9e
    SET JAVAFILE="univ-utils\java\jdk-16.0.2+7\bin\java.exe"
)
IF !JAVAVERSION!==17 (
    SET JAVAFILENAME="jdk-17.0.8%%2B7/OpenJDK17U-jre_x64_windows_hotspot_17.0.8_7.zip"
    SET JAVAFOLDER="univ-utils\java\jdk-17.0.8+7-jre\."
    SET checksumeight=216aa7d4db4bd389b8e3d3b4f1a58863666c37c58b0a83e1c744620675312e36
    SET JAVAFILE="univ-utils\java\jdk-17.0.8+7-jre\bin\java.exe"
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
IF /I !MODLOADER! NEQ VANILLA IF NOT EXIST "%HERE%\mods" (
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
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  set /P "NEWRESPONSE=" 
  IF /I !NEWRESPONSE! NEQ N IF /I !NEWRESPONSE! NEQ Y GOTO :nomodsfolder
  IF /I !NEWRESPONSE!==N (
    GOTO :mainmenu
  )
)

:: Downloads java binary file
:javaretry
IF EXIST !JAVAFILE! GOTO :skipjavainstall

IF NOT EXIST "%HERE%\univ-utils\java\java.zip" IF NOT EXIST %JAVAFOLDER% (
  CLS
  ECHO:
  ECHO: Java installation not detected - Downloading Java files!...
  ECHO:
  IF NOT EXIST univ-utils\java MD univ-utils\java
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/adoptium/temurin!JAVAVERSION!-binaries/releases/download/%JAVAFILENAME%', 'univ-utils\java\java.zip')" >nul

)
IF NOT EXIST univ-utils\java\java.zip (
  ECHO: & ECHO: & ECHO   JAVA BINARIES ZIP FILE FAILED TO DOWNLOAD - PRESS ANY KEY TO TRY AGAIN! & ECHO: & ECHO:
  GOTO :javaretry
)
:: Gets the checksum hash of the downloaded java binary file
set idx=0 
IF EXIST univ-utils\java\java.zip (
  FOR /F %%F IN ('certutil -hashfile univ-utils\java\java.zip SHA256') DO (
      SET OUT[!idx!]=%%F
      SET /a idx+=1
  )

  IF NOT EXIST univ-utils\java\java.zip IF NOT EXIST %JAVAFOLDER% (
    ECHO:
    ECHO   !yellow! Something went wrong downloading the Java files. !blue!
    ECHO    Press any key to try again.
    PAUSE
    GOTO :javaretry
  )
)
IF EXIST univ-utils\java\java.zip (
SET filechecksum=!OUT[1]!
) ELSE (
    SET filechecksum=0a
  )
:: Checks to see if the calculated checksum hash is the same as stored value above - unzips file if valid
IF EXIST univ-utils\java\java.zip (
    PUSHD univ-utils\java
    IF !checksumeight!==!filechecksum! (
    tar -xf java.zip
    ) && DEL java.zip && ECHO   Downloaded Java binary and stored hashfile match values - file is valid
    POPD
)
IF EXIST univ-utils\java\java.zip IF !checksumeight! NEQ !filechecksum! (
  ECHO:
  ECHO %yellow% THE JAVA INSTALLATION FILE DID NOT DOWNLOAD CORRECTLY - PLEASE TRY AGAIN %blue%
  DEL univ-utils\java\java.zip && PAUSE && EXIT [\B]
)
:: Sends console message if Java found
:skipjavainstall
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

:: BEGIN SPLIT BETWEEN SETUP FOR DIFFERENT MODLOADERS - SENDS SCRIPT TO THE NEXT PLACE DEPENDING ON WHICH
IF /I !MODLOADER!==FABRIC GOTO :preparefabric
IF /I !MODLOADER!==QUILT GOTO :preparequilt
IF /I !MODLOADER!==VANILLA GOTO :preparevanilla
:: BEGIN FORGE SPECIFIC SETUP AND LAUNCH
:detectforge
CLS
:: Checks to see if the specific JAR file or libraries folder exists for this modloader & version.  If found we'll assume it's installed correctly and move to the foundforge label.
IF /I !MODLOADER!==NEOFORGE IF EXIST libraries/net/neoforged/forge/!MINECRAFT!-!NEOFORGE!/. GOTO :foundforge

IF /I !MODLOADER!==FORGE (
  IF EXIST libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/. GOTO :foundforge
  IF EXIST forge-!MINECRAFT!-!FORGE!.jar GOTO :foundforge
  IF EXIST minecraftforge-universal-!MINECRAFT!-!FORGE!.jar GOTO :foundforge
  IF EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar GOTO :foundforge
  IF EXIST forge-!MINECRAFT!-!FORGE!-universal.jar GOTO :foundforge
)
ECHO: & ECHO:
:: At this point assume the JAR file or libaries folder does not exist and installation is needed.
IF /I !MODLOADER!==FORGE ECHO   Existing Forge !FORGE! files installation not detected.
IF /I !MODLOADER!==NEOFORGE ECHO   Existing Neoforge !NEOFORGE! files installation not detected.
ECHO: & ECHO   Beginning installation! & ECHO:

:: Deletes existing JAR files and libraries folder to prevent mash-up of various versions installing on top of each other, and then moves on
DEL *.jar >nul 2>&1
IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
ECHO: && ECHO   Forge !FORGE! Server JAR-file not found.
ECHO   Any existing JAR files and 'libaries' folder deleted. & ECHO:

:: Downloads the Minecraft server JAR if version is 1.16 and older.  Some old Forge installer files point to dead URL links for this file.  This gets ahead of that and gets the vanilla server JAR first.
:: Sends the script to the vanilla server section to get, then gets returned back here after.
IF !MCMAJOR! LEQ 16 IF NOT EXIST minecraft_server.!MINECRAFT!.jar GOTO :getvanillajar
:returnfromgetvanillajar

:pingforgeagain
:: Pings the Forge files server to see it can be reached - decides to ping if forge file not present - accounts for extremely annoyng changes in filenames depending on OLD version names.
ECHO   Pinging !MODLOADER! file server... & ECHO:
IF /I !MODLOADER!==FORGE ping -n 4 maven.minecraftforge.net >nul
IF /I !MODLOADER!==NEOFORGE ping -n 4 maven.neoforged.net >nul
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
  ECHO   Downloading !MINECRAFT! - Forge - !FORGE! installer file!
  curl -sLfo forge-installer.jar https://maven.minecraftforge.net/net/minecraftforge/forge/!FORGEFILENAMEORDER!/forge-!FORGEFILENAMEORDER!-installer.jar >nul 2>&1
  IF NOT EXIST forge-installer.jar (
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!FORGEFILENAMEORDER!/forge-!FORGEFILENAMEORDER!-installer.jar', 'forge-installer.jar')" >nul 2>&1
  )
)
:: Downloads the Neoforge installer file if modloader is Neoforge
:downloadneoforge
IF /I !MODLOADER!==NEOFORGE (
  ECHO   Downloading !MINECRAFT! - Neoforge - !NEOFORGE! installer file!
  curl -sLfo forge-installer.jar https://maven.neoforged.net/releases/net/neoforged/forge/!MINECRAFT!-!NEOFORGE!/forge-!MINECRAFT!-!NEOFORGE!-installer.jar >nul 2>&1
  IF NOT EXIST forge-installer.jar (
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.neoforged.net/releases/net/neoforged/forge/!MINECRAFT!-!NEOFORGE!/forge-!MINECRAFT!-!NEOFORGE!-installer.jar', 'forge-installer.jar')" >nul 2>&1
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
  ECHO: && ECHO Installer downloaded. Installing...
  !JAVAFILE! -Djava.net.preferIPv4Stack=true -XX:+UseG1GC -jar forge-installer.jar --installServer
  DEL forge-installer.jar >nul 2>&1
  DEL forge-installer.jar.log >nul 2>&1
  ECHO: & ECHO Installation complete. forge-installer.jar deleted. & ECHO:
  GOTO :detectforge
)

:foundforge
IF /I !MODLOADER!==FORGE ECHO   Detected Installed Forge !FORGE!. Moving on...
IF /I !MODLOADER!==NEOFORGE ECHO   Detected Installed Neoforge !NEOFORGE!. Moving on...

:: Forge was found to exist at this point - delete the not needed script files that newer Forge/Neoforge installs that the Universalator BAT replaces.
IF !MCMAJOR! GEQ 17 (
  DEL "%HERE%\run.*" >nul 2>&1
  IF EXIST "%HERE%\user_jvm_args.txt" DEL "%HERE%\user_jvm_args.txt"
)

:eula
::If eula.txt doens't exist yet user prompted to agree and sets the file automatically to eula=true.  The only entry that gets the user further is 'agree'.
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
    ECHO   User agreed to Mojang's EULA.
    ECHO:
    ECHO eula=true> eula.txt
  ) ELSE (
    GOTO :eula
  )
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
IF /I !MAINMENU!==L IF /I !MODLOADER!==NEOFORGE GOTO :launchneoforge
IF /I !MAINMENU!==L IF /I !MODLOADER!==FORGE GOTO :launchforge
IF /I !MAINMENU!==L IF /I !MODLOADER!==FABRIC GOTO :fabricmain

:: MODULE TO CHECK FOR CLIENT SIDE MODS
:actuallyscanmods
SET ASKMODSCHECK=N
IF NOT EXIST "%HERE%\mods" GOTO :mainmenu
  CLS
  ECHO: & ECHO:
  ECHO   %yellow% CLIENT MOD SCANNING - CLIENT MOD SCANNING %blue% && ECHO:
  ECHO:
  ECHO       --MANY CLIENT MODS ARE NOT CODED TO SELF DISABLE ON SERVERS AND MAY CRASH THEM && ECHO:
  ECHO       --THE UNIVERSALATOR SCRIPT CAN SCAN THE MODS FOLDER AND SEE IF ANY ARE PRESENT && ECHO:
  ECHO         For an explanation of how the script scans files - visit the official wiki at:
  ECHO         https://github.com/nanonestor/universalator/wiki
  ECHO:
  ECHO   %yellow% CLIENT MOD SCANNING - CLIENT MOD SCANNING %blue% && ECHO:
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
    PAUSE && EXIT [\B]
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
  FINDSTR /R /C:"!SERVERMODS[%%b].id!" univ-utils\clientonlymods.txt

  :: If errorlevel is 0 then the FINDSTR above found the modID.  The line returned by the FINDSTR can be captured into a variable by using a FOR loop.
  :: That variable is compared to the server modID in question.  If they are equal then it is a definite match and the modID and filename are recorded to a list of client only mods found.
  IF !ERRORLEVEL!==0 (
    FOR /F "delims=" %%A IN ('FINDSTR /R /C:"!SERVERMODS[%%b].id!" univ-utils\clientonlymods.txt') DO (
      IF !SERVERMODS[%%b].id!==%%A (
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
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO   %yellow% READY TO LAUNCH !MODLOADER! SERVER! %blue%
ECHO:
ECHO        CURRENT SERVER SETTINGS:
ECHO        MINECRAFT - !MINECRAFT!
IF /I !MODLOADER!==FORGE ECHO        FORGE - !FORGE!
IF /I !MODLOADER!==NEOFORGE ECHO        NEOFORGE - !NEOFORGE!
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
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P "FORGELAUNCH="
IF /I !FORGELAUNCH!==M GOTO :mainmenu


ECHO: && ECHO   Launching... && ping -n 2 127.0.0.1 > nul && ECHO   Launching.. && ping -n 2 127.0.0.1 > nul && ECHO   Launching. && ECHO:
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

:: General case for NEW (1.17 and newer) Minecraft versions.
IF !MCMAJOR! GEQ 17 (
%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% @libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/win_args.txt nogui %*
)

:actuallylaunchneoforge
IF /I !MODLOADER!==NEOFORGE (
  %JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% @libraries/net/neoforged/forge/!MINECRAFT!-!NEOFORGE!/win_args.txt nogui %*
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
:: END FORGE LAUNCH SECTION


:: BEGIN FABRIC INSTALLATION SECTION
:preparefabric
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
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
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
IF EXIST fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar (
  GOTO :launchfabric 
) ELSE (
  GOTO :preparefabric
)
:: END FABRIC INSTALLATION SECTION

:: BEGIN QUILT INSTALLATION SECTION
:preparequilt
:: Skips installation if already present
IF EXIST quilt-server-launch-!MINECRAFT!-!QUILTLOADER!.jar GOTO :launchquilt

:: Deletes existing core files and folders if this specific desired Fabric launch file not present.  This forces a fresh installation and prevents getting a mis-match of various minecraft and/or fabric version files conflicting.
IF NOT EXIST fabric-server-launch-!MINECRAFT!-!QUILTLOADER!.jar (
  IF EXIST "%HERE%\.fabric" RD /s /q "%HERE%\.fabric\"
  IF EXIST "%HERE%\libraries" RD /s /q "%HERE%\libraries\"
  DEL *.jar >nul 2>&1
)

:: Pings the Quilt file server
:quiltserverpingagain
 ping -n 3 maven.quiltmc.org >nul
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
:quilteula
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
  SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
  SET /P "RESPONSE="
)
IF /I !RESPONSE!==AGREE (
  ECHO:
  ECHO User agreed to Mojang's EULA.
  ECHO:
  ECHO eula=true> eula.txt
)
IF /I !RESPONSE! NEQ AGREE IF !RESPONSE! NEQ IDKYET GOTO :quilteula

IF EXIST eula.txt (
  ECHO:
  ECHO eula.txt file found! ..
  ECHO:
)
IF /I !MODLOADER!==VANILLA GOTO :launchvanilla
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

IF EXIST minecraft_server.!MINECRAFT!.jar GOTO :skipvanillainstall
:getvanillajar
:: Tries to ping the Mojang file server to check that it is online and responding
SET /a pingmojang=1
:pingmojangagain
CLS
ECHO: & ECHO: & ECHO: & ECHO   Pinging Mojang file server - Attempt # !pingmojang! ... & ECHO:
ping -n 4 launchermeta.mojang.com >nul
IF %ERRORLEVEL% NEQ 0 (
  SET pingmojang+=1
  CLS
  ECHO:
  ECHO A PING TO THE MOJANG FILE SERVER HAS FAILED
  ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
  ECHO PRESS ANY KEY TO TRY TO PING FILESERVER AGAIN
  PAUSE
  GOTO :pingmojangagain
)
CLS
ECHO: & ECHO: & ECHO   Downloading Minecraft server JAR file... .. . & ECHO:
:: Downloads the vanilla Minecraft server JAR from the Mojang file server
powershell -Command "(New-Object Net.WebClient).DownloadFile(((Invoke-RestMethod -Method Get -Uri ((Invoke-RestMethod -Method Get -Uri "https://launchermeta.mojang.com/mc/game/version_manifest_v2.json").versions | Where-Object -Property id -Value !MINECRAFT! -EQ).url).downloads.server.url), 'minecraft_server.!MINECRAFT!.jar')"
:: If the download failed to get a file then try again
IF NOT EXIST minecraft_server.!MINECRAFT!.jar (
  ECHO: & ECHO: & ECHO   OOPS - THE MINECRAFT SERVER JAR FAILED TO DOWNLOAD & ECHO: & ECHO   PRESS ANY KEY TO TRY DOWNLOADING AGAIN & ECHO: & ECHO:
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
IF /I !MODLOADER!==FORGE GOTO :returnfromgetvanillajar
IF /I !MODLOADER!==NEOFORGE GOTO :returnfromgetvanillajar

:skipvanillainstall
:: Goes to the Quilt section EULA screen, after that it goes directly to the launchvanilla label
GOTO :quilteula

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
ECHO   %yellow% READY TO LAUNCH !MODLOADER! SERVER! %blue%
ECHO:
ECHO            ENTER %green% 'M' %blue% FOR MAIN MENU
ECHO            ENTER %green% ANY OTHER %blue% KEY TO START SERVER LAUNCH 
ECHO:
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
SET /P FABRICLAUNCH=
IF /I !FABRICLAUNCH!==M GOTO :mainmenu


ECHO: && ECHO   Launching... && ping -n 2 127.0.0.1 > nul && ECHO   Launching.. && ping -n 2 127.0.0.1 > nul && ECHO   Launching. && ECHO:

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
    ECHO: && ECHO: && ECHO:
    ECHO   %yellow% UPNP IS CURRENTLY ACTIVE %blue%
    ECHO:
    ECHO   %yellow% DO YOU WANT TO DEACTIVATE IT? %blue%
    ECHO: && ECHO:
    ECHO       %green% 'Y' or 'N' %blue% && ECHO:
    ECHO       Enter your choice: && ECHO:
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
SET /P SCRATCH="%blue%  %green% ENTRY: %blue% " <nul
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
    PUSHD "%HERE%\univ-utils\miniupnp"
    tar -xf upnpc-exe-win32-20220515.zip upnpc-static.exe >nul
    DEL upnpc-exe-win32-20220515.zip >nul 2>&1
    POPD
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
SET /a num=0
FOR /F "usebackq delims=" %%J IN (`"java -version 2>&1"`) DO (
  ECHO        %%J
  SET JAV[!num!]=%%J
  SET /a num+=1
)
ECHO: && ECHO   %yellow% GOOD LUCK WITH THAT !! %blue% && ECHO: && ECHO   %green% JAVA OVERRIDE FOR THE CURRENT PROGRAM SESSION ENABLED %blue% && ECHO:
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
