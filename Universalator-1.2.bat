@ECHO OFF

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











:: GENERAL PRE-RUN ITEMS
setlocal enabledelayedexpansion
:: Sets the backgound color of the command window
color 1E
:: Additional JVM arguments that will always be applied
SET OTHERARGS=-Dlog4j2.formatMsgNoLookups=true
:: These variables set to exist as blank in case windows is older than 10 and they aren't assigned otherwise
SET "yellow="
SET "blue="
:: Sets the working directory to this folder directory in case something happens like user runs as admin
CD "%~dp0" >nul 2>&1

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
  GOTO :skipwin
)
IF %major%==6 IF %minor% GEQ 3 (
    GOTO :skipwin
) ELSE (
    ECHO.
    ECHO YOUR WINDOWS VERSION IS OLD ENOUGH TO NOT BE SUPPORTED
    ECHO UPDATING TO WINDOWS 10 OR GREATER IS HIGHLY RECOMMENDED
    ECHO.
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
    ECHO.
    ECHO  %yellow% WARNING - IT WAS DETECTED THAT YOU HAVE THE WINDOWS ENVIRONMENTAL VARIABLE %blue%
    ECHO  %yellow% NAMED %blue% _JAVA_OPTIONS %yellow% SETTING GLOBAL RAM MEMORY VALUES SUCH AS -Xmx or -Xmn %blue%
    ECHO.
    ECHO  %yellow% PLEASE REMOVE THIS VALUE FROM THE VARIABLE SO THAT YOUR SERVER WILL LAUNCH CORRECTLY! %blue%
    ECHO.
    ECHO  IF YOU DON'T KNOW HOW - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
    ECHO  https://github.com/nanonestor/universalator/wiki
    ECHO.
    PAUSE && EXIT [\B]
  )
:skipjavopts

: Check for JDK_JAVA_OPTIONS
IF NOT DEFINED JDK_JAVA_OPTIONS GOTO :skipjdkjavaoptions
IF DEFINED JDK_JAVA_OPTIONS (
  ECHO %JDK_JAVA_OPTIONS% | FINDSTR /i "xmx xmn" 1>NUL
)
  IF %ERRORLEVEL%==0 (
    ECHO.
    ECHO  %yellow% WARNING - IT WAS DETECTED THAT YOU HAVE THE WINDOWS ENVIRONMENTAL VARIABLE %blue%
    ECHO  %yellow% NAMED %blue% JDK_JAVA_OPTIONS %yellow% SETTING GLOBAL RAM MEMORY VALUES SUCH AS -Xmx or -Xmn %blue%
    ECHO.
    ECHO  %yellow% PLEASE REMOVE THIS VALUE FROM THE VARIABLE SO THAT YOUR SERVER WILL LAUNCH CORRECTLY! %blue%
    ECHO.
    ECHO  IF YOU DON'T KNOW HOW - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
    ECHO  https://github.com/nanonestor/universalator/wiki
    ECHO.
    PAUSE && EXIT [\B]
  )
:skipjdkjavaoptions

:: Check for JAVA_TOOL_OPTIONS
IF NOT DEFINED JAVA_TOOL_OPTIONS GOTO :skipjavatooloptions
IF DEFINED JAVA_TOOL_OPTIONS (
  ECHO %JAVA_TOOL_OPTIONS% | FINDSTR /i "xmx xmn" 1>NUL
)
  IF %ERRORLEVEL%==0 (
    ECHO.
    ECHO  %yellow% WARNING - IT WAS DETECTED THAT YOU HAVE THE WINDOWS ENVIRONMENTAL VARIABLE %blue%
    ECHO  %yellow% NAMED %blue% JAVA_TOOL_OPTIONS %yellow% SETTING GLOBAL RAM MEMORY VALUES SUCH AS -Xmx or -Xmn %blue%
    ECHO.
    ECHO  %yellow% PLEASE REMOVE THIS VALUE FROM THE VARIABLE SO THAT YOUR SERVER WILL LAUNCH CORRECTLY! %blue%
    ECHO.
    ECHO  IF YOU DON'T KNOW HOW - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
    ECHO  https://github.com/nanonestor/universalator/wiki
    ECHO.
    PAUSE && EXIT [\B]
  )
:skipjavatooloptions

:: Checks to see if the end of this BAT file name ends in ) which is a special case that causes problems with command executions!
SET THISNAME="%~n0"
SET LASTCHAR="%THISNAME:~-2,1%"
IF %LASTCHAR%==")" (
  CLS
  ECHO.
  ECHO   This BAT file was detected to have a file name ending in a closed parentheses character " ) "
  ECHO.
  ECHO    This is a special case character that causes problems with command executions in BAT scripts.
  ECHO    Please rename this file to remove at least that name ending character and try again.
  ECHO.
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

IF DEFINED CMDBROKEN (
  ECHO.
  ECHO   Uh oh - CMD / Command prompt functions are not working correctly on your Windows installation.  
  ECHO.
  ECHO   Web search for fixing / repairing Windows Command prompt function.
  ECHO   FOR ADDITIONAL INFORMATION - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
  ECHO   https://github.com/nanonestor/universalator/wiki
  ECHO.
  PAUSE && EXIT [\B]
)

:: Checks to see if Powershell is installed.  If not recognized as command or exists as file it will send a message to install.
:: If exists as file then the path is simply not set and the ELSE sets it for this script run.

WHERE powershell >nul 2>&1
IF %ERRORLEVEL% NEQ 0 IF NOT EXIST "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" (
  ECHO.
  ECHO   Uh oh - POWERSHELL is not detected as installed to your system.
  ECHO.
  ECHO   'Microsoft Powershell' is required for this program to function.
  ECHO   Web search to find an installer for this product!
  ECHO.
  ECHO   FOR ADDITIONAL INFORMATION - SEE THE UNIVERSALATOR WIKI / TROUBLESHOOTING AT:
  ECHO   https://github.com/nanonestor/universalator/wiki
  ECHO.
  PAUSE && EXIT [\B]

) ELSE SET PATH=%PATH%;"C:\Windows\System32\WindowsPowerShell\v1.0\"

:: This is to fix an edge case issue with folder paths ending in ).  Yes this is worked on already above - including this anyways!
SET LOC=%cd:)=]%

:: Checks folder location this BAT is being run from for various system folders.  Sends appropriate messages if needed.
ECHO "%LOC%" | FINDSTR /i "onedrive documents desktop downloads" 1>NUL
IF %ERRORLEVEL%==0 (
    ECHO.
    ECHO.
    ECHO   %yellow% %LOC% %blue%
    ECHO.
    ECHO   THE FOLDER THIS SCRIPT PROGRAM IS BEING RUN FROM - shown above - WAS DETECTED TO BE
    ECHO   %yellow% INSIDE A FOLDER OF 'ONEDRIVE', 'DOCUMENTS', 'DESKTOP', OR 'DOWNLOADS'. %blue%
    ECHO   SERVERS SHOULD NOT RUN IN THESE FOLDERS BECAUSE IT CAN CAUSE ISSUES WITH SYSTEM PERMISSIONS OR FUNCTIONS.
    ECHO.
    ECHO   USE A FILE BROWSER TO RELOCATE THIS
    ECHO   SERVER FOLDER TO A NEW LOCATION OUTSIDE OF ANY OF THESE SYSTEM FOLDERS.
    ECHO.
    ECHO   EXAMPLES THAT WORK- C:\MYSERVER\    D:\MYSERVERS\MODDEDSERVERNAME\
    ECHO.
    PAUSE && EXIT [\B]
)

:: The following line is purely done to guarantee the current ERRORLEVEL is reset
ver >nul

:: Checks if standalone command line version of 7-zip is present.  If not downloads it.
IF NOT EXIST "%cd%\java" (
  MD java
)
SET ZIP7="%cd%\java\7za.exe"
:try7zipagain
IF NOT EXIST %ZIP7% (
  CLS
  ECHO Downloading and installing 7-Zip...
  MD hey
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/nanonestor/utilities/raw/main/7zipfiles/7za.exe', 'java\7za.exe')" >nul
)
IF NOT EXIST %ZIP7% (
  ECHO.
  ECHO   DOWNLOADING THE 7-ZIP COMMAND LINE PROGRAM FILE HAS FAILED
  ECHO   THIS FILE IS REQUIRED FOR THE UNIVERSALATOR SCRIPT FUNCTION
  ECHO.
  ECHO   PRESS ANY KEY TO RETRY DOWNLOAD
  GOTO :try7zipagain
)

:: If settings-universalator.txt exists already then skip asking/setting one up.
IF EXIST settings-universalator.txt GOTO :skipsettings
:tryagain
CLS
ECHO.%yellow%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO    Welcome to the Universalator - A modded Minecraft server installer / launcher    
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.%blue%
ECHO   SETTINGS - ENTER VALUES WHEN PROMPTED ON FOLLOWING SCREENS.
ECHO      For example - Minecraft version / Modloader type / Java version
ECHO.
ECHO.
ECHO   -- After server files installation completes you can choose to scan for client-side mods.
ECHO   -- Once steps are completed - server files will automatically launch.
ECHO.
ECHO.
ECHO.
ECHO   -- Following first server files launch a %yellow%settings-universalator.txt%blue% file will be
ECHO        generated where settings are stored for future launches.
ECHO.
ECHO        It may be edited to change settings.
ECHO.
ECHO.
ECHO   %yellow% Read above - Do you understand? %blue%
ECHO.
ECHO        "Y" = CONTINUE TO SETTINGS ENTRY
ECHO        "N" = EXIT SCRIPT PROGRAM
ECHO.
ECHO   %yellow% ENTER YOUR ANSWER BELOW - "Y" or "N" %blue%
set /P "LOOKSGOOD=" 

IF /I !LOOKSGOOD!==N (
  PAUSE && EXIT [\B]
)
IF /I !LOOKSGOOD! NEQ Y IF /I !LOOKSGOOD! NEQ N GOTO :tryagain

:startover
:: User entry for Minecraft version
CLS
ECHO.
ECHO   %yellow% ENTER THE MINECRAFT VERSION %blue%
ECHO.
ECHO    example: 1.7.10
ECHO    example: 1.16.5
ECHO    example: 1.19.2
ECHO.
SET /P MINECRAFT=

::Detects whether Minecraft version is older than, or equal/greater than 1.17 and stores in OLDORNEW variable
::This is done again later after the settings-universalator.txt is present and this is section is skipped
SET DOTORNOT=!MINECRAFT:~3,1!
SET OLDORNEW=IDK

IF %DOTORNOT%==. (
    SET OLDORNEW=OLD
)
IF %DOTORNOT% NEQ . (
  IF !MINECRAFT! GEQ 1.17 (
  SET OLDORNEW=NEW
  )
)
IF %DOTORNOT% NEQ . (
  IF !MINECRAFT! LSS 1.17 (
  SET OLDORNEW=OLD
  )
)

IF %OLDORNEW%==IDK (
  ECHO %yellow% INVALID MINECRAFT VERSION ENTERED IN VALUES %blue%
  ECHO   PRESS ANY KEY TO TRY AGAIN
  ECHO.
  PAUSE
  GOTO :startover
)

:reentermodloader
:: User entry for Modloader version
CLS
ECHO.
ECHO   %yellow% ENTER THE MODLOADER TYPE %blue%
ECHO.
ECHO    Valid entries - FORGE or FABRIC
ECHO.
SET /P MODLOADER=
IF /I !MODLOADER! NEQ FORGE IF /I !MODLOADER! NEQ FABRIC (
  GOTO :reentermodloader
)
:: Corrects uppercase/lowercase if not already so to all uppercase
IF /I !MODLOADER!==FORGE SET MODLOADER=FORGE
IF /I !MODLOADER!==FABRIC SET MODLOADER=FABRIC

:: Detects if settings are trying to use some weird old Minecraft Forge version that isn't supported.
:: This is done again later after the settings-universalator.txt is present and this is section is skipped.
IF /I !MODLOADER!==FORGE IF %DOTORNOT%==. IF !MINECRAFT! NEQ 1.6.4 IF !MINECRAFT! NEQ 1.7.10 IF !MINECRAFT! NEQ 1.8.9 IF !MINECRAFT! NEQ 1.9.4 (
  ECHO.
  ECHO  SORRY - YOUR ENTERED MINECRAFT VERSION - FORGE FOR MINECRAFT !MINECRAFT! - IS NOT SUPPORTED.
  ECHO.
  ECHO  FIND A MODPACK WITH A MORE POPULARLY USED VERSION.
  ECHO  OR
  ECHO  PRESS ANY KEY TO START OVER AND ENTER NEW VERSION NUMBERS
  ECHO.
  PAUSE
  GOTO :startover
)

:: If Fabric modloader ask user to enter Fabric Installer and Fabric Loader
IF NOT EXIST settings-universalator.txt IF /I !MODLOADER!==FABRIC (
  CLS
  ECHO.
  ECHO    ENTER THE %yellow% VERSION %blue% OF %yellow% FABRIC --INSTALLER-- %blue%
  ECHO    AS OF JANUARY 2023 THE LATEST VERSION WAS 0.11.1
  ECHO.
  ECHO    UNLESS YOU KNOW OF A NEWER VERSION OR HAVE A PREFERENCE - ENTER 0.11.1
  ECHO.
  SET /P FABRICINSTALLER=
  ECHO.
  ECHO   ENTER THE %yellow% VERSION %blue% OF %yellow% FABRIC --LOADER-- %blue%
  ECHO    AS OF JANUARY 2023 THE LATEST VERSION WAS 0.14.13
  ECHO.
  ECHO    GENERALLY IT IS A GOOD IDEA TO USE THE SAME VERSION THAT THE CLIENT MODPACK IS KNOWN TO LOAD WITH
  ECHO.
  SET /P FABRICLOADER=
  ECHO.
  ECHO.
)

IF !MODLOADER!==FABRIC GOTO :goramentry
:usedefaulttryagain
:: If modloader is Forge present user with option to select recommended versions of Forge and Java.
SET USEDEFAULT=BLANK
IF !MINECRAFT!==1.6.4 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.6.4 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = 9.11.1.1345
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO    ENTER "Y" OR "N"
  ECHO.
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=9.11.1.1345
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.7.10 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.7.10 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = 10.13.4.1614
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO    ENTER "Y" OR "N"
  ECHO.
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=10.13.4.1614
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.8.9 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.8.9 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = 11.15.1.2318
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHo.
  ECHO    ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=11.15.1.2318
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.9.4 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.8.9 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = 12.17.0.2317
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHo.
  ECHO    ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=12.17.0.2317
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.10.2 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.10.2 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = 12.18.3.2511
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHo.
  ECHO    ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=12.18.3.2511
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.12.2 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.12.2 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = 14.23.5.2860
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO.
  ECHO    ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=14.23.5.2860
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.14.4 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.14.4 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = 28.2.26
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO.
  ECHO    ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=28.2.26
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.15.2 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.15.2 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSION OF FORGE?
  ECHO.
  ECHO    FORGE = 31.2.57
  ECHO    JAVA = 8  **JAVA MUST BE 8**
  ECHO.
  ECHO    ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
  IF /I !USEDEFAULT!==Y (
    SET FORGE=31.2.57
    SET JAVAVERSION=8
    GOTO :goramentry
  )
)
IF !MINECRAFT!==1.16.5 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.16.5 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSION OF FORGE?
  ECHO.
  ECHO    FORGE = 36.2.39
  ECHO.
  ECHO    ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
  IF /I !USEDEFAULT!==Y (
    SET FORGE=36.2.39
    GOTO :gojava
  )
)
IF !MINECRAFT!==1.17.1 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.17.1 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = 37.1.1
  ECHO    JAVA = 16  **JAVA MUST BE 16**
  ECHO.
  ECHO    ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=37.1.1
  SET JAVAVERSION=16
  GOTO :goramentry
)
IF !MINECRAFT!==1.18.2 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.18.2 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = 40.2.1
  ECHO    JAVA = 17  **JAVA CAN BE 17, 18, 19**
  ECHO            **JAVA NEWER THAN 17 MAY NOT WORK DEPENDING ON MODS BEING LOADED*
  ECHO.
  ECHO    ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=40.2.1
  SET JAVAVERSION=17
  GOTO :goramentry
)
IF !MINECRAFT!==1.19.2 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.19.2 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = 43.2.4
  ECHO    JAVA = 17  **JAVA CAN BE 17, 18, 19**
  ECHO            **JAVA NEWER THAN 17 MAY NOT WORK DEPENDING ON MODS BEING LOADED*
  ECHO.
  ECHO    ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=43.2.4
  SET JAVAVERSION=17
  GOTO :goramentry
)
IF !MINECRAFT!==1.19.3 (
  CLS
  ECHO.
  ECHO   %yellow% YOU HAVE ENTERED 1.19.3 WHICH IS A POPULAR VERSION %blue%
  ECHO.
  ECHO    WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO.
  ECHO    FORGE = 44.1.8
  ECHO    JAVA = 17  **JAVA CAN BE 17, 18, 19**
  ECHO            **JAVA NEWER THAN 17 MAY NOT WORK DEPENDING ON MODS BEING LOADED*
  ECHO.
  ECHO    ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF /I !USEDEFAULT!==Y (
  SET FORGE=44.1.8
  SET JAVAVERSION=17
  GOTO :goramentry
)

IF /I !USEDEFAULT!==Y GOTO :finalcheck
IF /I !USEDEFAULT!==N GOTO :enterforge
IF /I !USEDEFAULT!==BLANK GOTO :enterforge
GOTO :usedefaulttryagain

:enterforge
  CLS
  ECHO  %yellow% ENTER FORGE VERSION %blue%
  ECHO      example: 14.23.5.2860
  ECHO      example: 40.1.84
  ECHO.
  SET /P FORGE=


:gojava
IF /I !USEDEFAULT!==N IF !MINECRAFT! NEQ 1.16.5 (
  CLS
  ECHO.
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO.
  ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
  ECHO.
  ECHO   -JAVA VERSION FOR MINECRAFT OLDER THAN 1.16.5 %yellow%MUST BE%blue% 8
  ECHO   -JAVA VERSION FOR 1.17/1.17.1 %yellow%MUST BE%blue% 16
  ECHO   -JAVA VERSIONS AVAILABLE FOR MINECRAFT 1.18 and newer: - 17, 18, 19
  ECHO.
  ECHO.  JAVA 18/19 %yellow%MAY%blue% WORK OR %yellow%MAY NOT%blue% DEPENDING ON MODS BEING LOADED OR CHANGES IN FORGE VERSIONS
  ECHO.  IF THE SERVER LAUNCH FAILS AND YOU HAVE ENTERED JAVA 18 OR 19 - EDIT settings-universalator.txt TO USE 17
  ECHO.
  SET /P JAVAVERSION=
)
IF /I !USEDEFAULT!==BLANK IF !MINECRAFT! NEQ 1.16.5 (
  CLS
  ECHO.
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO.
  ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
  ECHO.
  ECHO   -JAVA VERSION FOR MINECRAFT OLDER THAN 1.16.5 %yellow%MUST BE%blue% 8
  ECHO   -JAVA VERSION FOR 1.17/1.17.1 %yellow%MUST BE%blue% 16
  ECHO   -JAVA VERSIONS AVAILABLE FOR MINECRAFT 1.18 and newer: - 17, 18, 19
  ECHO.
  ECHO.  JAVA 18/19 %yellow%MAY%blue% WORK OR %yellow%MAY NOT%blue% DEPENDING ON MODS BEING LOADED OR CHANGES IN FORGE VERSIONS
  ECHO.  IF THE SERVER LAUNCH FAILS AND YOU HAVE ENTERED JAVA 18 OR 19 - EDIT settings-universalator.txt TO USE 17
  ECHO.
  SET /P JAVAVERSION=
)
IF !MINECRAFT!==1.16.5 (
  CLS
  ECHO.
  ECHO  %yellow% ENTER JAVA VERSION %blue%
  ECHO.
  ECHO   THE ONLY VERSIONS AVAILABLE THAT WORK WITH MINECRAFT / FORGE 1.16.5 ARE 8 AND 11
  ECHO.
  ECHO   USING JAVA 11 MAY OR MAY NOT WORK DEPENDING ON MODS BEING LOADED
  ECHO.
  SET /P JAVAVERSION=
)
IF !MINECRAFT!==1.16.5 IF !JAVAVERSION! NEQ 8 IF !JAVAVERSION! NEQ 11 GOTO :gojava

:goramentry

:: IF Fabric ask for Java verison entry
IF !MODLOADER!==FABRIC (
  CLS
  ECHO.
  ECHO  %yellow% ENTER JAVA VERSION TO LAUNCH THE SERVER WITH %blue%
  ECHO.
  ECHO   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON
  ECHO.
  ECHO   AVAILABLE VERSIONS - 8, 11, 17, 18, 19
  ECHO.
  ECHO   -JAVA VERSION FOR MINECRAFT OLDER THAN 1.16.5 -- *MUST BE* 8
  ECHO   -JAVA VERSION FOR 1.17/1.17.1 -- *MUST BE* 16
  ECHO   -JAVA VERSIONS AVAILABLE FOR MINECRAFT 1.18 and newer -- 17 *Target version* / 18 / 19
  ECHO.
  ECHO.  JAVA 18/19 MAY WORK OR MAY NOT DEPENDING ON MODS BEING LOADED OR CHANGES IN FORGE VERSIONS
  ECHO   IF YOU TRY JAVA NEWER THAN 17 AND CRASHES HAPPEN -- EDIT SETTINGS TO TRY 17
  ECHO.
  SET /P JAVAVERSION=
)

:: Sends entry back to re-enter Java if a non supported version entered
IF !JAVAVERSION! NEQ 8 IF !JAVAVERSION! NEQ 11 IF !JAVAVERSION! NEQ 16 IF !JAVAVERSION! NEQ 17 IF !JAVAVERSION! NEQ 18 IF !JAVAVERSION! NEQ 19 GOTO :gojava

IF NOT EXIST settings-universalator.txt (
  CLS
  ECHO.
  ECHO   %yellow% ENTER MAXIMUM RAM / MEMORY THAT THE SERVER WILL RUN - IN GIGABYTES %blue%
  ECHO.
  ECHO    BE SURE IT IS NOT TOO MUCH FOR YOUR COMPUTER!
  ECHO    TYPICAL VALUES FOR MODDED MINECRAFT SERVERS ARE BETWEEN 4 AND 10
  ECHO.
  ECHO.
  SET /P MAXRAMGIGS=
)

:finalcheck
CLS
ECHO.%yellow%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO    Universalator - A modded Minecraft server installer / launcher    
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.%blue%
ECHO.
ECHO   %yellow% THESE ARE THE ENTERED SETTINGS FOR THE INSTALLER / LAUNCHER %blue%
ECHO.   -----------------------------------------------------------
ECHO        MINECRAFT VERSION = !MINECRAFT!
ECHO        MODLOADER TYPE ==== !MODLOADER!
IF !MODLOADER!==FORGE (
ECHO        FORGE VERSION ===== !FORGE!
)
IF !MODLOADER!==FABRIC (
ECHO        FABRIC INSTALLER == !FABRICINSTALLER!
ECHO        FABRIC LOADER ===== !FABRICLOADER!
)
ECHO        JAVA VERSION ====== !JAVAVERSION!
ECHO.    
ECHO        SERVER MAX RAM VALUE = !MAXRAMGIGS! gigabytes
ECHO    -----------------------------------------------------------
ECHO.
ECHO.
ECHO    %yellow% ENTER "Y" TO ACCEPT                      %blue%
ECHO    %yellow% ENTER "N" TO GO BACK AND RE-ENTER VALUES %blue%
ECHO.
SET /P "LOOKSGOOD2="

IF /I !LOOKSGOOD2! NEQ N IF /I !LOOKSGOOD2! NEQ Y GOTO :finalcheck
IF /I !LOOKSGOOD2!==N GOTO :startover


:: Generates settings-universalator.txt file if settings-universalator.txt does not exist
IF NOT EXIST settings-universalator.txt (
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
    ECHO :: Mod client only check on next run - set =Y to reset question ask for next launch>>settings-universalator.txt
    ECHO SET ASKMODSCHECK=Y>>settings-universalator.txt
)

:: Point at which script picks up if settings-universalator.txt was detected and settings entry prompts are skipped.
:skipsettings

:: Loads the settings-universalator.txt file as parameters and then sets the MAXRAM value based on MAXRAMGIGS. >>
:: This is done because that way people can just enter a number without getting confused seeing -Xmx
IF EXIST settings-universalator.txt (
RENAME settings-universalator.txt settings-universalator.bat && CALL settings-universalator.bat && RENAME settings-universalator.bat settings-universalator.txt
)
SET MAXRAM=-Xmx!MAXRAMGIGS!G

::Detects whether Minecraft version is older than, or equal/greater than 1.17 and stores in OLDORNEW variable
SET DOTORNOT=!MINECRAFT:~3,1!
SET OLDORNEW=IDK

IF %DOTORNOT%==. (
    SET OLDORNEW=OLD
)

 IF %DOTORNOT% NEQ . (
    IF !MINECRAFT! GEQ 1.17 (
    SET OLDORNEW=NEW
    )
 )
 IF %DOTORNOT% NEQ . (
    IF !MINECRAFT! LSS 1.17 (
    SET OLDORNEW=OLD
    )
 )

IF %DOTORNOT%==. IF !MODLOADER!==FORGE IF !MINECRAFT! NEQ 1.6.4 IF !MINECRAFT! NEQ 1.7.10 IF !MINECRAFT! NEQ 1.8.9 IF !MINECRAFT! NEQ 1.9.4 (
  ECHO.
  ECHO  SORRY - YOUR ENTERED MINECRAFT VERSION - FORGE FOR MINECRAFT !MINECRAFT! - IS NOT SUPPORTED.
  ECHO.
  ECHO  FIND A MODPACK WITH A MORE POPULARLY USED VERSION.
  ECHO.
  PAUSE && EXIT [\B]
)

IF %OLDORNEW%==IDK (
    ECHO %yellow% INVALID MINECRAFT VERSION ENTERED IN VALUES %blue%
    PAUSE && EXIT [\B]
)
:: The above considers 1.16 versions to be old for the sake of forge launch method later on.  This was somewhat of a transition MC version both for forge launch method and java version needs.
:: The below variable is the price to pay for that - later on both variables can be checked to determine which methods to do various things.
SET IS116=NO
  IF %MINECRAFT%==1.16 SET IS116=YES
IF %MINECRAFT%==1.16.1 SET IS116=YES
IF %MINECRAFT%==1.16.2 SET IS116=YES
IF %MINECRAFT%==1.16.3 SET IS116=YES
IF %MINECRAFT%==1.16.4 SET IS116=YES
IF %MINECRAFT%==1.16.5 SET IS116=YES

:: Sets HOWOLD depending on whether version is newer than, or equal/lessthan 1.12.2.
:: This is used to determine which arrangement of files that mods of that era stored their modID names.  The current mods.toml used started with 1.13.
SET HOWOLD=NOTVERY
IF %OLDORNEW%==OLD IF %DOTORNOT%==. SET HOWOLD=SUPEROLD
IF %OLDORNEW%==OLD IF %DOTORNOT% NEQ . IF !MINECRAFT! LSS 1.13 SET HOWOLD=SUPEROLD


::Stores values in variables depending on Java version entered
SET JAVAGOOD="bad"

IF !JAVAVERSION!==8 (
    SET JAVAFILENAME="jdk8u362-b09/OpenJDK8U-jre_x64_windows_hotspot_8u362b09.zip"
    SET JAVAFOLDER="java\jdk8u362-b09-jre\."
    SET checksumeight=3569dcac27e080e93722ace6ed7a1e2f16d44a61c61bae652c4050af58d12d8b
    SET JAVAFILE="java\jdk8u362-b09-jre\bin\java.exe"
    SET JAVAGOOD="good"
)
IF !JAVAVERSION!==11 (
    SET JAVAFILENAME="jdk-11.0.18%%2B10/OpenJDK11U-jre_x64_windows_hotspot_11.0.18_10.zip"
    SET JAVAFOLDER="java\jdk-11.0.18+10-jre\."
    SET checksumeight=dea0fe7fd5fc52cf5e1d3db08846b6a26238cfcc36d5527d1da6e3cb059071b3
    SET JAVAFILE="java\jdk-11.0.18+10-jre\bin\java.exe"
    SET JAVAGOOD="good"
)
IF !JAVAVERSION!==16 (
    SET JAVAFILENAME="jdk-16.0.2%%2B7/OpenJDK16U-jdk_x64_windows_hotspot_16.0.2_7.zip"
    SET JAVAFOLDER="java\jdk-16.0.2+7\."
    SET checksumeight=40191ffbafd8a6f9559352d8de31e8d22a56822fb41bbcf45f34e3fd3afa5f9e
    SET JAVAFILE="java\jdk-16.0.2+7\bin\java.exe"
    SET JAVAGOOD="good"
)
IF !JAVAVERSION!==17 (
    SET JAVAFILENAME="jdk-17.0.6%%2B10/OpenJDK17U-jre_x64_windows_hotspot_17.0.6_10.zip"
    SET JAVAFOLDER="java\jdk-17.0.6+10-jre\."
    SET checksumeight=85ce690a348977e3739fde3fd729b36c61e86c33da6628bc7ceeba9974a3480b
    SET JAVAFILE="java\jdk-17.0.6+10-jre\bin\java.exe"
    SET JAVAGOOD="good"
)
IF !JAVAVERSION!==18 (
    SET JAVAFILENAME="jdk-18.0.2.1%%2B1/OpenJDK18U-jre_x64_windows_hotspot_18.0.2.1_1.zip"
    SET JAVAFOLDER="java\jdk-18.0.2.1+1-jre\."
    SET checksumeight=ba7976e86e9a7e27542c7cf9d5081235e603a9be368b6cbd49673b417da544b1
    SET JAVAFILE="java\jdk-18.0.2.1+1-jre\bin\java.exe"
    SET JAVAGOOD="good"
)
IF !JAVAVERSION!==19 (
    SET JAVAFILENAME="jdk-19.0.2%%2B7/OpenJDK19U-jre_x64_windows_hotspot_19.0.2_7.zip"
    SET JAVAFOLDER="java\jdk-19.0.2+7-jre\."
    SET checksumeight=daaaa092343e885b0814dd85caa74529b9dec2c1f28a711d5dbc066a9f7af265
    SET JAVAFILE="java\jdk-19.0.2+7-jre\bin\java.exe"
    SET JAVAGOOD="good"
)

:: Checks to see if the Java version entered is available
IF %JAVAGOOD%=="bad" (
  ECHO.
  ECHO   %yellow% THE JAVA VERSION YOU ENTERED IN SETTINGS IS NOT AVAILABLE FOR THIS LAUNCHER %blue%
  ECHO    AVAILABLE VERSIONS ARE = 8, 11, 16, 17, 19
  ECHO.
  PAUSE && EXIT [\B]
)

:: Checks to see if Minecraft version and Java version in settings are compatible
IF %OLDORNEW%==OLD IF %JAVAGOOD%=="good" IF !MINECRAFT! NEQ 1.16.5 IF !JAVAVERSION! NEQ 8 (
  ECHO.
  ECHO    MINECRAFT 1.16.4 AND OLDER MUST USE JAVA 8 ONLY - FIX YOUR SETTINGS
  PAUSE && EXIT [\B]
)
IF %OLDORNEW%==OLD IF %JAVAGOOD%=="good" IF !MINECRAFT!==1.16.5 IF !JAVAVERSION! NEQ 8 (
  IF !JAVAVERSION! NEQ 11 (
    ECHO.
    ECHO    MINECRAFT 1.16.5 MUST USE JAVA 8 OR 11 - FIX YOUR SETTINGS
    PAUSE && EXIT [\B]
))
IF %OLDORNEW%==NEW IF %MINECRAFT:~3,1%==7 IF %JAVAGOOD%=="good" IF !JAVAVERSION! NEQ 16 (
  ECHO.
  ECHO    MINECRAFT 1.17.x MUST USE JAVA 16 - FIX YOUR SETTINGS
  PAUSE && EXIT [\B]
)
IF %OLDORNEW%==NEW IF !MINECRAFT! NEQ 1.17 IF %JAVAGOOD%=="good" IF !JAVAVERSION!==8 (
  ECHO.
  ECHO    MINECRAFT 1.18.x AND NEWER MUST USE JAVA 17+  - FIX YOUR SETTINGS
  PAUSE && EXIT [\B]
)
IF %OLDORNEW%==NEW IF %MINECRAFT:~3,1% NEQ 7 IF %JAVAGOOD%=="good" IF !JAVAVERSION!==16 (
  ECHO.
  ECHO    MINECRAFT 1.18.x AND NEWER MUST USE JAVA 17+  - FIX YOUR SETTINGS
  ECHO %MINECRAFT:~3,1%
  PAUSE && EXIT [\B]
)

SET NEWRESPONSE=Y
IF NOT EXIST "%cd%\mods" (
  :nommodsfolder
  CLS
  ECHO.
  ECHO.
  ECHO.
  ECHO.
  ECHO.
  ECHO   %yellow% NO MODS FOLDER WAS DETECTED IN THIS DIRECTORY YET - ARE YOU SURE YOU WANT TO CONTINUE? %blue%
  ECHO.
  ECHO    --- IF "Y" PROGRAM WILL INSTALL CORE SERVER FILES BUT NOT LAUNCH WHEN FINISHED.
  ECHO        PLACE MODS FOLDER AND ANY OTHER NEEDED SERVER PACK FILES IN THIS SAME FOLDER AND THEN RUN BAT AGAIN.
  ECHO.
  ECHO    --- IF "N" PROGRAM WILL EXIT
  ECHO        DO THIS IF YOU WISH TO FIRST PLACE MODS FOLDER AND ANY OTHER SERVER PACK FILES IN THIS FOLDER
  ECHO             THEN RESTART THIS INSTALLER/LAUNCHER BAT.
  ECHO.
  ECHO   %yellow% TYPE YOUR RESPONSE AND PRESS ENTER: %blue%
  ECHO.
  set /P "NEWRESPONSE=" 

  IF /I !NEWRESPONSE!==N (
    ECHO CLOSING
    PAUSE && EXIT
  )
  IF /I !NEWRESPONSE! NEQ N IF /I !NEWRESPONSE! NEQ Y GOTO :nomodsfolder
)


:: Downloads java binary file
:javaretry
IF NOT EXIST java.zip IF NOT EXIST %JAVAFOLDER% (
  ECHO.
  ECHO. Java installation not detected - Downloading Java files!...
  ECHO.
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
    ECHO.
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
    "%cd%\java\7za.exe" x java.zip -ojava
    ) && DEL java.zip && ECHO Downloaded Java binary and stored hashfile match values - file is valid
)
IF EXIST java.zip IF %checksumeight% NEQ %filechecksum% (
  ECHO.
  ECHO %yellow% THE JAVA INSTALLATION FILE DID NOT DOWNLOAD CORRECTLY - PLEASE TRY AGAIN %blue%
  DEL java.zip && PAUSE && EXIT [\B]
)
:: Sends console message if Java found
IF EXIST %JAVAFOLDER% (
  ECHO.
  ECHO    Java !JAVAVERSION! installation found! ...
  ECHO.
) ELSE (
  ECHO UH-OH - JAVA folder not detected.
  ECHO Perhaps try resetting all files, delete settings-universalator.txt and starting over.
  PAUSE && EXIT [\B]
)


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
    ECHO.
    ECHO   %yellow% WARNING WARNING WARNING %blue%
    ECHO.
    ECHO   IT IS DETECTED THAT THE server.properties FILE HAS AN IP ADDRESS ENTERED AFTER server-ip=
    ECHO.
    ECHO   THIS ENTRY IS ONLY TO BE USED USED IF YOU ARE SETTING UP A CUSTOM DOMAIN
    ECHO   IF YOU ARE NOT SETTING UP A CUSTOM DOMAIN THEN THE SERVER WILL NOT LET PLAYERS CONNECT CORRECTLY
    ECHO.
    ECHO   %yellow% WARNING WARNING WARNING %blue%
    ECHO.
    ECHO   CHOOSE TO CORRECT THIS ENTRY OR IGNORE
    ECHO   ONLY CHOOSE IGNORE IF YOU ARE SETTING UP A CUSTOM DOMAIN
    ECHO.
    ECHO   ENTER YOUR CHOICE:
    ECHO   'CORRECT' or 'IGNORE'
    ECHO.
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
  ECHO. && ECHO.
  ECHO   %yellow% WARNING - PORT ALREADY IN USE - WARNING %blue%
  ECHO.
  ECHO   CURRENT %yellow% PORT SET = %PORTSET% %blue%
  ECHO.
  ECHO   IT IS DETECTED THAT THE PORT CURRENTLY SET (SHOWN ABOVE)
  ECHO   IN THE SETTINGS FILE server.properties %yellow% IS ALREADY IN USE %blue%
  ECHO.
  ECHO   THE FOLLOWING IS THE PROCESS RUNNING THAT APPEARS TO BE USING THE PORT
  ECHO   MINECRAFT SERVERS WILL USUALLY CONTAIN THE NAMES java.exe AND Console
  ECHO.
  ECHO   IMAGE NAME - %IMAGENAME%
  ECHO   SESSION NAME - %SESSIONNAME%
  ECHO   PID NUMBER - %PIDNUM%
  ECHO.
  ECHO   %yellow% WARNING - PORT ALREADY IN USE - WARNING %blue%
  ECHO.
  ECHO   Type 'KILL' to try and let the script close the program using the port already.
  ECHO   Type 'Q' to close the script program if you'd like to try and solve the issue on your own.
  ECHO.
  ECHO   Enter your response:
  SET /P "KILLIT="
  IF /I !KILLIT! NEQ KILL IF /I !KILLIT! NEQ Q GOTO :portwarning
  IF /I !KILLIT!==Q (
    PAUSE && EXIT [\B]
  )
  IF /I !KILLIT!==KILL (
    CLS
    ECHO.
    ECHO   ATTEMPTING TO KILL TASK PLEASE WAIT...
    ECHO.
    TASKKILL /F /PID %PIDNUM%
    ping -n 10 127.0.0.1 > nul
  )
ver > nul
NETSTAT -o -n -a | FINDSTR %PORTSET%
IF %ERRORLEVEL%==0 (
  CLS
  ECHO.
  ECHO   OOPS - THE ATTEMPT TO KILL THE TASK PROCESS USING THE PORT SEEMS TO HAVE FAILED
  ECHO.
  ECHO   FURTHER OPTIONS:
  ECHO   --SET A DIFFERENT PORT, OR CLOSE KNOWN SERVERS/PROGRAMS USING THIS PORT.
  ECHO   --IF YOU THINK PORT IS BEING KEPT OPEN BY A BACKGROUND PROGRAM TRY RESTARTING COMPUTER.
  ECHO   --TRY RUNNING THE UNIVERSALATOR SCRIPT AGAIN.
  ECHO. && ECHO.  && ECHO. 
  PAUSE && EXIT [\B]
)
IF %ERRORLEVEL%==1 (
  ECHO.
  ECHO   SUCCESS!
  ECHO   IT SEEMS LIKE KILLING THE PROGRAM WAS SUCCESSFUL IN CLEARING THE PORT!
  ECHO.
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

:: BEGIN SPLIT BETWEEN FABRIC AND FORGE SETUP AND LAUNCH - If MODLOADER is FABRIC skips the Forge installation and launch section
IF /I !MODLOADER!==FABRIC GOTO :fabricmain

:: BEGIN FORGE SPECIFIC SETUP AND LAUNCH

:: Downloads the Minecraft server JAR if version is = OLD and does not exist.  Some old Forge installer files point to dead URL links for this file.  This gets ahead of that and gets it first.
IF %OLDORNEW%==OLD IF NOT EXIST minecraft_server.!MINECRAFT!.jar (
  powershell -Command "(New-Object Net.WebClient).DownloadFile(((Invoke-RestMethod -Method Get -Uri ((Invoke-RestMethod -Method Get -Uri "https://launchermeta.mojang.com/mc/game/version_manifest_v2.json").versions | Where-Object -Property id -Value !MINECRAFT! -EQ).url).downloads.server.url), 'minecraft_server.!MINECRAFT!.jar')"
)

:pingforgeagain
:: Pings the Forge files server to see it can be reached - decides to ping if forge file not present - accounts for extremely annoyng changes in filenames depending on OLD version names.
IF %OLDORNEW%==OLD IF NOT EXIST forge-!MINECRAFT!-!FORGE!.jar IF NOT EXIST forge-!MINECRAFT!-!FORGE!-universal.jar IF NOT EXIST minecraftforge-universal-!MINECRAFT!-!FORGE!.jar IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  ECHO Pinging Forge file server...
  ECHO.
  ping -n 4 maven.minecraftforge.net >nul
  IF %ERRORLEVEL% NEQ 0 (
    CLS
    ECHO.
    ECHO A PING TO THE FORGE FILE SERVER HAS FAILED
    ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
    ECHO PRESS ANY KEY TO TRY TO PING FILESERVER AGAIN
    PAUSE
    GOTO :pingforgeagain
  )
)
:: Pings the Forge files server for NEW types of Forge (1.17 and newer).  Decides to ping if specific folder is not detected as existing.
IF %OLDORNEW%==NEW IF NOT EXIST libraries\net\minecraftforge\forge\!MINECRAFT!-!FORGE!\. (
  ping -n 4 maven.minecraftforge.net >nul
  IF %ERRORLEVEL% NEQ 0 (
    CLS
    ECHO.
    ECHO A PING TO THE FORGE FILE SERVER HAS FAILED
    ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
    ECHO PRESS ANY KEY TO TRY TO PING FILESERVER AGAIN
    PAUSE
    GOTO :pingforgeagain

  )
)

:: Forge installer file download
:: Detects if installed files or folders exist - if not then deletes existing JAR files and libraries folder to prevent mash-up of various versions installing on top of each other, and then downloads installer JAR
IF %OLDORNEW%==NEW GOTO :skipolddownload

:: 1.6.4
IF !MINECRAFT!==1.6.4 IF NOT EXIST minecraftforge-universal-1.6.4-!FORGE!.jar (
  DEL *.jar
  IF EXIST "%cd%\libraries" RD /s /q "%cd%\libraries\"
  ECHO.
  ECHO Forge Server JAR-file not found.
  ECHO Any existing JAR files and 'libaries' folder deleted.
  ECHO Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')" >nul

)

:: 1.7.10
IF !MINECRAFT!==1.7.10 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  DEL *.jar
  IF EXIST "%cd%\libraries" RD /s /q "%cd%\libraries\"
  ECHO.
  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!-!MINECRAFT!/forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-installer.jar', 'forge-installer.jar')" >nul

)

:: 1.8.9
IF !MINECRAFT!==1.8.9 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  DEL *.jar
  IF EXIST "%cd%\libraries" RD /s /q "%cd%\libraries\"
  ECHO.
  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!-!MINECRAFT!/forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-installer.jar', 'forge-installer.jar')" >nul

)

:: 1.9.4
IF !MINECRAFT!==1.9.4 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  DEL *.jar
  IF EXIST "%cd%\libraries" RD /s /q "%cd%\libraries\"
  ECHO.
  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!-!MINECRAFT!/forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-installer.jar', 'forge-installer.jar')" >nul

)

:: 1.10.2
IF !MINECRAFT!==1.10.2 IF NOT EXIST forge-!MINECRAFT!-!FORGE!-universal.jar (
  DEL *.jar
  IF EXIST "%cd%\libraries" RD /s /q "%cd%\libraries\"
  ECHO.
  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')" >nul

)

:: OLD versions newer than 1.10.2
IF %OLDORNEW%==OLD IF NOT EXIST forge-!MINECRAFT!-!FORGE!.jar IF !MINECRAFT! NEQ 1.6.4 IF !MINECRAFT! NEQ 1.7.10 IF !MINECRAFT! NEQ 1.8.9 IF !MINECRAFT! NEQ 1.9.4 IF !MINECRAFT! NEQ 1.10.2 (
  DEL *.jar
  IF EXIST "%cd%\libraries" RD /s /q "%cd%\libraries\"
  ECHO.
  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')" >nul
)

:skipolddownload
:: For NEW (1.17 and newer) Forge detect if specific version folder is present - if not delete all JAR files and 'install' folder to guarantee no files of different versions conflicting on later install.  Then downloads installer file.
IF %OLDORNEW%==NEW IF NOT EXIST libraries\net\minecraftforge\forge\!MINECRAFT!-!FORGE!\. (
  IF EXIST forge-installer.jar DEL forge-installer.jar
  ECHO.
  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')" >nul

)


IF %ERRORLEVEL% NEQ 0 (
  CLS
  ECHO.
  ECHO forge-installer.jar not found. Maybe the Forge servers are having trouble.
  ECHO Please try again in a couple of minutes.
  ECHO.
  ECHO %yellow% THIS COULD ALSO MEAN YOU HAVE INCORRECT MINECRAFT OR FORGE VERSION NUMBERS ENTERED - CHECK THE VALUES ENTERED %blue%
  ECHO         MINECRAFT - !MINECRAFT!
  ECHO         FORGE ----- !FORGE!
  ECHO.
  ECHO Press any key to try to download forge installer file again.
  PAUSE
  GOTO :pingforgeagain
)

:: Installs forge, detects if successfully made the main JAR file, deletes extra new style files that this BAT replaces

SET INSTALLEDFORGE==NOTYET
IF EXIST forge-installer.jar (
  ECHO Installer downloaded. Installing...
  !JAVAFILE! -Djava.net.preferIPv4Stack=true -XX:+UseG1GC -jar forge-installer.jar --installServer
  DEL forge-installer.jar && SET INSTALLEDFORGE=YES && ECHO Installation complete. forge-installer.jar deleted.
)
IF EXIST forge-!MINECRAFT!-!FORGE!.jar (
  ECHO Detected Installed Forge !FORGE!. Moving on...
  GOTO :foundforge
)
IF EXIST libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/. (
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

        ECHO THE FORGE INSTALLATION FILE DID NOT DOWNLOAD OR INSTALL CORRECTLY - IT WAS NOT FOUND
        ECHO - PLEASE RESET FILES AND TRY AGAIN -
        PAUSE && EXIT [\B]

:foundforge

:: If a Forge installer file was found, used, and the Minecraft vesion is NEW - delete the files that Forge installs that this script replaces function for.
IF %OLDORNEW%==NEW IF %INSTALLEDFORGE%==YES (
  DEL run.bat && DEL run.sh && DEL user_jvm_args.txt
)

:eula

::If eula.txt doens't exist yet 

SET RESPONSE=IDKYET
IF NOT EXIST eula.txt (
  CLS
  ECHO.
  ECHO.
  ECHO Mojang's EULA has not yet been accepted. In order to run a Minecraft server, you must accept Mojang's EULA.
  ECHO Mojang's EULA is available to read at https://account.mojang.com/documents/minecraft_eula
  ECHO.
  ECHO   %yellow% If you agree to Mojang's EULA then type 'AGREE' %blue%
  ECHO.
  ECHO   %yellow% ENTER YOUR RESPONSE %blue%
  ECHO.
  SET /P RESPONSE=
)
IF /I !RESPONSE!==AGREE (
  ECHO.
  ECHO User agreed to Mojang's EULA.
  ECHO.
  ECHO eula=true> eula.txt
)
IF /I !RESPONSE! NEQ AGREE IF NOT EXIST eula.txt (
  GOTO :eula
)
IF EXIST eula.txt (
  ECHO.
  ECHO eula.txt file found! ..
  ECHO.
)



:: Sets a variable to the current directory to use later.  In some niche cases it seems to work better than cd.
SET HERE="%cd%"

IF %ASKMODSCHECK%==N GOTO :skipforgemodscheck

:: Prompt user to decide to scan for client only mods or not.  Either path will eventually set AUTOMODSCHECK==NO


:askcheck
:: MODULE TO CHECK FOR CLIENT SIDE MODS
IF %ASKMODSCHECK%==Y (
  CLS
  ECHO.
  ECHO.
  ECHO   %yellow% WOULD YOU LIKE TO SCAN THE MODS FOLDER FOR MODS THAT ARE NEEDED ONLY ON CLIENTS? %blue%
  ECHO.
  ECHO   ----------------------------------------------------------------------------------
  ECHO.
  ECHO     --MANY MODS ARE NOT CODED PROPERLY TO SELF DISABLE ON SERVERS AND MAY CRASH THEM
  ECHO.
  ECHO     --THIS LAUNCHER CAN SCAN THE MODS FOLDER AND SEE IF ANY ARE PRESENT WHICH
  ECHO       ARE ON THE LAUNCHERS MASTER LIST OF CLIENT ONLY MODS.
  ECHO.
  ECHO.
  ECHO.
  ECHO.
  ECHO.
  ECHO.
  ECHO             %yellow% Please choose "Y" or "N" %blue%
  ECHO.
  SET /P DOSCAN=
  IF /I !DOSCAN!==N (
    GOTO :resetaskmodscheckforge
  )
  )
  IF /I !DOSCAN! NEQ N IF /I !DOSCAN! NEQ Y (
    GOTO :askcheck
  )

  IF EXIST rawidlist.txt DEL rawidlist.txt
  IF EXIST serveridlist.txt DEL serveridlist.txt

  ECHO.
  ECHO Searching for client only mods . . .

  :: Goes to mods folder and gets file names lists.  FINDSTR prints only files with .jar found

  PUSHD mods
  dir /b /a-d > list1.txt
  FINDSTR ".jar" list1.txt > list2.txt
  SORT list2.txt > servermods.txt
  DEL list1.txt && DEL list2.txt
  POPD
  MOVE mods\servermods.txt servermods.txt >nul

  REM Gets the client only list from github file, checks if it's empty or not after download attempt, then sends
  REM to a new file masterclientids.txt with any blank lines removed.
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/nanonestor/utilities/main/clientonlymods.txt', 'rawclientids.txt')" >nul


  REM Checks if the just downloaded file's first line is empty or not.  Better never save that webfile with the first line empty!
  SET /P EMPTYCHECK=<rawclientids.txt
  IF [!EMPTYCHECK!]==[] (
    CLS
    ECHO.
    ECHO.
    ECHO SOMETHING WENT WRONG DOWNLOADING THE MASTER CLIENT-ONLY LIST FROM THE GITHUB HOSTED LIST
    ECHO CHECK THAT YOU HAVE NO ANTIVIRUS PROGRAM OR WINDOWS DEFENDER BLOCKING THE DOWNLOAD FROM -
    ECHO.
    ECHO https://raw.githubusercontent.com/nanonestor/utilities/main/clientonlymods.txt
    ECHO.
    PAUSE && EXIT [\B]
  )
  FINDSTR /v "^$" rawclientids.txt >masterclientids.txt
  IF EXIST rawclientids.txt DEL rawclientids.txt
  
  :: Gets the list of modIDs from actual mod JAR files using servermods.txt
  :: Saves corresponding file names and modIDs in variable array
  :: Extracts the mods.toml file from each JAR

  SET SERVCOUNT=0
  IF EXIST mods.toml DEL mods.toml
  :: START SCANNING MODS

  IF %HOWOLD%==SUPEROLD GOTO :scanmcmodinfo

  REM Get total number of mods currently in mods folder
  SET rawmodstotal=0
  FOR /F "usebackq delims=" %%J IN (servermods.txt) DO (
    SET /a rawmodstotal+=1
  )

  REM BEGIN SCANNING NEW STYLE MODS.TOML
  SET modcount=0
  FOR /F "delims= usebackq" %%W IN (servermods.txt) DO (
    
    "%cd%\java\7za.exe" e -aoa "mods\%%W" "META-INF\mods.toml" >nul
    SET /a modcount+=1
    ECHO SCANNING - !modcount!/!rawmodstotal! - %%W
    
    IF EXIST mods.toml (
      FINDSTR modId mods.toml >temp2.txt
        REM Goes through modIds in temp2.txt and only prints to rawlist.txt the first modID found
        REM --IF the mod author puts the modID for forge first in mods.toml its a big bummmer - will filter out forge results later
      set idx=0
      FOR /F "delims=#" %%X IN (temp2.txt) DO (
        set "thing[!idx!]=%%X"
        set /a idx+=1
      )
      ECHO !thing[0]!>>rawidlist.txt
      SET "FULLARRAY[!SERVCOUNT!].name=%%W"
      SET /a SERVCOUNT+=1
      DEL mods.toml
    )
  )
  SET TOTCOUNT=!SERVCOUNT!

  REM replaces spaces in the rawidlist.txt with astericks to let then next FOR loop find the modID using delims
  powershell -Command "(gc rawidlist.txt) -replace '""', '*' | Out-File -encoding ASCII rawidlist.txt"
  REM Uses delims to only return the actual string of the real modID name in the text and makes the serveridlist.txt
  REM --Only prints the modID if its not actually forge because of it being top of a mods.toml list
  SET SERVCOUNT=0

  FOR /F "tokens=2 delims=*" %%M in (rawidlist.txt) DO (
      ECHO %%M>>serveridlist.txt
      SET "FULLARRAY[!SERVCOUNT!].id=%%M"
      set /a SERVCOUNT+=1
  )
  REM Below skips to finishedscan label to bypass old style mod scan.
  IF %HOWOLD%==NOTVERY GOTO :finishedscan

  REM END SCANNING NEW STYLE MODS.TOML - BEGIN SCANNING OLD STYLE MCMOD.INFO
  :scanmcmodinfo


  REM Get total number of mods currently in mods folder
  SET rawmodstotal=0
  FOR /F "usebackq delims=" %%J IN (servermods.txt) DO (
    SET /a rawmodstotal+=1
  )

  SET modcount=0
  FOR /F "delims= usebackq" %%W IN (servermods.txt) DO (

    "%cd%\java\7za.exe" e -aoa "mods\%%W" "mcmod.info" >nul
    
    SET /a modcount+=1
    ECHO SCANNING - !modcount!/!rawmodstotal! - %%W

    IF EXIST mcmod.info (
      
      FINDSTR /i modid mcmod.info >temp2.txt
        REM Goes through modIds in temp2.txt and only prints to rawlist.txt the first modID found
        REM --IF the mod author puts the modID for forge first in mods.toml its a big bummmer - will filter out forge results later
      set idx=0
      FOR /F "delims=" %%X IN (temp2.txt) DO (
        set "thing[!idx!]=%%X"
        set /a idx+=1
      )
    
      ECHO !thing[0]!>>rawidlist.txt
      SET "FULLARRAY[!SERVCOUNT!].name=%%W"
      SET /a SERVCOUNT+=1
      DEL mcmod.info
    )
  )
  SET TOTCOUNT=!SERVCOUNT!

  REM replaces spaces in the rawidlist.txt with astericks to let then next FOR loop find the modID using delims
  powershell -Command "(gc rawidlist.txt) -replace '""', '*' | Out-File -encoding ASCII rawidlist.txt"
  REM Uses delims to only return the actual string of the real modID name in the text and makes the serveridlist.txt
  REM --Only prints the modID if its not actually forge because of it being top of a mods.toml list
  SET SERVCOUNT=0

  FOR /F "tokens=4 delims=*" %%M in (rawidlist.txt) DO (
      ECHO %%M>>serveridlist.txt
      SET "FULLARRAY[!SERVCOUNT!].id=%%M"
      set /a SERVCOUNT+=1
  )

  :: END SCANNING OLD STYLE MCMOD.INFO
  :finishedscan
  :: FINISHED SCANNING MODS serveridlist.txt and FULLARRAY.id variable array generated

  :: Compares the two lists
  FINDSTR /xig:masterclientids.txt serveridlist.txt >foundclientids.txt

  :: Makes an array of the client ids and counts how many
  SET CLIENTCOUNT=0
  FOR /F %%S IN (foundclientids.txt) DO (
    SET "FOUND[!CLIENTCOUNT!]=%%S"
    SET /a CLIENTCOUNT+=1
  )
  SET TOTCLIENTCOUNT=!CLIENTCOUNT!

  :: Makes an array of only the client ids and matching mod file names
  FOR /L %%B IN (0,1,%TOTCLIENTCOUNT%) DO (
    FOR /L %%Q IN (0,1,%TOTCOUNT%) DO (
      IF !FULLARRAY[%%Q].id!==!FOUND[%%B]! (
        SET "FINALARRAY[%%B].name=!FULLARRAY[%%Q].name!"
        SET "FINALARRAY[%%B].id=!FOUND[%%B]!"
      )
    )
  )

  IF [!FINALARRAY[0].name!]==[] (
    GOTO :noclients
  )

  :: Prints report to user - echos all entries without the modID name = forge
  CLS
  ECHO.
  ECHO.
  ECHO   %yellow% THE FOLLOWING CLIENT ONLY MODS WERE FOUND %blue%
  ECHO.
  IF %HOWOLD%==SUPEROLD (
  ECHO    *NOTE - IT IS DETECTED THAT YOUR MINECRAFT VERSION STORES ITS ID NUMBER IN THE OLD WAY*
  ECHO     SOME CLIENT ONLY MODS MAY NOT BE DETECTED BY THE SCAN - I.E. MODS THAT DO NOT USE A MCMOD.INFO FILE
  )
  ECHO.
  ECHO    ------------------------------------------------------
  :: Prints to the screen all of the values in the array that are not equal to forge or null
  FOR /L %%T IN (0,1,%TOTCLIENTCOUNT%) DO (
    IF /I !FINALARRAY[%%T].id! NEQ forge IF /I "!FINALARRAY[%%T].id!" NEQ "" (
    ECHO        !FINALARRAY[%%T].name! - !FINALARRAY[%%T].id!
    )
  )
  ECHO    ------------------------------------------------------
  ECHO.
  ECHO.
  ECHO.
  ECHO.
  ECHO   %yellow% *** DO YOU WANT TO MOVE THESE CLIENT MODS TO A DIFFERENT FOLDER FOR SAFE KEEPING? *** %blue%
  ECHO.
  ECHO         If "Y" they will NOT be deleted - they WILL be moved to a new folder in the server named CLIENTMODS
  ECHO         SOME CLIENT MODS ARE NOT CODED TO SELF DISABLE AND WILL CRASH SERVERS IF LEFT IN THE MODS FOLDER
  ECHO.
  ECHO.
  ECHO.
  ECHO      - IF YOU THINK THE CURRENT MASTER LIST IS INNACURATE OR HAVE FOUND A MOD TO ADD -
  ECHO         PLEASE CONTACT THE LAUNCHER AUTHOR OR
  ECHO         FILE AN ISSUE AT https://github.com/nanonestor/universalator/issues !
  ECHO.
  :typo
  ECHO    ------------------------------------------------------
  ECHO.
  ECHO       %yellow% ENTER YOUR RESPONSE - "Y" OR "N" %blue%
  ECHO.
  SET /P MOVEMODS=
  IF /I !MOVEMODS!==N GOTO :resetaskmodscheckforge
  IF /I !MOVEMODS!==Y (
    IF NOT EXIST "%cd%\CLIENTMODS" (
      MD CLIENTMODS
      )
      ) ELSE GOTO :typo
  :: Moves files if MOVEMODS is Y.  Checks to see if the value of the array is null for each spot.
  CLS
  ECHO.
  ECHO.
  FOR /L %%L IN (0,1,%TOTCLIENTCOUNT%) DO (
    IF "!FINALARRAY[%%L].name!" NEQ "" (
    MOVE "%cd%\mods\!FINALARRAY[%%L].name!" "%cd%\CLIENTMODS\!FINALARRAY[%%L].name!" >nul
    ECHO   MOVED - "!FINALARRAY[%%L].name!" - to - "%cd%\CLIENTMODS"
    )
  )
  ECHO.
  ECHO      %yellow%   CLIENT MODS MOVED! ...     %blue%
  ECHO      %yellow% -PRESS ANY KEY TO CONTINUE- %blue%
  ECHO.
  PAUSE
  
GOTO :resetaskmodscheckforge

:noclients
CLS
ECHO.
ECHO.
ECHO   %yellow% ----------------------------------------- %blue%
ECHO   %yellow%     NO CLIENT ONLY MODS FOUND             %blue%
ECHO   %yellow% ----------------------------------------- %blue%
ECHO.
ECHO    PRESS ANY KEY TO CONTINUE...
ECHO.

PAUSE

:resetaskmodscheckforge

:: Resets the settings-universalator.txt file so that it won't ask to scan mods next run.
REM User can change config from NO to YES to rescan next run.
powershell -Command "$content = Get-Content -Path '%HERE%\settings-universalator.txt'; $newContent = $content -replace 'SET ASKMODSCHECK=Y', 'SET ASKMODSCHECK=N'; $newContent | Set-Content -Path '%HERE%\settings-universalator.txt'"

:skipforgemodscheck
:: Cleans up the utility txt files used for mod scanning if present.
IF EXIST foundclientids.txt DEL foundclientids.txt
IF EXIST masterclientids.txt DEL masterclientids.txt
IF EXIST mods.toml DEL mods.toml
IF EXIST rawidlist.txt DEL rawidlist.txt
IF EXIST serveridlist.txt DEL serveridlist.txt
IF EXIST servermods.txt DEL servermods.txt
IF EXIST temp2.txt DEL temp2.txt

:: FINALLY LAUNCH FORGE SERVER!

CLS
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO            %yellow%   Universalator - Server launcher script    %blue%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.
ECHO   %yellow% READY TO LAUNCH FORGE SERVER! %blue%
ECHO.
ECHO        CURRENT SERVER SETTINGS:
ECHO        MINECRAFT - !MINECRAFT!
ECHO        FORGE - !FORGE!
ECHO        JAVA - !JAVAVERSION!
ECHO.
ECHO.
ECHO ============================================
ECHO   %yellow% CURRENT NETWORK SETTINGS:%blue%
ECHO.
ECHO   %yellow% PUBLIC IPv4 AND PORT ADDRESS - %PUBLICIP%:%PORT% %blue%
ECHO        --THIS IS WHAT CLIENTS OUTSIDE THE CURRENT ROUTER NETWORK USE TO CONNECT
ECHO        --PORT FORWARDING MUST BE SET UP IN YOUR NETWORK ROUTER
ECHO.
ECHO   INTERNAL IPv4 ADDRESS - ENTER 'ipconfig' FROM A COMMAND PROMPT
ECHO        --THIS IS WHAT CLIENTS INSIDE THE CURRENT ROUTER NETWORK USE TO CONNECT
ECHO        --THE WORD 'localhost' WORKS FOR CLIENTS ON SAME COMPUTER
ECHO.
ECHO ============================================
ECHO.
ECHO.
ECHO   %yellow% PRESS ANY KEY TO START SERVER LAUNCH %blue%
ECHO.
PAUSE

:: Starts forge depending on what java version is set.  Only correct combinations will launch - others will crash.

:: Special case forge.jar filenames for older OLD versions
IF %OLDORNEW%==OLD IF !MINECRAFT!==1.6.4 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar minecraftforge-universal-1.6.4-!FORGE!.jar nogui
) 

IF %OLDORNEW%==OLD IF !MINECRAFT!==1.7.10 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-1.7.10-!FORGE!-1.7.10-universal.jar nogui
) 

IF %OLDORNEW%==OLD IF !MINECRAFT!==1.8.9 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-1.8.9-!FORGE!-1.8.9-universal.jar nogui
) 

IF %OLDORNEW%==OLD IF !MINECRAFT!==1.9.4 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-1.9.4-!FORGE!-1.9.4-universal.jar nogui
) 

IF %OLDORNEW%==OLD IF !MINECRAFT!==1.10.2 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-1.10.2-!FORGE!-universal.jar nogui
) 

:: General case forge.jar filenames for regular OLD Minecraft Forge newer (higher numbered) than 1.10.2
:: This will let non-specified special cases above slip though (weird unpopular versions).  Only a small percent of use cases will ever try them.
IF %OLDORNEW%==OLD IF !MINECRAFT! NEQ 1.6.4 IF !MINECRAFT! NEQ 1.7.10 IF !MINECRAFT! NEQ 1.8.9 IF !MINECRAFT! NEQ 1.9.4 IF !MINECRAFT! NEQ 1.10.2 (
%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% -jar forge-!MINECRAFT!-!FORGE!.jar nogui
) 


:: General case for NEW (1.17 and newer) Minecraft versions.  This remains unchanged at least until 1.19.3.
IF %OLDORNEW%==NEW (
%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% @libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/win_args.txt nogui %*
) 

:: Complains in console output if launch attempt crashes

IF %ERRORLEVEL% NEQ 0 (
  ECHO.
  ECHO.
  ECHO  SOMETHING CRASHED!
  ECHO.
  ECHO  CHECK LOG MESSAGES ABOVE IN CONSOLE, 'logs' FOLDER 'latest.log' FILE, OR 'crash-reports' FOLDERS
  ECHO.
  ECHO  ELSE POSSIBILITY --
  ECHO  IF YOU ARE SEEING THIS MESSAGE IT IS POSSIBLE YOUR COMBINATION OF JAVA / MINECRAFT / FORGE SETTINGS ARE NOT CORRECT TO FUNCTION.
  ECHO   TRY AGAIN AND TRY HARDER.  HAVE A NICE DAY.  GOOD LUCK WITH THAT.
)
PAUSE && EXIT [\B]
:: END FORGE MAIN SECTION



:fabricmain
:: BEGIN FABRIC MAIN SECTION

:: Skips installation if already present
IF EXIST fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar GOTO :launchfabric

:: Deletes existing core files and folders if this specific desired Fabric launch file not present.  This forces a fresh installation and prevents getting a mis-match of various minecraft and/or fabric version files conflicting.
IF NOT EXIST fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar (
  IF EXIST "%cd%\.fabric" RD /s /q "%cd%\.fabric\"
  IF EXIST "%cd%\libraries" RD /s /q "%cd%\libraries\"
  DEL *.jar
)

:: Pings the Fabric file server
  :fabricserverpingagain
  ping -n 3 maven.fabricmc.net >nul
  IF %ERRORLEVEL% NEQ 0 (
    CLS
    ECHO.
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
    ECHO.
    ECHO    Something went wrong downloading the Fabric Installer file.
    ECHO    Press any key to try again.
    PAUSE
    GOTO :fabricmain
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
    IF /i %INSTALLERVAL%==%fabricinstallerhecksum% (
      %JAVAFILE% -XX:+UseG1GC -jar fabric-installer.jar server -loader !FABRICLOADER! -mcversion !MINECRAFT! -downloadMinecraft
    ) ELSE (
      GOTO :fabricmain
    )
)
IF EXIST fabric-installer.jar DEL fabric-installer.jar
IF EXIST fabric-installer.jar.sha256 DEL fabric-installer.jar.sha256
IF EXIST fabric-server-launch.jar (
  RENAME fabric-server-launch.jar fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar
)

:launchfabric

::If eula.txt doens't exist yet 

SET RESPONSE=IDKYET
IF NOT EXIST eula.txt (
  CLS
  ECHO.
  ECHO Mojang's EULA has not yet been accepted. In order to run a Minecraft server, you must accept Mojang's EULA.
  ECHO Mojang's EULA is available to read at https://account.mojang.com/documents/minecraft_eula
  ECHO.
  ECHO   %yellow% If you agree to Mojang's EULA then type 'AGREE' %blue%
  ECHO.
  ECHO   %yellow% ENTER YOUR RESPONSE %blue%
  ECHO.
  SET /P RESPONSE=
)
IF /I !RESPONSE!==AGREE (
  ECHO.
  ECHO User agreed to Mojang's EULA.
  ECHO.
  ECHO eula=true> eula.txt
)
IF /I !RESPONSE! NEQ AGREE IF NOT EXIST eula.txt (
  GOTO :launchfabric
)
IF EXIST eula.txt (
  ECHO.
  ECHO eula.txt file found! ..
  ECHO.
)

:: Skips client only mods scanning if ASKMODSCHECK is not Y
IF /I %ASKMODSCHECK% NEQ Y GOTO :actuallylaunchfabric


REM BEGIN FABRIC client only mods scanning

:: Sets a variable to the current directory to use later.  In some niche cases it seems to work better than cd.
SET HERE="%cd%"

:: Prompt user to decide to scan for client only mods or not.  Either path will eventually set AUTOMODSCHECK==NO

:askcheckfabric
IF %ASKMODSCHECK%==Y (
  CLS
  ECHO.
  ECHO.
  ECHO   %yellow% WOULD YOU LIKE TO SCAN THE MODS FOLDER FOR MODS THAT ARE NEEDED ONLY ON CLIENTS? %blue%
  ECHO.
  ECHO   ----------------------------------------------------------------------------------
  ECHO.
  ECHO     --MANY MODS ARE NOT CODED PROPERLY TO SELF DISABLE ON SERVERS AND MAY CRASH THEM
  ECHO.
  ECHO     --THIS LAUNCHER CAN SCAN THE MODS FOLDER AND SEE IF ANY ARE PRESENT WHICH
  ECHO       ARE ON THE LAUNCHERS MASTER LIST OF CLIENT ONLY MODS.
  ECHO.
  ECHO.
  ECHO.
  ECHO.
  ECHO.
  ECHO.
  ECHO             %yellow% Please choose "Y" or "N" %blue%
  ECHO.
  SET /P DOSCAN=
  IF /I !DOSCAN!==N (
    GOTO :resetaskmodscheckfabric
  )
  )
  IF /I !DOSCAN! NEQ N IF /I !DOSCAN! NEQ Y (
    GOTO :askcheckfabric
  )

  IF EXIST rawidlist.txt DEL rawidlist.txt
  IF EXIST serveridlist.txt DEL serveridlist.txt

  ECHO.
  ECHO Searching for client mods . . .

  :: Goes to mods folder and gets file names lists.  FINDSTR prints only files with .jar found

  PUSHD mods
  dir /b /a-d > list1.txt
  FINDSTR ".jar" list1.txt > list2.txt
  SORT list2.txt > servermods.txt
  DEL list1.txt && DEL list2.txt
  POPD
  MOVE mods\servermods.txt servermods.txt >nul
  
  :: Extracts the fabric.mod.json file from each JAR
  :: Gets the list of ids from actual mod JAR files using servermods.txt for file names
  :: Saves corresponding file names and ids in variable array

  SET SERVCOUNT=0
  IF EXIST "fabric.mod.json" DEL "fabric.mod.json"
  IF EXIST "allfabricdeps.txt" DEL "allfabricdeps.txt"

  :: START SCANNING MODS

  REM Get total number of mods currently in mods folder
  SET rawmodstotal=0
  FOR /F "usebackq delims=" %%J IN (servermods.txt) DO (
    SET /a rawmodstotal+=1
  )

  REM BEGIN SCANNING ALL MOD JAR FILE fabric.mod.json

  SET modcount=0
  FOR /F "usebackq delims=" %%N IN (servermods.txt) DO (

    REM  Uses 7 zip to extract each fabric.mod.json which is then scanned
    "%cd%\java\7za.exe" e -aoa "mods\%%N" "fabric.mod.json" >nul

    SET /a modcount+=1
    ECHO SCANNING - !modcount!/!rawmodstotal! - %%N

    REM For ALL mods create list of dependency mods for later IDs comparison
    REM Save all special dependencies not fabric, minecraft, or java related to a single text file to sort and remove duplicates from later.
    
    IF EXIST "fabric.mod.json" (

      REM BEGIN BATCH script to process a JSON file to extract values from a property.
      REM In this case the property is 'depends' - It uses FOR loops to detect the beginning
      REM and end of the property to record all values to an output file.
      
      REM ---YES this can be done with one line in a powershell call - however when doing this to hundreds of files it's also 4-5x SLOWER compared to the following CMD / batch method.
      REM powershell -Command "$json=Get-Content -Raw -Path 'fabric.mod.json' | Out-String | ConvertFrom-Json; $json.depends.psobject.properties.name | Out-File -FilePath .\deps.txt" >nul

      SET jsonum=0
      REM Creates a pseudo-array containing the contents of the fabric.mod.json file but with double quotes replaced with hash/pound symbols for making life easier in BATCH searches. Because double quotes are special characters and hash/pound isn't.
      REM The variable jsonum keeps track of how many lines in the json there are, and sets up the pseudo-array number of each line.
      FOR /F "delims=" %%x IN ('type fabric.mod.json') DO (
              SET "tempvar=%%x"
              SET "fabricjson[!jsonum!]=!tempvar:"=#!"
              SET /a jsonum+=1
      )
      SET jsonnumber=!jsonum!
      :: Gets line number of the string 'depends' - by searching the pseudo-array from 0 to the total number of lines 'jsonnumber'.
      SET idg=0
      FOR /L %%T IN (0,1,!jsonnumber!) DO (
          FOR /F "delims=" %%T IN ("!fabricjson[%%T]!") DO (
              SET "tempvar=%%T"
              SET "tempvar3=!tempvar:depends=b!"
              IF "!tempvar!" NEQ "!tempvar3!" SET DEPHEIGHT=!idg!
              SET /a idg+=1
          )
      )
      :: Gets line number of } which is after 'depends' in the same type of method as the way depends was found.  If it gets recorded then done tag takes program out of the loop.
      SET idm=0
      SET FOUNDBRACKET=0
      FOR /L %%T IN (0,1,!jsonnumber!) DO (
          FOR /F "delims=" %%T IN ("!fabricjson[%%T]!") DO (
              SET "tempvar=%%T"
              SET "tempvar2=!tempvar:}=b!"
              IF !FOUNDBRACKET!==0 IF !idm! GTR !DEPHEIGHT! IF "!tempvar!" NEQ "!tempvar2!" (
                  SET BRACKET=!idm!
                  SET FOUNDBRACKET=1
              )
              SET /a idm+=1
          )
      )

      :: Takes the two heights and prints the values between the two
      FOR /L %%T IN (0,1,!jsonnumber!) DO (
          IF %%T GTR !DEPHEIGHT! IF %%T LSS !BRACKET! (
              FOR /F "tokens=2 delims=#" %%A IN ("!fabricjson[%%T]!") DO (
                      ECHO %%A>deps.txt
              )
          )
      )
      
      REM END BATCH SCRIPT parsing JSON file fabric.mod.json - It did it's job of pulling out the dependency mods to deps.txt

      REM For each deps.txt file write to text file the depedency mod ids for further processing later.  The list of IF NEQ conditions filters out some common ones that never need to be included - it cuts down on the text file size for later processing.
      FOR /F %%U IN ('type deps.txt') DO (
        IF /I %%U NEQ fabricloader IF /I %%U NEQ fabric IF /I %%U NEQ minecraft IF /I %%U NEQ java IF /I %%U NEQ cloth-config IF /I %%U NEQ cloth-config2 IF /I %%U NEQ fabric-language-kotlin IF /I %%U NEQ iceberg IF /I %%U NEQ fabric-resource-loader-v0 IF /I %%U NEQ creativecore IF /I %%U NEQ architectury (
          ECHO %%U>>allfabricdeps.txt
        )
      )

      REM Makes a temp file and checks to see if the environment entry was even found or not.
      FINDSTR \^"environment\^" "fabric.mod.json" >whichsided.txt
      FOR /F %%A IN ("whichsided.txt") DO IF %%~zA NEQ 0 (
        REM Figures out if the contents of non-empty whichsided.txt are equal to client or not.
        REM Changes quotes in data to hashmark symbol because easier to enter as delims in FOR loop.
        SET /p whichsided=<whichsided.txt
        SET whichsided=!whichsided:"=#!
        set idr=0
        FOR /F "tokens=4 delims=#" %%A IN ("!whichsided!") DO (
            set "environ[!idr!]=%%A"
            set /a idr+=1
        )
        IF /I !environ[0]!==client (
          REM Assumes now that this fabric.mod.json is a for a client mod and gets the id, then saves to holding variable array
          REM Because this is all going off of the mod file names list the results will be in order of file name alphabetization.
          FOR /F "delims=" %%A in ('FINDSTR \^"id\^" fabric.mod.json') DO SET "idstring=%%A"
          SET idstring=!idstring:"=#!
          SET ide=0
          FOR /F "tokens=4 delims=#" %%A IN ("!idstring!") DO (
            set "idvalue[!ide!]=%%A"
            set /a ide+=1
          )
          REM Creates a pseudo-array using the SERVCOUNT of each found client mod as array number.  This will now contain all of the found client mods by file name and mod ID.
          SET FABRICCLIENTS[!SERVCOUNT!].name=%%N
          SET FABRICCLIENTS[!SERVCOUNT!].id=!idvalue[0]!


          REM Adds 1 to the server client mods count.  This is to keep track of how many entries are done.
          SET /a SERVCOUNT+=1
    )))

    REM Deletes existing fabric.mod.json to ensure that the next unzip/extract attempt and subsequent looking for it will result in nothing if there is nothing in that next JAR file.
    IF EXIST fabric.mod.json DEL fabric.mod.json
  )


  SET TOTCLIENTCOUNT=!SERVCOUNT!

  :: Skips bothering to compare dependency lists of all mods vs client IDs and user report if no client mods found.
  IF [!FABRICCLIENTS[0].name!]==[] (
    GOTO :noclientsfabric
  )

  :: Processes allfabricdeps.txt and compares to list of client mods
  IF EXIST allfabricdepssorted.txt DEL allfabricdepssorted.txt
  IF EXIST actualdeps.txt DEL actualdeps.txt

  SORT allfabricdeps.txt > allfabricdepssorted.txt
  SET prevline=blank
  FOR /F "usebackq delims=" %%a IN (allfabricdepssorted.txt) DO (
    IF /I %%a NEQ !prevline! (
      ECHO %%a>>actualdeps.txt
      SET prevline=%%a
    )
  )

  SET ifinal=0
  SET ISITADEP=0
  
  FOR /L %%T IN (0,1,%TOTCLIENTCOUNT%) DO (
    FOR /F "usebackq delims=" %%b IN (actualdeps.txt) DO (
      IF /I "%%b" EQU "!FABRICCLIENTS[%%T].id!" SET ISITADEP=1
    )
    IF !ISITADEP! EQU 0 (
      SET "FINALFABRICCLIENTS[!ifinal!].name=!FABRICCLIENTS[%%T].name!"
      SET "FINALFABRICCLIENTS[!ifinal!].id=!FABRICCLIENTS[%%T].id!"
      SET /a ifinal+=1
    )
    SET /a ISITADEP=0
  )
  SET finalcount=!ifinal!
  IF EXIST actualdeps.txt DEL actualdeps.txt
  IF EXIST allfabricdeps.txt DEL allfabricdeps.txt
  IF EXIST allfabricdepssorted.txt DEL allfabricdepssorted.txt
  IF EXIST deps.txt DEL deps.txt
  IF EXIST servermods.txt DEL servermods.txt
  IF EXIST whichsided.txt DEL whichsided.txt

  REM Prints report to user - echos all entries without the modID name = forge
  CLS
  ECHO.
  ECHO.
  ECHO   %yellow% THE FOLLOWING FABRIC - CLIENT MARKED MODS WERE FOUND %blue%
  ECHO.
  ECHO.
  ECHO    ------------------------------------------------------
  REM Prints to the screen all of the values in the array that are not equal to forge or null
  FOR /L %%T IN (0,1,%finalcount%) DO (
    IF /I "!FINALFABRICCLIENTS[%%T].name!" NEQ "" (
    ECHO        !FINALFABRICCLIENTS[%%T].name! - !FINALFABRICCLIENTS[%%T].id!
    )
  )
  ECHO    ------------------------------------------------------
  ECHO.
  ECHO.
  ECHO.
  ECHO.
  ECHO   %yellow% *** DO YOU WANT TO MOVE THESE CLIENT MODS TO A DIFFERENT FOLDER FOR SAFE KEEPING? *** %blue%
  ECHO.
  ECHO         If "Y" they will NOT be deleted - they WILL be moved to a new folder in the server named CLIENTMODS
  ECHO         SOME CLIENT MODS ARE NOT CODED TO SELF DISABLE AND WILL CRASH SERVERS IF LEFT IN THE MODS FOLDER
  ECHO.
  :typo
  ECHO.
  ECHO    ------------------------------------------------------
  ECHO.
  ECHO       %yellow% ENTER YOUR RESPONSE - "Y" OR "N" %blue%
  ECHO.
  SET /P MOVEMODS=
  IF /I !MOVEMODS!==N GOTO :resetaskmodscheckfabric
  IF /I !MOVEMODS!==Y (
    IF NOT EXIST "%cd%\CLIENTMODS" (
      MD CLIENTMODS
      )
      ) ELSE GOTO :typo
  :: Moves files if MOVEMODS is Y.  Checks to see if the value of the array is null for each spot.
  CLS
  ECHO.
  ECHO.
  FOR /L %%L IN (0,1,%finalcount%) DO (
    IF "!FINALFABRICCLIENTS[%%L].name!" NEQ "" (
    MOVE "%cd%\mods\!FINALFABRICCLIENTS[%%L].name!" "%cd%\CLIENTMODS\!FINALFABRICCLIENTS[%%L].name!" >nul
    ECHO   MOVED - !FINALFABRICCLIENTS[%%L].name! - to - %cd%\CLIENTMODS
    )
  )
  ECHO.
  ECHO        %yellow% CLIENT MODS MOVED! ... %blue%
  ECHO       -PRESS ANY KEY TO CONTINUE-
  ECHO.
  PAUSE
  
GOTO :resetaskmodscheckfabric

:noclientsfabric
CLS
ECHO.
ECHO.
ECHO   %yellow% ----------------------------------------- %blue%
ECHO   %yellow%     NO CLIENT ONLY MODS FOUND             %blue%
ECHO   %yellow% ----------------------------------------- %blue%
ECHO.
ECHO    PRESS ANY KEY TO CONTINUE...
ECHO.

PAUSE

:resetaskmodscheckfabric

:: Resets the settings-universalator.txt file so that it won't ask to scan mods next run.
REM User can change config from NO to YES to rescan next run.
powershell -Command "$content = Get-Content -Path '%HERE%\settings-universalator.txt'; $newContent = $content -replace 'SET ASKMODSCHECK=Y', 'SET ASKMODSCHECK=N'; $newContent | Set-Content -Path '%HERE%\settings-universalator.txt'"

:skipcheck
IF EXIST whichsided.txt DEL whichsided.txt

REM END FABRIC client only mods scanning

:actuallylaunchfabric

:: FINALLY LAUNCH FORGE SERVER!

CLS
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO            %yellow%   Universalator - Server launcher script    %blue%
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ECHO.
ECHO   %yellow% READY TO LAUNCH FABRIC SERVER! %blue%
ECHO.
ECHO        CURRENT SERVER SETTINGS:
ECHO        MINECRAFT - !MINECRAFT!
ECHO        FABRIC LOADER - !FABRICLOADER!
ECHO        JAVA - !JAVAVERSION!
ECHO.
ECHO.
ECHO ============================================
ECHO   %yellow% CURRENT NETWORK SETTINGS:%blue%
ECHO.
ECHO   %yellow% PUBLIC IPv4 AND PORT ADDRESS - %PUBLICIP%:%PORT% %blue%
ECHO        --THIS IS WHAT CLIENTS OUTSIDE THE CURRENT ROUTER NETWORK USE TO CONNECT
ECHO        --PORT FORWARDING MUST BE SET UP IN YOUR NETWORK ROUTER
ECHO.
ECHO   INTERNAL IPv4 ADDRESS - ENTER 'ipconfig' FROM A COMMAND PROMPT
ECHO        --THIS IS WHAT CLIENTS INSIDE THE CURRENT ROUTER NETWORK USE TO CONNECT
ECHO        --THE WORD 'localhost' WORKS FOR CLIENTS ON SAME COMPUTER
ECHO.
ECHO ============================================
ECHO.
ECHO.
ECHO   %yellow% PRESS ANY KEY TO START SERVER LAUNCH %blue%
ECHO.
PAUSE

%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% -jar fabric-server-launch-!MINECRAFT!-!FABRICLOADER!.jar nogui

PAUSE
