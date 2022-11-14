@ECHO OFF
setlocal enabledelayedexpansion

:: ----------------------------------------------
:: SET MODE below sets which mode the BAT file will operate on (read below)

:: Set to =AUTO to bypass/not create and use a settings.txt file for the user.
    :: While set to AUTO the launcher/installer will use the values entered here in the BAT file.

:: Set to =MANUAL to generate and use a settings.txt.
    ::  While set to MANUAL, if no settings.txt exists yet -  on running it will prompt user with a UI for what settings to use.

    SET MODE=AUTO
:: ------------------------------------------------

:: NOTES -- README -- NOTES -- README
   :: Minecraft 1.6.4 to 1.16.4 must be run with Java 8
   :: Minecraft 1.16.5 will run with Java 8.  It MIGHT run with java 11 - that requires the newest Forge version of it, and all mods present must be compatible.
   :: Minecraft 1.17 must be run with Java 16
   :: Minecraft 1.18+ must be run with Java 17 and newer.  Newer versions such as 18,19 etc. MAY or MAY NOT work depending on mods and Forge version.
   :: If you're that one person trying to load 1.6.4 (not a typo)- you need to include the mod 'legacy java fixer'.  Web serach for it.
   :: Set MAXRAMGIGS value to the maximum amount of RAM (memory) that will be allocated if the game requests it - (It gets turned into -Xmx later on inside the script.) - example: 6 

:: ENTER DEFAULT USED VALUES BELOW
     SET MINECRAFT=1.16.5
     SET FORGE=39.2.39
     SET JAVAVERSION=8
     SET MAXRAMGIGS=6


:: Enter other custom JVM arguments in ARGS
     SET ARGS=-XX:+IgnoreUnrecognizedVMOptions -XX:+UseG1GC -XX:+DisableExplicitGC -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -XX:SurvivorRatio=32 -XX:MaxGCPauseMillis=100 -XX:GCPauseIntervalMillis=150 -XX:TargetSurvivorRatio=90 -XX:+UseFastAccessorMethods -XX:+UseCompressedOops -XX:ReservedCodeCacheSize=2048m -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:+AlwaysPreTouch -XX:InitiatingHeapOccupancyPercent=15 -XX:G1NewSizePercent=30 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20


















:: DO NOT EDIT INFORMATION BELOW - SCRIPT FILE (WILL PROBABLY) BREAK















SET MAXRAM=-Xmx%MAXRAMGIGS%G

IF %MODE% NEQ AUTO IF %MODE% NEQ MANUAL (
    ECHO SET MODE= is set incorrectly in BAT file.
    ECHO This setting MUST be set to AUTO or MANUAL.
    PAUSE && EXIT [\B]
)
IF %MODE%==AUTO GOTO :autoskipmanual
IF %MODE%==MANUAL IF EXIST settings.txt GOTO :manualskipsettings
:tryagain
ECHO THESE ARE THE DEFAULT SETTINGS FOR THIS FILE
ECHO .
ECHO MINECRAFT VERSION = !MINECRAFT!
ECHO FORGE VERSION ===== !FORGE!
ECHO JAVA VERSION ===== !JAVAVERSION!
ECHO .
ECHO SERVER MAX RAM VALUE = !MAXRAMGIGS! gigabytes
ECHO .
ECHO DOES THIS LOOK GOOD?
ECHO "Y" = USE VALUES TO INSTALL AND LAUNCH
ECHO "N" = CHANGE VALUES
ECHO .
ECHO (After running the first time - further settings changes are done by editing settings.txt which gets generated)
ECHO (To reset settings.txt delete the file and run BAT again.)
ECHO .
set /P "LOOKSGOOD=" 
IF !LOOKSGOOD! NEQ Y IF !LOOKSGOOD! NEQ N GOTO :tryagain
IF !LOOKSGOOD!==Y GOTO :manualskipsettingsentry
:startover
ECHO .
ECHO ENTER THE MINECRAFT VERSION
ECHO example: 1.7.10
ECHO example: 1.16.5
ECHO example: 1.19.2
ECHO .
SET /P MINECRAFT=

:usedefaulttryagain
SET USEDEFAULT=IDK
IF !MINECRAFT!==1.7.10 (
  ECHO YOU HAVE ENTERED 1.7.10 WHICH IS A POPULAR VERSION
  ECHO WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO .
  ECHO FORGE = 10.13.4.1614
  ECHO JAVA = 8  **JAVA MUST BE 8**
  ECHO ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF %USEDEFAULT%==Y (
  SET FORGE=10.13.4.1614
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.8.9 (
  ECHO YOU HAVE ENTERED 1.8.9 WHICH IS A POPULAR VERSION
  ECHO WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO .
  ECHO FORGE = 11.15.1.2318
  ECHO JAVA = 8  **JAVA MUST BE 8**
  ECHO ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF %USEDEFAULT%==Y (
  SET FORGE=11.15.1.2318
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.10.2 (
  ECHO YOU HAVE ENTERED 1.10.2 WHICH IS A POPULAR VERSION
  ECHO WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO .
  ECHO FORGE = 12.18.3.2511
  ECHO JAVA = 8  **JAVA MUST BE 8**
  ECHO ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF %USEDEFAULT%==Y (
  SET FORGE=12.18.3.2511
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.10.2 (
  ECHO YOU HAVE ENTERED 1.10.2 WHICH IS A POPULAR VERSION
  ECHO WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO .
  ECHO FORGE = 12.18.3.2511
  ECHO JAVA = 8  **JAVA MUST BE 8**
  ECHO ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF %USEDEFAULT%==Y (
  SET FORGE=12.18.3.2511
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.12.2 (
  ECHO YOU HAVE ENTERED 1.12.2 WHICH IS A POPULAR VERSION
  ECHO WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO .
  ECHO FORGE = 14.23.5.2860
  ECHO JAVA = 8  **JAVA MUST BE 8**
  ECHO ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF %USEDEFAULT%==Y (
  SET FORGE=14.23.5.2860
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !MINECRAFT!==1.16.5 (
  ECHO YOU HAVE ENTERED 1.16.5 WHICH IS A POPULAR VERSION
  ECHO WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSION OF FORGE?
  ECHO .
  ECHO FORGE = 36.2.39
  ECHO .
  ECHO ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF %USEDEFAULT%==Y (
  SET FORGE=36.2.39
  GOTO :gojava
)
IF !MINECRAFT!==1.17.1 (
  ECHO YOU HAVE ENTERED 1.17.1 WHICH IS A POPULAR VERSION
  ECHO WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO .
  ECHO FORGE = 37.1.1
  ECHO JAVA = 16  **JAVA MUST BE 16**
  ECHO ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF %USEDEFAULT%==Y (
  SET FORGE=37.1.1
  SET JAVAVERSION=16
  GOTO :goramentry
)
IF !MINECRAFT!==1.18.2 (
  ECHO YOU HAVE ENTERED 1.18.2 WHICH IS A POPULAR VERSION
  ECHO WOULD YOU LIKE TO USE THE DEFAULT RECOMMENDED VERSIONS OF FORGE AND JAVA?
  ECHO .
  ECHO FORGE = 40.1.84
  ECHO JAVA = 17  **JAVA CAN BE 17, 18, 19**
  ECHO            **JAVA NEWER THAN 17 MAY NOT WORK DEPENDING ON MODS BEING LOADED*
  ECHO ENTER "Y" OR "N"
  SET /P "USEDEFAULT="
)
IF %USEDEFAULT%==Y (
  SET FORGE=40.1.84
  SET JAVAVERSION=8
  GOTO :goramentry
)
IF !USEDEFAULT! NEQ Y IF !USEDEFAULT! NEQ N GOTO :usedefaulttryagain
IF !USEDEFAULT!==Y GOTO :manualskipsettings
IF !USEDEFAULT!==N (
  ECHO ENTER FORGE VERSION
  ECHO example: 14.23.5.2860
  ECHO example: 40.1.84
  ECHO .
  SET /P FORGE=
)
:gojava
IF !USEDEFAULT!==N (
  ECHO ENTER JAVA VERSION
  ECHO .
  ECHO ONLY VERSIONS AVAILABLE - 8, 11, 16, 17, 18, 19
  ECHO .
  SET /P JAVAVERSION=
)
IF !USEDEFAULT!==Y IF !MINECRAFT!==1.16.5 (
  :fix8or11
  ECHO ENTER JAVA VERSION
  ECHO .
  ECHO ONLY VERSIONS AVAILABLE THAT WORK WITH MINECRAFT / FORGE 1.16.5 ARE 8 AND 11
  ECHO USING JAVA 11 MAY NOT WORK DEPENDING ON MODS BEING LOADED
  ECHO .
  SET /P JAVAVERSION=
)
IF !MINECRAFT!==1.16.5 IF !JAVAVERSION! NEQ 8 IF !JAVAVERSION! NEQ 11 GOTO :fix8or11
:goramentry
IF !USEDEFAULT!==N (
  :specialram
  ECHO ENTER MAXIMUM RAM / MEMORY THAT THE SERVER WILL RUN - IN GIGABYTES
  ECHO BE SURE IT IS NOT TOO MUCH FOR YOUR COMPUTER!
  ECHO TYPICAL VALUES FOR MODDED MINECRAFT SERVERS ARE BETWEEN 4 AND 10
  ECHO .
  ECHO .
  SET /P MAXRAMGIGS=
) ELSE IF !MINECRAFT!==1.16.5 GOTO :specialram
:notgood
ECHO .
ECHO DO THESE VALUES YOU ENTERED LOOK GOOD?
ECHO .
ECHO MINECRAFT - !MINECRAFT!
ECHO FORGE ----- !FORGE!
ECHO JAVA ------ !JAVAVERSION!
ECHO MAXRAM ---- !MAXRAMGIGS!
ECHO .
ECHO . "Y" or "N"
ECHO .
SET /P "LOOKSGOOD2="
IF !LOOKSGOOD2! NEQ Y IF !LOOKSGOOD2! NEQ N GOTO :notgood
IF !LOOKSGOOD2!==N GOTO :startover
:manualskipsettingsentry
:manualskipsettings



IF NOT EXIST settings.txt (
    ECHO :: To reset this file - delete and run launcher again.>settings.txt
    ECHO ::>>settings.txt
    ECHO :: SET MINECRAFT VERSION BELOW - example: MINECRAFT=1.18.2 >>settings.txt
    ECHO SET MINECRAFT=!MINECRAFT!>>settings.txt
    ECHO ::>>settings.txt
    ECHO :: SET FORGE VERSION BELOW - example: FORGE=40.1.84 >>settings.txt
    ECHO SET FORGE=!FORGE!>>settings.txt
    ECHO ::>>settings.txt
    ECHO :: SET JAVA VERSION BELOW - MUST BE 8, 11, 16, 17, 18, or 19 >>settings.txt
    ECHO SET JAVAVERSION=!JAVAVERSION!>>settings.txt
    ECHO ::>>settings.txt
    ECHO :: SET MAXIMUM RAM VALUE IN GIGABYTES - example: 6 >>settings.txt
    ECHO SET MAXRAMGIGS=!MAXRAMGIGS!>>settings.txt
)
IF EXIST settings.txt (
RENAME settings.txt settings.bat && CALL settings.bat && RENAME settings.bat settings.txt
)
SET MAXRAM=-Xmx!MAXRAMGIGS!G



:autoskipmanual

SET OTHERARGS=-Dlog4j2.formatMsgNoLookups=true

ECHO BELOW ARE ENTERED VALUES IN FILE SETTINGS
ECHO TO CHANGE EDIT FILE WITH ANY TEXT EDITOR
ECHO ------------------------------------
ECHO MINECRAFT VERSION: !MINECRAFT!
ECHO FORGE VERSION:     !FORGE!
ECHO JAVA VERSION:      !JAVAVERSION!
ECHO .


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

IF %OLDORNEW%==IDK (
    ECHO INVALID MINECRAFT VERSION ENTERED IN VALUES
    PAUSE && EXIT [\B]
)





::Stores values in variables depending on Java version entered
SET JAVAGOOD="bad"

IF !JAVAVERSION!==8 (
    SET JAVAFILENAME="jdk8u352-b08/OpenJDK8U-jre_x64_windows_hotspot_8u352b08.zip"
    SET JAVAFOLDER="java\jdk8u352-b08-jre\."
    SET checksumeight=072986277701a967e15bf4c4be0c15a69fda00ab973e5e69e62b0f078d6614a4
    SET JAVAFILE="java\jdk8u352-b08-jre\bin\java.exe"
    SET JAVAGOOD="good"
)
IF !JAVAVERSION!==11 (
    SET JAVAFILENAME="jdk-11.0.17%%2B8/OpenJDK11U-jre_x64_windows_hotspot_11.0.17_8.zip"
    SET JAVAFOLDER="java\jdk-11.0.17+8-jre\."
    SET checksumeight=814a731f92dd67ad6cfb11a8b06dfad5f629f67be88ae5ae37d34e6eea6be6f4
    SET JAVAFILE="java\jdk-11.0.17+8-jre\bin\java.exe"
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
    SET JAVAFILENAME="jdk-17.0.4.1%%2B1/OpenJDK17U-jre_x64_windows_hotspot_17.0.4.1_1.zip"
    SET JAVAFOLDER="java\jdk-17.0.4.1+1-jre\."
    SET checksumeight=10b007eb1b424a83729e335917a4851e426d716349439aef71d63bbcba24b702
    SET JAVAFILE="java\jdk-17.0.4.1+1-jre\bin\java.exe"
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
    SET JAVAFILENAME="jdk-19.0.1%%2B10/OpenJDK19U-jre_x64_windows_hotspot_19.0.1_10.zip"
    SET JAVAFOLDER="java\jdk-19.0.1+10-jre\."
    SET checksumeight=5c156165df5f0685da8a6dc0a2dab7f82feae1ff4a25b511b1ff64344a9833f6
    SET JAVAFILE="java\jdk-19.0.1+10-jre\bin\java.exe"
    SET JAVAGOOD="good"
)

:: Checks to see if the Java version entered is available
IF %JAVAGOOD%=="bad" (
  ECHO .
  ECHO THE JAVA VERSION YOU ENTERED IN SETTINGS IS NOT AVAILABLE FOR THIS LAUNCHER
  ECHO AVAILABLE VERSIONS ARE = 8, 11, 16, 17, 19
  ECHO .
  PAUSE && EXIT [\B]
)

:: Checks to see if Minecraft version and Java version in settings are compatible
IF %OLDORNEW%==OLD IF %JAVAGOOD%=="good" IF !MINECRAFT! NEQ 1.16.5 IF !JAVAVERSION! NEQ 8 (
  ECHO MINECRAFT 1.16.4 AND OLDER MUST USE JAVA 8 ONLY - FIX YOUR SETTINGS
  PAUSE && EXIT [\B]
)
IF %OLDORNEW%==OLD IF %JAVAGOOD%=="good" IF !MINECRAFT!==1.16.5 IF !JAVAVERSION! NEQ 8 (
  IF !JAVAVERSION! NEQ 11 (
  ECHO MINECRAFT 1.16.5 MUST USE JAVA 8 OR 11 - FIX YOUR SETTINGS
  PAUSE && EXIT [\B]
))
IF %OLDORNEW%==NEW IF %MINECRAFT:~3,1%==7 IF %JAVAGOOD%=="good" IF !JAVAVERSION! NEQ 16 (
  ECHO MINECRAFT 1.17.x MUST USE JAVA 16 - FIX YOUR SETTINGS
  PAUSE && EXIT [\B]
)
IF %OLDORNEW%==NEW IF !MINECRAFT! NEQ 1.17 IF %JAVAGOOD%=="good" IF !JAVAVERSION!==8 (
  ECHO MINECRAFT 1.18.x AND NEWER MUST USE JAVA 17+  - FIX YOUR SETTINGS
  PAUSE && EXIT [\B]
)
IF %OLDORNEW%==NEW IF %MINECRAFT:~3,1% NEQ 7 IF %JAVAGOOD%=="good" IF !JAVAVERSION!==16 (
  ECHO MINECRAFT 1.18.x AND NEWER MUST USE JAVA 17+  - FIX YOUR SETTINGS
  ECHO %MINECRAFT:~3,1%
  PAUSE && EXIT [\B]
)

SET FRESHRUN=YES
IF EXIST mods\. (
  SET FRESHRUN=NO
)
SET NEWRESPONSE= Y
IF !FRESHRUN! NEQ NO (
  :loop
  ECHO .
  ECHO .
  ECHO .
  ECHO .
  ECHO .
  ECHO NO MODS FOLDER WAS DETECTED IN THIS DIRECTORY YET - ARE YOU SURE YOU WANT TO CONTINUE?
  ECHO .
  ECHO --- IF "Y" PROGRAM WILL INSTALL BUT NOT RUN SERVER
  ECHO     AFTER INSTALLATION COMPLETE INCLUDE MODS FOLDER AND OTHER CUSTOM FILES AND THEN RUN LAUNCHER AGAIN
  ECHO .
  ECHO --- IF "N" PROGRAM WILL EXIT
  ECHO .
  ECHO TYPE YOUR RESPONSE AND PRESS ENTER:
  set /P "NEWRESPONSE=" 
  )
IF !NEWRESPONSE! == N (
  ECHO CLOSING
  PAUSE && EXIT
)
IF %NEWRESPONSE% NEQ Y GOTO :loop


:: Downloads java binary file
IF NOT EXIST java.zip IF NOT EXIST %JAVAFOLDER% (
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/adoptium/temurin!JAVAVERSION!-binaries/releases/download/%JAVAFILENAME%', 'java.zip')"
) ELSE (
    echo Java installation already exists
)

:: Gets the checksum hash of the downloaded java biniary file
set idx=0 
IF EXIST java.zip (
for /f %%F  in ('certutil -hashfile java.zip SHA256') do (
    set "out!idx!=%%F"
    set /a idx += 1
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
powershell -Command "Expand-Archive java.zip"
) && DEL java.zip && echo Downloaded Java binary and stored hashfile match values - file is valid
)
IF EXIST java.zip IF %checksumeight% NEQ %filechecksum% (
  ECHO THE JAVA INSTALLATION FILE DID NOT DOWNLOAD CORRECTLY - PLEASE TRY AGAIN
  DEL java.zip && PAUSE && EXIT [\B]
)

:: Downloads the Minecraft server JAR if version is = OLD and does not exist.  Some old Forge installer files point to dead URL links for this file.  This gets ahead of that and gets it first.
IF %OLDORNEW%==OLD IF NOT EXIST minecraft_server.!MINECRAFT!.jar (
powershell -Command "(New-Object Net.WebClient).DownloadFile(((Invoke-RestMethod -Method Get -Uri ((Invoke-RestMethod -Method Get -Uri "https://launchermeta.mojang.com/mc/game/version_manifest_v2.json").versions | Where-Object -Property id -Value !MINECRAFT! -EQ).url).downloads.server.url), 'minecraft_server.!MINECRAFT!.jar')"
)

:: Pings the Forge files server to see it can be reached
IF %OLDORNEW%==OLD IF NOT EXIST forge-!MINECRAFT!-!FORGE!.jar (
ping -n 1 maven.minecraftforge.net >nul
IF %ERRORLEVEL% NEQ 0 (
  ECHO A PING TO THE FORGE FILE SERVER HAS FAILED
  ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
  ECHO TRY AGAIN LATER
  PAUSE && EXIT [\B]
))
IF %OLDORNEW%==NEW IF NOT EXIST libraries\net\minecraftforge\forge\!MINECRAFT!-!FORGE!\. (
ping -n 1 maven.minecraftforge.net >nul
IF %ERRORLEVEL% NEQ 0 (
  ECHO A PING TO THE FORGE FILE SERVER HAS FAILED
  ECHO EITHER YOUR CONNECTION IS POOR OR THE FILE SERVER IS OFFLINE
  ECHO TRY AGAIN LATER
  PAUSE && EXIT [\B]
))
::IF %ERRORLEVEL% 0 ECHO PING TO FORGE FILE SERVER SUCCESSFUL

:: NEW INSTALLER

IF %OLDORNEW%==OLD (
  IF NOT EXIST forge-!MINECRAFT!-!FORGE!.jar (
    IF !MINECRAFT! NEQ 1.7.10 (
    ECHO Forge Server JAR-file not found. Downloading installer...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')"
)))

IF %OLDORNEW%==OLD IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar IF !MINECRAFT!==1.7.10 (
  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!-!MINECRAFT!/forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-installer.jar', 'forge-installer.jar')"
)

IF %OLDORNEW%==NEW IF NOT EXIST libraries\net\minecraftforge\forge\!MINECRAFT!-!FORGE!\. (

  ECHO Forge Server JAR-file not found. Downloading installer...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://maven.minecraftforge.net/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/forge-!MINECRAFT!-!FORGE!-installer.jar', 'forge-installer.jar')"
)

IF %ERRORLEVEL% NEQ 0 (
    ECHO forge-installer.jar not found. Maybe the Forges servers are having trouble.
    ECHO Please try again in a couple of minutes.
    ECHO .
    ECHO THIS COULD ALSO MEAN YOU HAVE INCORRECT MINECRAFT OR FORGE VERSIONS ENTERED - CHECK THEM
    PAUSE && EXIT [\B]
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
)
IF EXIST libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/. (
  ECHO Detected Installed Forge !FORGE!. Moving on...
)
IF NOT EXIST forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar (
  IF NOT EXIST forge-!MINECRAFT!-!FORGE!.jar (
    IF NOT EXIST libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/. (
      ECHO THE FORGE INSTALLATION FILE DID NOT DOWNLOAD OR INSTALL CORRECTLY - PLEASE TRY AGAIN
      PAUSE && EXIT [\B]
)))
IF %OLDORNEW%== NEW IF %INSTALLEDFORGE%== YES (
      DEL run.bat && DEL run.sh && DEL user_jvm_args.txt
)


::If eula.txt doens't exist yet 
IF NOT EXIST eula.txt (
  ECHO .
  ECHO Mojang's EULA has not yet been accepted. In order to run a Minecraft server, you must accept Mojang's EULA.
  ECHO Mojang's EULA is available to read at https://account.mojang.com/documents/minecraft_eula
  ECHO If you agree to Mojang's EULA then type "I agree"

  set /P "Response="
  IF "%Response%" == "%AGREE%" (
    ECHO User agreed to Mojang's EULA.
    ECHO #By changing the setting below to TRUE you are indicating your agreement to our EULA ^(https://account.mojang.com/documents/minecraft_eula^).> eula.txt
    ECHO eula=true>> eula.txt
  ) ELSE (
    ECHO User did not agree to Mojang's EULA. 
  )
) ELSE (
  ECHO eula.txt present. Moving on...
)

IF %FRESHRUN%== YES (
    ECHO .
    ECHO INSTALLATION COMPLETE - INCLUDE MODS FOLDER AND ANY OTHER CUSTOM FILES THEN RUN LAUNCHER AGAIN
    PAUSE && EXIT [\B]
) ELSE ECHO STARTING FORGE...

:: Starts forge depending on what java version is set.  Only correct combinations will launch - others will crash.
IF %OLDORNEW%==OLD IF !MINECRAFT!==1.7.10 (
%JAVAFILE% -server !MAXRAM! %ARGS% %OTHERARGS% -jar forge-!MINECRAFT!-!FORGE!-!MINECRAFT!-universal.jar nogui
) 

IF %OLDORNEW%==OLD IF !MINECRAFT! NEQ 1.7.10 (
%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% -jar forge-!MINECRAFT!-!FORGE!.jar nogui
) 

IF %OLDORNEW%==NEW (
%JAVAFILE% !MAXRAM! %ARGS% %OTHERARGS% @libraries/net/minecraftforge/forge/!MINECRAFT!-!FORGE!/win_args.txt nogui %*
) 

:: Complains in console output if launch attempt crashes
IF %ERRORLEVEL% NEQ 0 (
  ECHO .
  ECHO .
  ECHO .
  ECHO IF YOU ARE SEEING THIS MESSAGE IT IS LIKELY YOUR COMBINATION OF JAVA / MINECRAFT / FORGE IS NOT COMPATIBLE.
  ECHO TRY AGAIN AND TRY HARDER.  HAVE A NICE DAY.  GOOD LUCK WITH THAT.
)

PAUSE