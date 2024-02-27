#!/usr/bin/env bash

#    The Universalator Linux / MacOS edition - Modded Minecraft Server Installation / Launching Program.
#    Copyright (C) <2023>  <Kerry Sherwin>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see https://www.gnu.org/licenses/.




# README BELOW -- NOTES -- README -- NOTES
# ----------------------------------------------
    # -TO USE THIS SCRIPT:
    #    CREATE A NEW FOLDER FOR YOUR SERVER FILES
    #    IN THAT FOLDER PLACE THIS SCRIPT FILE, THE MODS FOLDER AND ANY OTHER SPECIAL FOLDERS/FILES FROM AN EXISTING MODPACK OR CUSTOM PROFILE OR SERVER.
    #
    #    RUN THIS SCRIPT FILE WITH BASH - DO NOT RUN AS ROOT OR ADMIN (SUDO)
    #         example: 'bash Universalator-linux.sh'
    #
# ------------------------------------------------
# README ABOVE -- NOTES -- README -- NOTES






# Color variables for later use
blue=$'\e[1;33m\e[44m'; yellow=$'\e[1;34m\e[1;103m'; yellowtext=$'\e[1;33m\e[1;40m'; green=$'\e[1;93m\e[1;42m'; red=$'\e[1;93m\e[1;101m'; lty=$'\e[1;33m'; norm=$'\e[0m';


# Check for the existence of bash installation - this check should be POSIX compliant.
[ `command -v bash` ] || { 
    printf "\n   $lty Uh oh - looks like 'bash' is not installed on your operating system.$norm \n\n   $lty The Universalator script for linux/OSX requires that bash be installed.$norm \n\n   $lty It is suggested to web-search for tutorials on how to install 'bash' for your operating system type! $norm \n\n";
    read -n1 -r -p "Press any key to continue...";
    exit 0;
}

# Bash version check - Gives an warning to install a newer version of bash if the major version is less than 5
if [[ "${BASH_VERSINFO[0]}" -le 4 ]]; then
    printf "\n   $lty ERROR: Bash 4.0+ is required for this script to work correctly. $norm \n\n   $lty It is suggested to web-search for tutorials on how to update bash on your operating system. $norm \n   $lty If you do install a newer version of bash - be sure you then set that new verison as default! $norm \n\n";
    read -n1 -r -p "Press any key to continue..." key;
    exit 0;
fi

# Checks if user tried to run the script using sudo / root.
[[ `whoami` == "root" ]] && { printf "\n\n   $lty Running a Minecraft server as root is dangerous. $norm\n   $lty Please run this script without sudo. $norm\n\n"; exit 0; }
[[ "$EUID" == "0" ]] && { printf "\n\n   $lty Running a Minecraft server as root is dangerous. $norm\n   $lty Please run this script without sudo. $norm\n\n"; exit 0; }

# Checks if any parameters were passed to the file launch command
[[ "${1}" != "" ]] && { 
    [[ "${1}" == "help" ]] && param1="help" 
    [[ "${1}" == "restart" ]] && param1="restart"
}

# SYSTEM CHECKUPS

    # Tries to find the distro type of the operating system - for the sake of explaining which type of install commands to use if necessary, for any missing utility programs.
    [[ -f "/etc/os-release" ]] && id_like=`grep -ioP '^ID_LIKE=\K.+' /etc/os-release` || id_like="idk"; id_like="${id_like,,}"

    if [[ `echo "$id_like" | fgrep "debian"` ]]; then
        distro_like="debian"
    elif [[ `echo "$id_like" | fgrep "arch"` ]]; then
        distro_like="arch"
    elif [[ `echo "$id_like" | fgrep "fedora"` ]]; then
        distro_like="fedora"
    else 
        id_like=`uname -s`
        [[ "${id_like,,}" == "darwin" ]] && distro_like="macos" || distro_like="linux"
    fi

    # Checks to see if there are any missing utility program commands.  If any are not found then whichever is recorded last is displayed.
    missing_util="u"
    if [[ ! `command -v xmlstarlet` ]]; then missing_util="xmlstarlet"; missing_lang="XML file parsing"; fi
    if [[ ! `command -v jq` ]]; then missing_util="jq"; missing_lang="JSON file parsing"; fi
    if [[ ! `command -v curl` ]]; then missing_util="curl"; missing_lang="download"; fi

    if [[ "$missing_util" != "u" ]]; then
        printf "\n   $lty Uh oh - it appears that '$missing_util', is not installed on your operating system. $norm\n   $lty This script for Linux/OSX requires that '$missing_util', a $missing_lang utility program, be installed. $norm\n\n"
        [[ "$distro_like" == "debian" ]] && printf "   $lty Your OS appears to be a 'debian' based linux distribution. $norm \n   $lty If you have the APT package manager you should be able to install with the following commands: $norm\n\n       $lty sudo apt update $norm \n       $lty sudo apt upgrade $norm \n       $lty sudo apt install $missing_util $norm \n"
        [[ "$distro_like" == "arch" ]] && printf "   $lty Your OS appears to be an 'arch' based linux distribution. $norm \n   $lty If you have the 'pacman' package manager you should be able to install with the following commands: $norm\n\n       $lty sudo pacman -Sy $norm \n       $lty sudo pacman -S $missing_util $norm \n"
        [[ "$distro_like" == "fedora" ]] && printf "   $lty Your OS appears to be a 'fedora' based linux distribution. $norm \n   $lty If you have the 'YUM' or newer 'DNF' package manager you should be able to install with the following commands: $norm\n\n       $lty sudo yum update $norm       # using yum\n       $lty sudo yum install $missing_util $norm # using yum\n\n       $lty sudo dnf check-update $norm # using dnf\n       $lty sudo dnf install $missing_util $norm # using dnf\n"
        [[ "$distro_like" == "macos" ]] && printf "   $lty Your OS appears to be a 'Darwin' based distribution - which means 'macOS' / 'OSX'. $norm \n   $lty It is suggested to use the 'homebrew' utility to install missing packages - https://brew.sh/ $norm\n\n   $lty From a terminal window or linux prompt: $norm\n\n       $lty brew install $missing_util $norm\n"

        if [[ "$distro_like" != "linux" ]]; then
            printf "\n   $lty If the detected distribution seems incorrect or suggested install method(s) do not work for you: $norm\n    $lty web-search on how to install '$missing_util' with your OS type. $norm \n\n";
        else
            # Generic message if $distro_like is the fallback / default 'linux' value.
            printf "   $lty Please install the missing utility program for this script to be able function. $norm\n\n   $lty If you aren't sure how - web-search how to install '$missing_util' with your OS type. $norm\n\n"
        fi
        read -n1 -r -p "Press any key to continue...";
        exit 1;
    fi

    # OS type check - Checks what kind of OS we are using based system information.  This is mostly gathered for determining which version type of java to get.
    if [[ `uname -s` == "Linux" ]]; then ostype=linux; fi
    if [[ `uname -s` == "Darwin" ]]; then ostype=mac; fi
    # In the case that it's alpine linux this will determine and set ostype
    if [[ -f "/etc/os-release" ]]; then
        distro_id=`grep -ioP '^ID=\K.+' /etc/os-release`
        [[ `echo "$distro_id" | fgrep "alpine"` ]] && ostype=alpine-linux
    fi

    # Architecture type check.  This is gathered for determining which version type of java to get.
        if [[ `command -v uname` ]]; then
            # Uses a search for the entire uname -a entry because not all OS types use -m for finding arch type.  Setting uname_info equal to itself with all lowercase ensures good hits.
            uname_info=`uname -a`; uname_info=${uname_info,,}; OSARCH="x64"; [[ `echo "$uname_info" | fgrep "ppc64"` ]] && OSARCH="ppc64"; [[ `echo "$uname_info" | fgrep "ppc64le"` ]] && OSARCH="ppc64le"; [[ `echo "$uname_info" | fgrep -e "aarch64" -e "arm64"` ]] && OSARCH="aarch64"; [[ `echo "$uname_info" | fgrep "x86_64"` ]] && OSARCH="x64"; unset uname_info
        elif [[ `command -v arch` ]]; then
            arch_info=`arch`; OSARCH="x64"; [[ `echo "$arch_info" | fgrep "ppc64"` ]] && OSARCH="ppc64"; [[ `echo "$arch_info" | fgrep "ppc64le"` ]] && OSARCH="ppc64le"; [[ `echo "$arch_info" | fgrep -e "aarch64" -e "arm64"` ]] && OSARCH="aarch64"; [[ `echo "$arch_info" | fgrep "x86_64"` ]] && OSARCH="x64"; unset arch_info
        else
            # Just use x64 as a fallback if no other methods of detection were found, like the other methods above result in if searches fail to get a hit.
            OSARCH="x64"
        fi

    # END CHECKUPS

# If no parameters were set, sets the background color blue and the clears the window to refresh as a blue window.
[[ -z "$param1" ]] &&  { printf "${blue}"; clear; }

# Sets the terminal window size to prevent menu formatting weirdness.
# printf "\033[8;30'120t"

# Resizs the terminal window if the resize command is recognized
[[ `command -v resize` ]] && printf '\e[8;30;98t' 2>/dev/null

# Sets default variables as needed later on for various things.
javaoverride="N"
shouldiquit=1
ARGS="-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:+DisableExplicitGC -XX:+PerfDisableSharedMem -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled -XX:MaxTenuringThreshold=1 -XX:SurvivorRatio=32 -XX:MaxGCPauseMillis=100 -XX:GCPauseIntervalMillis=150 -XX:TargetSurvivorRatio=90 -XX:+UseFastAccessorMethods -XX:+UseCompressedOops -XX:ReservedCodeCacheSize=400M -XX:SoftRefLRUPolicyMSPerMB=10000 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1NewSizePercent=30 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20"
OTHERARGS="-XX:+IgnoreUnrecognizedVMOptions -XX:+AlwaysActAsServerClassMachine -Dlog4j2.formatMsgNoLookups=true"
ASKMODSCHECK="Y"

# Makes the univ-utils folder if it does not exist yet
[[ ! -d "./univ-utils" ]] && mkdir -p "univ-utils"

# Gets the public IPv4 address of the computer using an web serivce API - if the result is an empty variable then set to unknown.
PUBLICIP=`curl 'https://api.bigdatacloud.net/data/client-ip' 2>nul`
PUBLICIP=`echo $PUBLICIP | jq --raw-output '.ipString'`
[[ -z "$PUBLICIP" ]] && PUBLICIP="unknown"

# Gets the local IPv4 address of the computer to store - tries to get it with various methods that could be present.  Starts with preferring ifconfig as the command should be identical in both linux and macos.
[[ `command -v ifconfig` ]] && LOCALIP=`ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | head -1 | awk '{ print $2 }'`
if [[ ! `command -v ifconfig` ]]; then
    if [[ "$ostype" == "linux" ]]; then
        if [[ `command -v ip` ]]; then
            LOCALIP=`ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p'`
        elif [[ `command -v hostname` ]]; then
            while IFS=' ' read -r localip _; do LOCALIP="$localip"; done < <(hostname -I)
        fi
    fi
    if [[ "$ostype" == "mac" ]]; then
        if [[ `command -v osascript` ]]; then
            LOCALIP=$(osascript -e "IPv4 address of (system info)")
        elif [[ `command -v ipconfig` ]]; then
            # On newer versions of macos, wifi is en0, and en1, en2, etc are ethernet.  On older macos en0 was ethernet / en1 wifi... at least this is a fallback method of trying to find the one to use.
            LOCALIP=`ipconfig getifaddr en1`
            [[ -z "$LOCALIP" ]] && LOCALIP=`ipconfig getifaddr en2`
            [[ -z "$LOCALIP" ]] && LOCALIP=`ipconfig getifaddr en0`
        fi

    fi
fi
[[ -z "$LOCALIP" ]] && LOCALIP="unknown"

# Saves a standard header to print out later
univheader="\n$yellow~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Welcome to the Universalator - A modded Minecraft server installer / launcher     
                                                                                      
         LINUX EDITION !                                                              
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$blue\n"

# server.properties file handling
    # removes annoying dos /r newline characters if present in the server.properties file - in case the file was made on Windows os and had them.
    [[ -f "server.properties" ]] && sed -i 's/\r$//' server.properties

    # Creates an array out of server.properties file if it exists
    if [[ -f "server.properties" ]]; then
        serverprops=()
        while IFS= read -r line; do
            serverprops+=( "$line" )
        done <server.properties

        # Loops over the array for values detection and handling - corrects allow-flight and online-mode always, and records the server-port and server-ip lines
        for i in "${!serverprops[@]}"; do
            while IFS='=' read -r property value; do
                [[ "$property" == "allow-flight" ]] && serverprops[$i]="allow-flight=true"
                [[ "$property" == "online-mode" ]] && serverprops[$i]="online-mode=true"
                [[ "$property" == "server-port" ]] && PORT="$value"
                [[ "$property" == "server-ip" ]] && IPLINE=$i
                [[ "$property" == "server-ip" ]] && IPLINEVALUE="$value"
            done <<<${serverprops[$i]}
        done

        # Gives a warning message if an entry was put after server-ip=.  Ignoring cases where the IPLINE is allow-flight=true is for cases when that's all that exists in the file so far.
        if [[ "${serverprops[$IPLINE]}" != "server-ip=" ]] && [[ "${serverprops[$IPLINE]}" != "allow-flight=true" ]]; then
            choice=0
            while [[ "$choice" == "0" ]]; do
                clear
                printf "\n\n\n   $yellow WARNING WARNING WARNING $blue \n\n   IT IS DETECTED THAT THE server.properties FILE HAS AN IP ADDRESS ENTERED AFTER server-ip= \n\n            $yellow ${serverprops[$IPLINE]} $blue\n\n"
                printf "   THIS ENTRY IS ONLY TO BE USED USED IF YOU ARE SETTING UP A CUSTOM DOMAIN\n   IF YOU ARE NOT SETTING UP A CUSTOM DOMAIN THEN THIS ENTRY IS SUPPOSED TO BE LEFT BLANK!\n\n"
                printf "   $yellow WARNING WARNING WARNING $blue \n\n\n       ENTER TO EITHER CORRECT THIS ENTRY TO BLANK OR IGNORE\n       ONLY CHOOSE IGNORE IF YOU ARE SETTING UP A CUSTOM DOMAIN"
                printf "\n       ENTER YOUR CHOICE:\n\n      $green CORRECT $blue or $red IGNORE $blue\n\n\n"
                printf "  $green"; read -p " Entry : $blue " ipchoice; printf "$blue"

                case "${ipchoice^^}" in
                    (CORRECT) let "choice+=1"; serverprops[$IPLINE]="server-ip=";;
                    (IGNORE) let "choice+=1" ;;
                    (*) printf "\nInvalid option '$modloadertype' - try again\n\n"; read -n1 -r -p "Press any key to continue...";;
                esac
            done
        fi
    
        # Finally blanks out the server.properties file and populates it with the current values in the array - including blanked out server-ip= entry if user chose CORRECT.
        echo -n >"server.properties"
        for i in "${!serverprops[@]}"; do
            echo "${serverprops[$i]}">>server.properties
        done
        # Unsets the array since it isn't needed anymore
        unset serverprops
    # If no server.properties file was found then make one with only the allow-flight=true, since that is all in default settings that could be corrected.
    else 
        echo "allow-flight=true">"server.properties"
    fi
    # If port was never found from server.properties, assume it is going to be the default generated of 25565.
    [[ -z $PORT ]] && PORT="25565"


# Function to save changes to server.properties values.  Gets passed two parameters which is the property to change and the value to use.
serverprops_stamp () {
        # Reads in the server.properties file to an array
        serverprops=()
        while IFS='' read -r line; do
            serverprops+=( "$line" )
        done <server.properties
        # Looks for the first parameter entered and if found sets the serverprops array value to the new property=value with the 
        for ith in "${!serverprops[@]}"; do
            while IFS='=' read -r property value; do
                [[ "$property" == "${1}" ]] && serverprops[ith]="${1}=${2}"
            done <<<${serverprops[ith]}
        done
        # Resets the server.properties file with the final array values.
        echo -n >"server.properties"
        for i in "${!serverprops[@]}"; do
            echo "${serverprops[$i]}">>server.properties
        done
        unset serverprops
}

# END GENERAL PRE-MENU ITEMS
# BEGIN FUNCTIONS SETUP

setport () {
    while [[ "$portexit" != "Y" ]]; do
        clear
        printf "\n\n\n\n\n  $yellow ENTER THE PORT NUMBER TO USE FOR THE LAUNCHED SERVER $blue\n\n   DEFAULT VALUE IS $yellow 25565 $blue\n\n"
        printf "   CURRENTLY SET VALUE IS - $green $PORT $blue\n\n   DO NOT SET THE PORT TO BE USED BELOW 10000 - BELOW THAT NUMBER IS NOT A GOOD IDEA\n   OTHER CRITICAL PROCESSES MAY ALREADY BE USING PORTS BELOW THIS NUMBER\n"
        printf "\n  $yellow ENTER THE PORT NUMBER TO USE FOR THE LAUNCHED SERVER $blue \n\n\n"
        printf "      $green"; read -p " Entry ( enter a number OR 'default' ): $blue " portentry; printf "$blue"
        
        if [[ "${portentry,,}" != "default" ]]; then
            case $portentry in
                ''|*[!0-9]*) printf "\n   THE ENTRY $red $portentry $blue DOES NOT LOOK LIKE AN WHOLE NUMBER, TRY AGAIN\n\n"; read -n1 -r -p "   Press any key to continue...";;
                *) goodport="Y" ;;
            esac

            if [[ "$goodport" == "Y" ]]; then
                [[ "$portentry" -gt 10000 ]] && { PORT="$portentry"; portexit="Y"; } || { printf "\n   THE NUMBER ENTERED $red $portentry $blue WAS LESS THEN 10000, TRY AGAIN WITH A NUMBER WITHIN VALID RANGE\n\n"; read -n1 -r -p "   Press any key to continue..."; }
            fi
        else
            PORT="25565"; portexit="Y"
        fi
        unset portentry; unset goodport
    done
    unset portexit
    serverprops_stamp "server-port" "$PORT"
}

# function to convert found windows-style settings file to linux settings file
settingsconverttolinux () {
    # If linux settings file does not exist but the windows settings file does, process the windows settings file to generate a linux one and set values from it.

    # sets or resets the linux settings text file to an empty file
    echo -n >"settings-linux-universalator.txt"
    printf "# Universalator Linux\OSX edition settings\n# To reset this file - delete and run launcher again. \n#\n#  MINECRAFT is Minecraft version - example: MINECRAFT=1.18.2\n#  MODLOADER is modloader type - FORGE / NEOFORGE / FABRIC / QUILT / VANILLA\n#  MODLOADERVERSION is the version number/name to use for whichever MODLOADER is set\n#  JAVAVERSION - can be edited but it's better to set through script to filter for compatible versions\n#  MAXRAM is ram maximum value in gigabytes, must be a whole number - example: 6\n#  ARGS are Java additional startup args - DO NOT INCLUDE -Xmx THAT IS SET USING MAXRAM\n#  ASKMODSCHECK is whether or not the next settings menu entry done asks to scan for client only mods\n#\n#\n">>"settings-linux-universalator.txt"

    # outputs reformatted variable declarations to a linux formatted txt file, and then 'source' command is used to load them.
    # grep finds all lines beginning with SET in the standard Universalator settings file and outputs them to a while / read loop that parses based on the '= ' delims.
    # the stuff modifying varvalue strips out any newline.
    grep -a 'SET' <settings-universalator.txt | while IFS='= ' read -r _ varname varvalue; do
         printf '%s\n' "$varname=\"${varvalue//[$'\t\r\n ']}\"" >>settings-linux-universalator.txt
    done
}
# function to refresh the settings file with all current settings values
settingsstamp () {
    # corrects any lowercase to all uppercase in 
    if [[ "${MODLOADER^^}" == FORGE ]]; then MODLOADER="FORGE"; elif [[ "${MODLOADER^^}" == "NEOFORGE" ]]; then MODLOADER="NEOFORGE"; elif [[ "${MODLOADER^^}" == "FABRIC" ]]; then MODLOADER="FABRIC"; elif [[ "${MODLOADER^^}" == "QUILT" ]]; then MODLOADER="QUILT"; elif [[ "${MODLOADER^^}" == "VANILLA" ]]; then MODLOADER="VANILLA"; fi
    echo -n >"settings-linux-universalator.txt"
    printf "# Universalator Linux\OSX edition settings\n# To reset this file - delete and run launcher again. \n#\n#  MINECRAFT is Minecraft version - example: MINECRAFT=1.18.2\n#  MODLOADER is modloader type - FORGE / NEOFORGE / FABRIC / QUILT / VANILLA\n#  MODLOADERVERSION is the version number/name to use for whichever MODLOADER is set\n#  JAVAVERSION - can be edited but it's better to set through script to filter for compatible versions\n#  MAXRAM is ram maximum value in gigabytes, must be a whole number - example: 6\n#  ARGS are Java additional startup args - DO NOT INCLUDE -Xmx THAT IS SET USING MAXRAM\n#  ASKMODSCHECK is whether or not the next settings menu entry done asks to scan for client only mods\n#\n#\n">>"settings-linux-universalator.txt"
    printf "MINECRAFT=\"$MINECRAFT\"\nMODLOADER=\"$MODLOADER\"\nMODLOADERVERSION=\"$MODLOADERVERSION\"\nJAVAVERSION=\"$JAVAVERSION\"\nMAXRAMGIGS=\"$MAXRAMGIGS\"\nARGS=\"$ARGS\"\nOSARCH=\"$OSARCH\"">>"settings-linux-universalator.txt"
}
# function for settings variables loading, from text storage files.
settingscall () {
    # If the linux settings file exists then use source to get values from it into useable variables.
    if [[ -f "settings-linux-universalator.txt" ]]; then source "settings-linux-universalator.txt"; fi
}
# function tree to get settings values with user entry, and then save settings.
settingssetup () {
    MODLOADER="DUMMY"
    setminecraft
    setmodloader
    [[ "$MODLOADER" != "VANILLA" ]] && setmodloaderversion
    setjava
    setmaxram
    settingsstamp
    settingscall
}
# main function to set Minecraft version
setminecraft () {
    goodmcver="False"
    while [[ "$goodmcver" == "False" ]]; do
        clear
        # Runs function to check / get the mojang version manifest.
        mojangmanifest
        if [[ ! -f "settings-linux-universalator.txt" ]]; then printf "$univheader"; else printf "\n\n"; fi
        printf "\n\n\n\n   $yellow ENTER THE MINECRAFT VERSION $blue \n\n   example: 1.7.10\n   example: 1.16.5\n   example: 1.19.2\n\n   $yellow ENTER THE MINECRAFT VERSION $blue \n\n\n\n"
        printf "  $green"; read -p " Entry : $blue " MINECRAFT; printf "$blue"
        goodmcver="True"

        # Uses jq to check mojang version manifest against the entered MC version to see if it is an actual release version.
        # If somehow no manifest file was found / gotten, passes by gracefully accepting whatever was entered.
        if [[ -f ./univ-utils/version_manifest_v2.json ]]; then
            [[ `jq --arg mcr $MINECRAFT '.versions[] | select ( .type == "release" and .id == $mcr )' "./univ-utils/version_manifest_v2.json"` ]] && goodmcver="True" || goodmcver="False"

            if [[ "$goodmcver" == "False" ]]; then printf "\n   Oops the version you entered $MINECRAFT was not detected to exist as a release version.\n   Try again\n\n"; read -n1 -r -p "Press any key to continue..."; fi
        fi   
    done
}
# function to get the Mojang Minecraft versions manifest and check age of any existing manifest file.
mojangmanifest () {
    getvermanifest="u"
    # If no MC version manifest found then set to True to get
    [[ ! -f ./univ-utils/version_manifest_v2.json ]] && getvermanifest=True
    # If MC version manifest found, use date, file creation date, and some math to check if it's older than a certain time.  If it is older then set True to get.
    if [[ -f ./univ-utils/version_manifest_v2.json ]]; then
        d2=`date +%s`; d1=`date -r "./univ-utils/version_manifest_v2.json" +%s`; let diff_hours=($d2-$d1)/3600
        [[ "$diff_hours" -gt 6 ]] && getvermanifest="True"
    fi
    
    if [[ "$getvermanifest" == "True" ]]; then
        dnscheck
        curl -sLfo ./univ-utils/version_manifest_v2.json "https://launchermeta.mojang.com/mc/game/version_manifest_v2.json"
    fi
}
# main function to set the Modloader type
setmodloader () {
    foundgoodmodloader=0
    while [[ "$foundgoodmodloader" == "0" ]]; do
        clear
        if [[ ! -f "settings-linux-universalator.txt" ]]; then printf "$univheader"; else printf "\n\n\n"; fi
        printf "\n\n\n\n   $yellow ENTER THE MODLOADER TYPE $blue\n\n    Valid entries - $green FORGE $blue \n                    $green NEOFORGE $blue \n                    $green FABRIC $blue \n                    $green QUILT $blue \n                    $green VANILLA $blue \n\n   $yellow ENTER THE MODLOADER TYPE $blue \n\n\n"
        printf "  $green"; read -p " Entry : $blue " modloadertype; printf "$blue"
        # The entry passed to case is set to all uppercase characters for comparison - this can be a problem for non-english letters but that won't be a problem here.
        case "${modloadertype^^}" in
            (FORGE) MODLOADER="FORGE"; let "foundgoodmodloader+=1";;
            (NEOFORGE) MODLOADER="NEOFORGE"; let "foundgoodmodloader+=1";;
            (FABRIC) MODLOADER="FABRIC"; let "foundgoodmodloader+=1";;
            (QUILT) MODLOADER="QUILT"; let "foundgoodmodloader+=1";;
            (VANILLA) MODLOADER="VANILLA"; let "foundgoodmodloader+=1";;
            (*) printf "\nInvalid option '$modloadertype' - try again\n\n"; read -n1 -r -p "Press any key to continue...";;
        esac
    done
}
# main function to set the modloader version
setmodloaderversion () {
    # Starts by getting the newest version to display from the modloader's maven metadata file.
    getnewestversion
    setgoodmodloader=0
    while [[ $setgoodmodloader == 0 ]]; do
        clear
        printf "\n\n\n   $yellow $MODLOADER VERSION - $MODLOADER VERSION $blue \n\n"
        ( [[ "$MODLOADER" == "FORGE" ]] || [[ "$MODLOADER" == "NEOFORGE" ]] ) && printf "     THE NEWEST VERSION OF $MODLOADER FOR MINECRAFT VERSION $MINECRAFT \n\n     WAS DETECTED TO BE:\n                      $green $newestmodloader $blue\n\n     -ENTER $green 'Y' $blue TO USE THIS NEWEST VERSION \n\n      $yellow OR $blue \n\n     -ENTER A VERSION NUMBER TO USE INSTEAD\n"
        [[ "$MODLOADER" == "FORGE" ]] && printf "\n       example: 14.23.5.2860\n       example: 47.2.19\n"; [[ "$MODLOADER" == "NEOFORGE" ]] && printf "       example: 20.2.88\n       example: 20.4.75-beta\n"
        ( [[ "$MODLOADER" == "FABRIC" ]] || [[ "$MODLOADER" == "QUILT" ]] ) && printf "\n\n   DO YOU WANT TO USE THE NEWEST PUBLISHED VERSION OF THE $MODLOADER $yellow LOADER $blue FILE?\n    VERSION $yellow $newestmodloader $blue \n\n\n   ENTER $green 'Y' $blue or $red 'N' $blue TO ENTER A CUSTOM VERSION    \n   UNLESS YOU KNOW A SPECIFIC OLDER FABRIC LOADER IS REQUIRED FOR YOUR MODS - ENTER $green 'Y' $blue \n"
        printf "\n\n\n   $yellow $MODLOADER VERSION - $MODLOADER VERSION $blue \n\n"
        printf "  $green"; read -p "  Entry : $blue " modloaderver; printf "$blue"

        if [[ "${modloaderver^^}" != "Y" ]]; then
            # does a grep search for the entered version inside the maven-metadata file if the entry was not Y.  Checks the error status of the grep search to determine what to do next.
            `grep -q -e "$modloaderver" "./univ-utils/$mavenfile"`
            # If found then set modloaderver to F for found, and set MODLOADERVERSION.  If not found set modloaderver to N.
            if [[ $? -eq 0 ]]; then MODLOADERVERSION="$modloaderver"; modloaderver=F; else enteredmodloader=$modloaderver; modloaderver=N; fi
        fi

        case "${modloaderver^^}" in
            (Y) MODLOADERVERSION="$newestmodloader"; let setgoodmodloader+=1;;
            (N) printf "\n   The the entry $red $enteredmodloader $blue was not found to be an existing version, try again.\n"; read -n1 -r -p "Press any key to continue...";;
            (F) let setgoodmodloader+=1;;
            (*) MODLOADERVERSION="$modloaderver";;
        esac

    done
}
# function to fetch the newest version of the set modloader type
getnewestversion () {
    # Starts by checking/getting the required maven metadata file for whichever modloader is set.
    checkmavenfile
    getmajorminor

    if [[ -f "./univ-utils/$mavenfile" ]]; then
        newestmodloader="u"

        # If Forge or Neoforge - pipes the output of maven-metadata file to a fgrep which filters based on the Minecraft version, then a while loop reads off the info and a variable sets the MODLOADERVERSION.
        # Forge's metadata file puts the newest versions first on the list, so at the first while loop 'break' is done to only iterate for the first entry grep found.  Neoforge 1.20.1 metadata file puts the newest version last, so loops through the entire filted list and last recorded is newest.
        # Process substitution using '< <' to input the ( powershell | fgrep ) to the while loop because if you pipe inside of the while loop it creates a subshell and any variable values set are lost exiting the subshell.
        if [[ "$MODLOADER" == "FORGE" ]]; then while IFS='-' read -r _ forgever _; do newestmodloader="$forgever"; break; done < <(xmlstarlet sel -t -v "//versioning/versions/version" ./univ-utils/maven-forge-metadata.xml | fgrep "$MINECRAFT"); fi
        if [[ "$MODLOADER" == "NEOFORGE" ]] && [[ "$MINECRAFT" == "1.20.1" ]]; then while IFS='-' read -r _ neofver; do newestmodloader="$neofver"; done < <(xmlstarlet sel -t -v "//versioning/versions/version" ./univ-utils/maven-neoforge-1.20.1-metadata.xml | fgrep "$MINECRAFT"); fi
        # Neoforge newer than 1.20.1 changes the version conventions from older Neoforge and Forge, so a function is run to get the major and minor MC versions to help filter results.  Neoforge 1.20.2+ still lists the newest version last/bottom of list.
        if [[ "$MODLOADER" == "NEOFORGE" ]] && [[ "$MINECRAFT" != "1.20.1" ]]; then while IFS= read -r neofver; do newestmodloader="$neofver"; done < <(xmlstarlet sel -t -v "//versioning/versions/version" ./univ-utils/maven-neoforge-metadata.xml | fgrep "$mcmajor.$mcminor."); fi
        # Fabric and Quilt both work a different way with the newest version being a release in the metadata file, and it's independent of MC version it will be used with.
        if [[ "$MODLOADER" == "FABRIC" ]]; then newestmodloader=`xmlstarlet sel -t -v "//versioning/release" ./univ-utils/maven-fabric-metadata.xml`; fi
        if [[ "$MODLOADER" == "QUILT" ]]; then newestmodloader=`xmlstarlet sel -t -v "//versioning/release" ./univ-utils/maven-quilt-metadata.xml`; fi
    fi
}
# main function to set the Java version to use
setjava () {
    # Parses the MC version to get major and minor version numbers
    getmajorminor

    setgoodjava=0
    while [[ "$setgoodjava" == "0" ]]; do
        clear
        printf "\n\n\n\n\n  $yellow ENTER JAVA VERSION TO LAUNCH THE SERVER WITH $blue\n\n   JAVA IS THE ENGINE THAT MINECRAFT JAVA EDITION RUNS ON\n\n"
        [[ $mcmajor -lt 16 ]] && printf "   THE ONLY OPTION FOR MINECRAFT $MINECRAFT BASED LAUNCHING IS $green 8 $blue "
        [[ $mcmajor -eq 16 ]] && [[ $mcminor -le 4 ]] && printf "   THE ONLY OPTION FOR MINECRAFT $MINECRAFT BASED LAUNCHING IS $green 8 $blue "
        [[ $mcmajor -eq 16 ]] && [[ $mcminor -eq 5 ]] && printf "   THE OPTIONS FOR MINECRAFT $MINECRAFT BASED LAUNCHING ARE $green 8 $blue AND $green 11 $blue "
        [[ $mcmajor == 17 ]] && printf "   THE ONLY OPTION FOR MINECRAFT $MINECRAFT BASED LAUNCHING IS $green 16 $blue "
        [[ $mcmajor -ge 18 ]] && printf "   THE OPTIONS FOR MINECRAFT $MINECRAFT BASED LAUNCHING ARE $green 17 $blue AND $green 21 $blue "
        printf "\n\n\n   * USING THE NEWER VERSION OPTION IF GIVEN A CHOICE $green MAY $blue OR $red MAY NOT $blue WORK DEPENDING ON MODS BEING LOADED\n   * IF A SERVER FAILS TO LAUNCH, YOU SHOULD CHANGE BACK TO THE LOWER DEFAULT VERSION!\n\n\n  $yellow ENTER JAVA VERSION TO LAUNCH THE SERVER WITH $blue \n\n"
        printf "  $green"; read -p " Entry : $blue " tempjava; printf "$blue"

        case "$tempjava" in
            (8) [[ $mcmajor -le 16 ]] && JAVAVERSION=$tempjava && let "setgoodjava+=1";;
            (11) ( [[ $mcmajor -eq 16 ]] && [[ $mcminor -eq 5 ]] ) && JAVAVERSION=$tempjava && let "setgoodjava+=1";;
            (16) [[ $mcmajor -eq 17 ]] && JAVAVERSION=$tempjava && let "setgoodjava+=1";;
            (17 | 21) [[ $mcmajor -ge 18 ]] && JAVAVERSION=$tempjava && let "setgoodjava+=1";;
            (*) printf "\nInvalid entry - enter a valid version option\n"; read -n1 -r -p "Press any key to continue...";;
        esac
    done
}

# Main function to set system arch version for determining which java installation to get/use
setarch () {
    setgoodarch="N"
    while [[ "$setgoodarch" != "Y" ]]; do
        clear
        printf "\n\n\n\n\n  $yellow CHOOSE THE SYSTEM ARCHIECTURE TO USE FOR JAVA $blue\n\n   SELECT WHICH COMPUTER SYSTEM ARCHITECTURE TO USE FOR JAVA INSTALLATION\n\n"
        printf "   THE UNIVERSALATOR SCRIPT DOES ATTEMPT TO AUTO-DETECT THE CORRECT TYPE TO USE\n\n   $red ONLY $blue CHANGE THE SELECTION IF YOU ARE CERTAIN\n\n"
        printf "     $green 1 $blue - $green x64 (amd64) $blue\n     $green 2 $blue - $green aarch64 (arm64) $blue\n     $green 3 $blue - $green ppc64 $blue\n     $green 4 $blue - $green ppc64le $blue\n     $green 5 $blue - $green arm $blue\n     $green 6 $blue - $green riscv64 $blue\n"
        printf "\n  $yellow CHOOSE THE SYSTEM ARCHIECTURE TO USE FOR JAVA $blue \n\n"
        printf "  $green"; read -p " Entry (number): $blue " archentry; printf "$blue"

        case "$archentry" in
            (1) OSARCH="x64"; setgoodarch="Y";;
            (2) OSARCH="aarch64"; setgoodarch="Y";;
            (3) OSARCH="ppc64"; setgoodarch="Y";;
            (4) OSARCH="ppc64le"; setgoodarch="Y";;
            (5) OSARCH="arm"; setgoodarch="Y";;
            (6) OSARCH="riscv64"; setgoodarch="Y";;
            (*) printf "\n  $red Invalid entry $blue - enter a valid numbered selection\n"; read -n1 -r -p "   Press any key to continue...";;
        esac
    done
    unset setgoodarch
}

# main function to set maximum ram allocation
setmaxram () {
    # Gets the total and available ram on the current computer / VM.  Any error messages to find / get are sent to null.
    declare -i ramtot=0; declare -i ramavail=0
    while IFS=': ' read -r _ numb _; do declare -i ramtot=$numb; done < <(grep MemTotal /proc/meminfo 2>/dev/null) 2>/dev/null
    while IFS=': ' read -r _ bumb _; do declare -i ramavail=$bumb; done < <(grep MemAvailable /proc/meminfo 2>/dev/null) 2>/dev/null
    # Divides the kb amount to get gb.  The result is an integer.  Bash can't natively do floating point math... yeah.
    let "ramtot = $ramtot / 1048576"; let "ramavail = $ramavail / 1048576"

    ramexit=0
    while [[ $ramexit == 0 ]]; do
        ramresult=0
        clear
        printf "\n\n"
        [[ -v ramavail ]] && [[ $ramtot != 0 ]] && [[ $ramavail != 0 ]] && ( printf "    Total Total Memory/RAM     $blue   = $yellow $ramtot Gigabytes (GB) $blue \n    Current Available Memory/RAM $blue = $yellow $ramavail Gigabytes (GB) $blue \n\n     * Current stats for the computer / VM this is running with.\n" )
        printf "\n\n\n\n\n   $yellow ENTER MAXIMUM RAM / MEMORY THAT THE SERVER WILL RUN - IN GIGABYTES (GB) $blue\n\n    BE SURE TO USE A VALUE THAT LEAVES AT LEAST SEVERAL GB AVAILABLE IF ALL USED\n    (Refer to the total and available RAM found above)\n\n    TYPICAL VALUES FOR MODDED MINECRAFT SERVERS ARE BETWEEN 4 AND 10\n\n    ONLY ENTER A WHOLE NUMBER - $red MUST NOT $blue INCLUDE ANY LETTERS.\n    $green Example - 6 $blue\n\n   $yellow ENTER MAXIMUM RAM / MEMORY THAT THE SERVER WILL RUN - IN GIGABYTES (GB) $blue\n\n"
        printf "  $green"; read -p " Entry : $blue " ramentry; printf "$blue"

        re='^[0-9]+$'
        if [[ -v ramavail ]]; then
            # If ramavail was detected then compare what was entered and the available and decide if greater than 1gb remains after full allocation.
            # Also check if the entry was a whole number or not.
            if [[ $ramentry =~ $re ]]; then declare -i ramentry=$ramentry 2>/dev/null; let "ramleft = $ramavail - $ramentry"; else  ramresult=1; fi
            # If the result of ram entered and the amount available leaves less than 1gb of memory or goes negative, set a state for case to read.
            [[ $ramleft -lt 1 ]] && ramresult=2 || ramresult=3
        else
            # If ramavail was not detected then only try to set the entry as an integer variable, and then check if the result is a whole number.
            declare -i ramentry=$ramentry 2>/dev/null; [[ $ramentry =~ $re ]] && ramresult=3 || ramresult=1
        fi

        case "$ramresult" in
            (1) printf "\n   You must enter a whole number!\n"; read -n1 -r -p "     Press any key to try a new entry...";;
            (2) printf "\n   You cannot enter a value that leaves less than 1gb of ram/memory left available\n!"; read -n1 -r -p "     Press any key to try a new entry...";;
            (3) MAXRAMGIGS=$ramentry; let "ramexit+=1";;
            (*) printf "\n   Invalid entry!\n"; read -n1 -r -p "     Press any key to try again ...";;
        esac
    done
}
# function to parse the major and minor Minecraft version numbers
getmajorminor () {
    # Sets the major and minor Minecraft version to integer variables - if it has no minor version then mcminor is set to 0.
    while IFS='.' read -r _ maj min; do
        mcmajor=$maj
        mcminor=$min
    done <<<$MINECRAFT
}
# function to check the DNS currently used resolving the IP addresses of whichever modloader's URL is, also always check Mojang's URLs
dnscheck () {
    # sets a variable for the mavenurl depending on the MODLOADER type.
    if [[ "$MODLOADER" == "FORGE" ]]; then mavenurl="maven.minecraftforge.net"; elif [[ "$MODLOADER" == "NEOFORGE" ]]; then mavenurl="maven.neoforged.net"; elif [[ "$MODLOADER" == "FABRIC" ]]; then mavenurl="maven.fabricmc.net"; elif [[ "$MODLOADER" == "QUILT" ]]; then mavenurl="maven.quiltmc.org"; fi

    # Checks resolving an IP address for the maven URL of currently set non-vanilla MODLOADER type - if the test passes then the function just passes by the warning.
    # ANOTHER WAY TO CHECK DNS, SOME RESULTS DIFFER - [ "$(dig +short -t srv $mavenurl.)" ]
    if [[ "$MODLOADER" != "VANILLA" ]] && [[ "$MODLOADER" != "DUMMY" ]]; then
        resolvedIP=$(nslookup "$mavenurl" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)

        if [[ -z "$resolvedIP" ]]; then clear; printf "\n\n\n\n   $red OOPS - THE FOLLOWING WEB URLS COULD NOT RESOLVE IP ADDRESSES USING YOUR CURRENT DNS $blue \n\n   $yellow $mavenurl $blue \n\n   $red THE SOLUTION IS CHANGING YOUR COMPUTER SETTINGS TO USE A PUBLIC DNS SERVER. $blue "
            printf "\n   $red THIS IS EASILY DONE, FOR INSTRUCTIONS ON WHERE TO FIND THIS SETTING, SEARCH THE INTERNET $blue \n   $red FOR: '$ostype change dns server' $blue \n\n\n"
            printf "\n   $yellow SUGGESTEED PUBLIC DNS SERVERS TO USE: $blue \n\n   $yellow 1.1.1.1 ( Cloudflare ) $blue \n   $yellow 8.8.8.8 ( Google ) $blue \n\n"; read -n1 -r -p "Press any key to continue..."; printf "$norm"; clear; exit 0;
        fi
    fi

    # The Mojang file servers get dns lookups regardless of the modloader type, since both vanilla and any modloader types depend on it for various things.  This way the dnscheck function can be called anywhere just for a general check.
    mojurl1="u"; mojurl2="u"; mojproblem="u"
    mojurloneIP=$(nslookup "piston-meta.mojang.com" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
    mojurltwoIP=$(nslookup "launchermeta.mojang.com" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | xargs)
    [[ -z "$mojurloneIP" ]] && mojurl1="b" && mojproblem="y"; [[ -z "$mojurltwoIP" ]] && mojurl2="b" && mojproblem="y"

    if [[ "$mojproblem" == "y" ]]; then clear; printf "\n\n\n\n   $red OOPS - THE FOLLOWING MOJANG WEB URLS COULD NOT RESOLVE IP ADDRESSES USING YOUR CURRENT DNS $blue \n"
        [[ "$mojurl1" == "b" ]] && printf "\n   $yellow launchermeta.mojang.com $blue \n"; [[ "$mojurl2" == "b" ]] && printf "\n   $yellow piston-meta.mojang.com $blue \n"
        printf "\n   $red THE SOLUTION IS CHANGING YOUR COMPUTER SETTINGS TO USE A PUBLIC DNS SERVER. $blue "
        printf "\n   $red THIS IS EASILY DONE, FOR INSTRUCTIONS ON WHERE TO FIND THIS SETTING, SEARCH THE INTERNET $blue \n   $red FOR: '$ostype change dns server' $blue \n\n\n"
        printf "\n   $yellow SUGGESTEED PUBLIC DNS SERVERS TO USE: $blue \n\n   $yellow 1.1.1.1 ( Cloudflare ) $blue \n   $yellow 8.8.8.8 ( Google ) $blue \n\n"; read -n1 -r -p "Press any key to continue..."; printf "$norm"; exit 1;
    fi
}
# function to ping the website of whichever modloader is passed to the function as a parameter
pingthing () {
    # Sets the website to be pinged depending on the argument sent to the function
    [[ "${1}" == "FORGE" ]] && pingurl="maven.minecraftforge.net"; [[ "${1}" == "NEOFORGE" ]] && pingurl="maven.neoforged.net"; [[ "${1}" == "FABRIC" ]] && pingurl="maven.fabricmc.net"; [[ "${1}" == "QUILT" ]] && pingurl="maven.quiltmc.org"; [[ "${1}" == "VANILLA" ]] && pingurl="piston-meta.mojang.com";
    # Pings once and if the ping fails inform the user of the news, if success sets a variable that can be checked
    ping -c 1 $mavenurl >/dev/null 2>&1 && pingresponse=g || ( pingresponse=b; clear; printf "\n\n\n   Uh-oh, a ping to the website for ${1} failed to get a response.\n   Website - $pingurl\n\n"; read -n1 -r -p "Press any key to try a longer ping test..." )
    # Pings five times if the first attmept above failed.  Sets the pingresponse variable accordingly.
    if [[ "$pingresponse" == "b" ]]; then ping -c 5 $mavenurl >/dev/null 2>&1 && pingresponse=g || pingresponse=b; fi
}
# function to get maven metadata file and check the age of any found existing for refreshing
checkmavenfile () {
    getmavenfile=n
    
    # Sets the name of the maven file to check for
    [[ "$MODLOADER" == "FORGE" ]] && mavenfile="maven-forge-metadata.xml"
    ( [[ "$MODLOADER" == "NEOFORGE" ]] && [[ ! "$MINECRAFT" == "1.20.1" ]] ) && mavenfile="maven-neoforge-metadata.xml"
    ( [[ "$MODLOADER" == "NEOFORGE" ]] && [[ "$MINECRAFT" == "1.20.1" ]] ) && mavenfile="maven-neoforge-1.20.1-metadata.xml"
    [[ "$MODLOADER" == "FABRIC" ]] && mavenfile="maven-fabric-metadata.xml"
    [[ "$MODLOADER" == "QUILT" ]] && mavenfile="maven-quilt-metadata.xml"

    # If the maven file doesn't exist then use curl to get it silently
    [[ ! -f "./univ-utils/$mavenfile" ]] && getmavenfile=y

    # If maven file exists then check the file age using date and file date, if the file is old then use curl to get it again to refresh the file.
    if [[ -f "./univ-utils/$mavenfile" ]]; then
        d2=`date +%s`; d1=`date -r "./univ-utils/$mavenfile" +%s`; let diff_hours=($d2-$d1)/3600
        [[ "$diff_hours" -gt 1 ]] && getmavenfile=y
    fi

    if [[ "$getmavenfile" == "y" ]]; then dnscheck; pingthing "$MODLOADER"; [[ "$pingresponse" == "g" ]] && (
        [[ "$MODLOADER" == "FORGE" ]] && curl -sLfo ./univ-utils/$mavenfile 'https://maven.minecraftforge.net/net/minecraftforge/forge/maven-metadata.xml';
        [[ "$MODLOADER" == "NEOFORGE" ]] && [[ "$MINECRAFT" != "1.20.1" ]] && curl -sLfo ./univ-utils/$mavenfile 'https://maven.neoforged.net/releases/net/neoforged/neoforge/maven-metadata.xml';
        [[ "$MODLOADER" == "NEOFORGE" ]] && [[ "$MINECRAFT" == "1.20.1" ]] && curl -sLfo ./univ-utils/$mavenfile 'https://maven.neoforged.net/releases/net/neoforged/forge/maven-metadata.xml';
        [[ "$MODLOADER" == "FABRIC" ]]  && curl -sLfo ./univ-utils/$mavenfile 'https://maven.fabricmc.net/net/fabricmc/fabric-loader/maven-metadata.xml';
        [[ "$MODLOADER" == "QUILT" ]] && curl -sLfo ./univ-utils/$mavenfile 'https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-loader/maven-metadata.xml';
        );
    fi
}

askscanclients () {
    # If there is no mods folder
    if [[ ! -d "mods" ]]; then
        clear; printf "\n\n\n   $yellow CLIENT MOD SCANNING - CLIENT MOD SCANNING $blue\n\n\n     No folder named 'mods' was found in the directory that the Universalator program was run from!\n\n     Either you have forgotten to copy a 'mods' folder to this folder location,\n       or you did not copy and run this program to the server folder with the server files.\n\n\n   $yellow CLIENT MOD SCANNING - CLIENT MOD SCANNING $blue\n\n\n\n"
        read -n1 -r -p "Press any key to continue..."; scan_yn="N"
    fi
    # If there is a mods folder but it is empty
    if [[ -d "mods" ]] && [[ -z "$(ls -A ./mods)" ]]; then
        clear; printf "\n\n\n   $yellow CLIENT MOD SCANNING - CLIENT MOD SCANNING $blue\n\n\n     A folder named 'mods' was found but it is empty!\n\n\n   $yellow CLIENT MOD SCANNING - CLIENT MOD SCANNING $blue\n\n\n\n"
        read -n1 -r -p "Press any key to continue..."; scan_yn="N"
    fi

    while [[ "$scan_yn" != "Y" ]] && [[ "$scan_yn" != "N" ]]; do
        clear
        printf "\n\n\n   $yellow CLIENT MOD SCANNING - CLIENT MOD SCANNING $blue\n\n\n      --MANY CLIENT MODS ARE NOT CODED TO SELF DISABLE ON SERVERS AND MAY CRASH THEM\n\n      --THE UNIVERSALATOR SCRIPT CAN SCAN THE MODS FOLDER AND SEE IF ANY ARE PRESENT\n\n        For an explanation of how the script scans files - visit the official wiki at:\n"
        printf "        https://github.com/nanonestor/universalator/wiki\n\n\n   $yellow CLIENT MOD SCANNING - CLIENT MOD SCANNING $blue\n\n\n\n     $green WOULD YOU LIKE TO SCAN THE MODS FOLDER FOR MODS THAT ARE NEEDED ONLY ON CLIENTS? $blue\n\n     $green FOUND CLIENT MODS CAN BE AUTOMATICALLY MOVED TO A DIFFERENT FOLDER FOR STORAGE. $blue"
        printf "\n\n\n            $yellow Please enter 'Y' or 'N' $blue\n\n"
        printf "  $green"; read -p " Enter a command: $blue " scan_yn; printf "$blue"

        case "${scan_yn^^}" in
            (Y) scan_yn="Y"; scanclients;;
            (N) scan_yn="N";;
            (*) printf "\ninvalid option $opt\n\n"; read -n1 -r -p "Press any key to continue...";;
        esac
    done
    unset scan_yn
}

scanclients () {
    clear

    # sets clients_txt do decide if to check for clientonlymods.txt
    if [[ "$MODLOADER" == "FORGE" ]]; then clients_txt="Y"; elif [[ "$MODLOADER" == "NEOFORGE" ]]; then clients_txt="Y"; else clients_txt="N"; fi
    if [[ "$clients_txt" == "Y" ]]; then
        # if exists clientonlymods.txt then check how old it is, if older than 12 hrs then refresh
        if [[ -f "./univ-utils/clientonlymods.txt" ]]; then
            d2=`date +%s`; d1=`date -r "./univ-utils/clientonlymods.txt" +%s`; let diff_hours=($d2-$d1)/3600
            [[ "$diff_hours" -gt 12 ]] && rm -f ./univ-utils/clientonlymods.txt
        fi
        # if clientonlymods.txt does not exist then download it
        [[ ! -f "./univ-utils/clientonlymods.txt" ]] && curl -sLfo ./univ-utils/clientonlymods.txt https://raw.githubusercontent.com/nanonestor/utilities/main/clientonlymods.txt

        [[ ! -f "./univ-utils/clientonlymods.txt" ]] && printf "\n\n\n   SOMETHING WENT WRONG DOWNLOADING THE MASTER CLIENT-ONLY LIST FROM THE GITHUB HOSTED LIST\n   CHECK THAT YOU HAVE NO ANTIVIRUS PROGRAM, ETC BLOCKING THE DOWNLOAD FROM:\n\n   https://raw.githubusercontent.com/nanonestor/utilities/main/clientonlymods.txt\n\n\n" && read -n1 -r -p "Press any key to continue..."
    fi

    # Clears any existing arrays being used
    unset modsarray; unset modslist; unset clientmodids; unset clientmodfiles; unset fabricallids; unset fabricallenvirons; unset fabricalldeps;

    #while read file; do modsarray+=("$file"); done< <(ls -B "./mods" | sort -f)
    while read file; do modsarray+=("$file"); done< <(ls -B ./mods/*.jar | sort -f | sed 's/.\/mods\///')

    getmajorminor

    # scanning forge new style with mods.toml files
    if [[ "$MODLOADER" == "FORGE" ]] && [[ "$mcmajor" -gt "12" ]] && [[ -f "./univ-utils/clientonlymods.txt" ]]; then
        idx=0
        idtot=${#modsarray[@]}
        for ith in "${!modsarray[@]}"; do
            let idx+=1
            printf "   $idx/$idtot - ${modsarray[ith]}\n"

            while IFS="= $(echo t | tr t \\t)"  read -r prop value _ _; do
                [[ "$found" == "Y" ]] && [[ "${prop^^}" == "MODID" ]] && modslist[ith]=`echo "$value" | tr -d '"'` && break
                echo $prop | fgrep -q "[[mods]]" && found="Y"
            done < <(unzip -p "mods/${modsarray[ith]}" *mods.toml 2>/dev/null)
        done
    fi

    # scanning forge old style with mcmod.info files
    if [[ "$MODLOADER" == "FORGE" ]] && [[ "$mcmajor" -le "12" ]] && [[ -f "./univ-utils/clientonlymods.txt" ]]; then
        idx=0
        idtot=${#modsarray[@]}
        for ith in "${!modsarray[@]}"; do
            let idx+=1
            printf "   $idx/$idtot - ${modsarray[ith]}\n"

            while IFS=":, $(echo t | tr t \\t)"  read -r prop value _ _; do
                echo $prop | fgrep -q "modid" && modslist[ith]=`echo "$value" | tr -d '"'` && break
            done < <(unzip -p "mods/${modsarray[ith]}" mcmod.info 2>/dev/null)
        done
    fi

    # FORGE new & old syles - generates client mods list, loops through each number in the array(s) and does clientonlymods file comparison, records modId and filename if found!
    if [[ "$MODLOADER" == "FORGE" ]] && [[ -f "./univ-utils/clientonlymods.txt" ]]; then
        for ith in "${!modslist[@]}"; do 
            if [[ `fgrep -x "${modslist[ith]}" "./univ-utils/clientonlymods.txt"` ]]; then
                clientmodids+=(`fgrep -x "${modslist[ith]}" "./univ-utils/clientonlymods.txt"`)
                clientmodfiles+=(${modsarray[ith]}); 
            fi
        done
    fi

    # test whether to scan for fabric and quilt mods - they can both be in one section with a test to see if quilt.mod.json is present or not.
    if [[ "$MODLOADER" == "FABRIC" ]]; then scanfabricquilt="Y"; elif [[ "$MODLOADER" == "QUILT" ]]; then scanfabricquilt="Y"; else scanfabricquilt="N"; fi

    # scanning fabric and quilt mods 
    if [[ "$scanfabricquilt" == "Y" ]]; then
        idx=0; idtot=${#modsarray[@]}
        for ith in "${!modsarray[@]}"; do
            let idx+=1
            unzip -l "mods/${modsarray[ith]}"  >/dev/null 2>&1 | fgrep -q -w quilt.mod.json  >/dev/null 2>&1 && fqjsonfile="quilt.mod.json" || fqjsonfile="fabric.mod.json"

            printf "   $idx/$idtot - ${modsarray[ith]}\n"
    
            rawdepends=`unzip -p "mods/${modsarray[ith]}" $fqjsonfile | sed ':a;N;$!ba;s/\n//g' | jq --raw-output '.depends | try keys_unsorted |  del(.[] | select(. == "minecraft" or . == "fabricloader" or . == "fabric" or . == "bookshelf" or . == "java" or . == "cloth-config" or . == "cloth-config2" or . == "fabric-api" or . == "bclib" or . == "fabric-language-kotlin" or . == "iceberg" or . == "fabric-resource-loader-v0" or . == "architectury" or . == "geckolib3" or . == "puzzleslib" or . == "trinkets" or . == "fabric-api-base" or . == "ftblibrary" or . == "cupboard" or . == "moonlight" or . == "midnightlib" or . == "yungsapi")) | .[]'`

            while IFS='' read -r depmods; do [[ -n "$depmods" ]] && fabricalldeps+=( "$depmods" ); done <<<$rawdepends

            while IFS='' read -r modid; do fabricallids[ith]="$modid"; done < <(unzip -p "mods/${modsarray[ith]}" $fqjsonfile | sed ':a;N;$!ba;s/\n//g' | jq --raw-output '.id')
            while IFS='' read -r envir; do fabricallenvirons[ith]="$envir"; done < <(unzip -p "mods/${modsarray[ith]}" $fqjsonfile | sed ':a;N;$!ba;s/\n//g' | jq --raw-output '.environment')
        done

        # fabric and quilt genenerates arrays of client mod ids and files
        for ith in "${!modsarray[@]}"; do
            [[ "${fabricallenvirons[ith]}" == "client" ]] && [[ ! `echo "${fabricalldeps[ith]}" | fgrep -q -w "${fabricallids[ith]}"` ]] && clientmodids+=( "${fabricallids[ith]}" ) && clientmodfiles+=( "${modsarray[ith]}" )
        done
    fi

    # At this point scanning has been done and either there is a clientmodids array with entries if any were found.

    # If clientmodids[0] is zero / empty
    [[ -z "${clientmodids[0]}" ]] && printf "\n\n\n   $yellow ----------------------------------------- $blue\n\n   $yellow     NO CLIENT ONLY MODS FOUND             $blue\n\n   $yellow ----------------------------------------- $blue\n\n\n" && read -n1 -r -p "Press any key to continue..."

    # If clientmodids[0] is non zero / has entries
    if [[ -n "${clientmodids[0]}" ]]; then
        # prints formatted generated arrays - complete.
        clear
        printf "\n   $yellow THE FOLLOWING CLIENT ONLY MODS WERE FOUND $blue\n    ------------------------------------------------------\n\n"
        # figures out the max string length of all modids found to make nice looking formatting
        maxstrlngth=0
        for ith in "${!clientmodids[@]}"; do
            if [[ "${#clientmodids[ith]}" -gt "${maxstrlngth}" ]]; then maxstrlngth="${#clientmodids[ith]}"; fi
        done
        # prints each found client modid and filename
        for ith in "${!clientmodids[@]}"; do
            let stroffset=$maxstrlngth-${#clientmodids[ith]}
            let stroffset+=2
            printf "   ${clientmodids[ith]}"; printf ' %.0s' $(seq 1 $stroffset); printf "${clientmodfiles[ith]}\n"
        done

        printf "\n    ------------------------------------------------------\n\n\n   $green *** DO YOU WANT TO MOVE THESE CLIENT MODS TO A DIFFERENT FOLDER FOR SAFE KEEPING? *** $blue\n\n        If 'Y' they will NOT be deleted - they WILL be moved to a new folder in the server named $green CLIENTMODS $blue\n        SOME CLIENT MODS ARE NOT CODED TO SELF DISABLE AND WILL CRASH SERVERS IF LEFT IN THE MODS FOLDER\n\n\n"
        printf "     - IF YOU THINK THE CURRENT MASTER LIST IS INNACURATE OR HAVE FOUND A MOD TO ADD -\n        PLEASE CONTACT THE LAUNCHER AUTHOR OR\n        FILE AN ISSUE AT https://github.com/nanonestor/universalator/issues !\n\n   ------------------------------------------------------\n\n      $yellow ENTER YOUR RESPONSE - 'Y' OR 'N' $blue\n\n\n"

        # It would be really annoying to make a while loop that reprints all of the array data so instead just reprint the prompt until Y or N entered
        while [[ "$movemods" != "Y" ]] && [[ "$movemods" != "N" ]]; do
            printf "  $green"; read -p " Enter a command: $blue " movemods; printf "$blue"
            case "${movemods^^}" in
                (Y) movemods="Y";;
                (N) movemods="N" ;;
                (*) printf "\n   Invalid entry, try again. $opt\n\n";;
            esac

        done

        if [[ "$movemods" == "Y" ]]; then
            # If the folder CLIENTMODS does not exist then create it
            [[ ! -d "./CLIENTMODS" ]] && mkdir -p "./CLIENTMODS"
            # for each array element in clientmodids move the corresponding file
            for ith in "${!clientmodids[@]}"; do
                mv "./mods/${clientmodfiles[ith]}" "./CLIENTMODS"
            done
            printf "\n\n   $yellow Moved all found client mods to the folder named 'CLIENTMODS' for storage! $blue \n\n\n"; read -n1 -r -p "  Press any key to continue..."
        fi

        unset movemods
    fi
    # Clears any set arrays
    unset modsarray; unset modslist; unset clientmodids; unset clientmodfiles; unset fabricallids; unset fabricallenvirons; unset fabricalldeps;
}

findmcreator () {
    clear
    printf "\n\n\n   Searching mod JAR files for ones made using MCreator ... .. .\n\n   Please wait!\n"
    # Creates a blank array, and then tries to populate it with the results (filtered to get only the filename) of an fgrep looking for folder names indicative of mods made using MCreator.
    mcreatormods=()
    while IFS='/' read -r one two three; do mcreatormods+=( "$three" ); done < <(fgrep --include=\*.jar -Rli './mods' -e 'net/mcreator' -e '/procedures/' 2>/dev/null)
    # If the array is still empty then just message that none were found.
    [[ -z "${mcreatormods[0]}" ]] && printf "\n\n    $yellow No mod files made using MCreator were found in the mods folder! $blue\n\n\n" && read -n1 -r -p "  Press any key to continue..."
    # If the array is not empty then loop through the array and print which filenames were recorded, also in each loop echo the filename to a txt file.
    if [[ ! -z "${mcreatormods[0]}" ]]; then
        # This echo creates or over-writes any existing file with the same name to a blank txt file.
        echo -n >"mcreator-mods.txt"
        clear
        printf "\n\n           $yellow RESULTS OF Search $blue\n --------------------------------------------- \n\n"

        for ith in "${!mcreatormods[@]}"; do
            echo "${mcreatormods[ith]}" >>"mcreator-mods.txt"
            printf "   ${mcreatormods[ith]}\n"
        done
        printf "\n --------------------------------------------- \n\n   The above mod files were made using MCreator.\n\n  $red They are known to often have severe code problems because of the way they get made. $blue\n\n   A text tile has been generated in this directory, named 'mcreator-mods.txt', listing\n     the mod file names for future reference.\n\n\n"
        read -n1 -r -p "  Press any key to continue..."
    fi
}

override () {
    clear
    if [[ "$javaoverride" == "N" ]]; then
        javaoverride="Y"
        # Uses java -version to get the distribution name and version.  2>&1 redirects the output of java -version from the default stderr to the stdout stream.
        while IFS='' read -r what; do javaname+=( "$what" ); done< <(java -version 2>&1)
        CUSTOMJAVA="${javaname[1]}"; unset javaname
        printf "\n\n\n   $green JAVA OVERRIDE FOR THE CURRENT PROGRAM SESSION ENABLED $blue\n   $yellow Using the following Java set to the $ostype PATH system variable: $blue\n\n     $CUSTOMJAVA\n"
        printf "\n   $yellow GOOD LUCK WITH THAT !! $blue\n\n   $green JAVA OVERRIDE FOR THE CURRENT PROGRAM SESSION ENABLED $blue\n\n\n\n\n"
        read -n1 -r -p "   Press any key to continue..."
    elif [[ "$javaoverride" == "Y" ]]; then
        javaoverride="N"
        printf "\n\n\n   $green JAVA OVERRIDE DISABLED $blue\n\n     The Java override is now disabled and the server launch Java will be the version\n\n       automatically obtained by the Universalator."
        printf "\n\n   $green JAVA OVERRIDE DISBLED $blue\n\n\n\n\n"
        read -n1 -r -p "   Press any key to continue..."
    fi
}

allcommands () {
    while [[ "$allmenu_entry" != "M" ]]; do
        clear
        printf "$univheader"
        printf "\n\n   $green M $blue = MAIN MENU\n   $green S $blue = RE-ENTER ALL SETTINGS\n   $green L $blue = LAUNCH SERVER\n   $green R $blue = SET RAM MAXIMUM AMOUNT\n   $green J $blue = SET JAVA VERSION\n   $green ARCH $blue = SET SYSTEM ARCH TYPE FOR JAVA\n   $green PORT $blue = SET THE PORT TO USE\n\n   $green Q $blue = QUIT\n"
        printf "\n   $green SCAN $blue = SCAN MOD FILES FOR CLIENT ONLY MODS\n   $green UPNP $blue = UPNP PORT FORWARDING MENU\n   $green MCREATOR $blue = SCAN MOD FILES FOR MCREATOR MADE MODS\n   $green OVERRIDE $blue = USE CURRENTLY SET SYSTEM JAVA PATH INSTEAD OF UNIVERSALATOR JAVA\n\n\n"
        printf "  $green"; read -p " Enter a command: $blue " allmenu_entry; printf "$blue"

        case "${allmenu_entry^^}" in
            (L) launchsequence;;
            (S) settingssetup;;
            (R) setmaxram; settingsstamp;;
            (J) setjava; settingsstamp;;
            (SCAN) askscanclients;;
            (MCREATOR) findmcreator;;
            (OVERRIDE) override;;
            (ARCH) setarch; settingsstamp;;
            (PORT) setport;; 
            (Q) let "shouldiquit+=1"; allmenu_entry="M";;
            (M) allmenu_entry="M";;
            (*) printf "\ninvalid option $opt\n\n"; read -n1 -r -p "Press any key to continue...";;
        esac
    done
    unset allmenu_entry
}

# function for MAIN MENU
mainmenu () {
    printf "$univheader"
    printf "\n\n   $yellow CURRENT SETTINGS $blue \n   $yellow MINECRAFT VERSION $blue $MINECRAFT \n   $yellow MODLOADER $blue         $MODLOADER \n"

    [[ "$MODLOADER" == "FORGE" ]] && printf "   $yellow $MODLOADER VERSION $blue     $MODLOADERVERSION \n"
    [[ "$MODLOADER" == "NEOFORGE" ]] && printf "   $yellow $MODLOADER VERSION $blue  $MODLOADERVERSION \n"
    [[ "$MODLOADER" == "FABRIC" ]] && printf "   $yellow $MODLOADER VERSION $blue    $MODLOADERVERSION \n"
    [[ "$MODLOADER" == "QUILT" ]] && printf "   $yellow $MODLOADER VERSION $blue     $MODLOADERVERSION \n"
    [[ "$javaoverride" == "N" ]] && printf "   $yellow JAVA VERSION $blue      $JAVAVERSION "
    [[ "$javaoverride" == "N" ]] && printf "\n   $yellow ARCH TYPE $blue         $OSARCH "
    [[ "$javaoverride" == "Y" ]] && printf "\n   $yellow JAVA VERSION $blue   $green * CUSTOM OVERRIDE - OS JAVA PATH * $blue \n                       $CUSTOMJAVA "
    printf "\n\n\n   $yellow MAX RAM / MEMORY $blue  $MAXRAMGIGS\n\n   $yellow CURRENT PORT SET $blue $PORT                       $green MENU OPTIONS $blue\n\n                                                      $green L $blue = LAUNCH SERVER\n\n                                                      $green S $blue = RE-ENTER ALL SETTINGS"
    printf "\n                                                      $green R $blue    = RAM MAX SETTING\n                                                      $green SCAN $blue = SCAN MOD FILES FOR CLIENT MODS\n                                                      $green A $blue    = (LIST) ALL POSSIBLE MENU OPTIONS\n"

    # Gets user input for menu entry..
    printf "  $green"; read -p " Enter a command: $blue " mainmenu_entry; printf "$blue"
        
    case "${mainmenu_entry^^}" in
        (L)
            launchsequence;;
        (S)
            settingssetup;;
        (R)
            setmaxram; settingsstamp;;
        (J)
            setjava; settingsstamp;;
        (A)
            allcommands;;
        (SCAN)
            askscanclients;; 
        (MCREATOR)
            findmcreator;;
        (OVERRIDE)
            override;;
        (ARCH)
            setarch; settingsstamp;; 
        (PORT)
            setport;; 
        (Q)
            let "shouldiquit+=1";;
        (*) 
            printf "\ninvalid option $opt\n\n"; read -n1 -r -p "Press any key to continue...";;
    esac
}

# SETTINGS DETECTION
    # If linux edition settings file is found then use file to set values.
    if [[ -f "settings-linux-universalator.txt" ]]; then settingscall;
        # If windows settings file is found and no linux settings file is found, then do function to convert it to a linux settings file.
        elif [[ -f "settings-universalator.txt" ]] && [[ ! -f "settings-linux-universalator.txt" ]]; then settingsconverttolinux; settingscall;
        # If neither linux settings nor windows settings are found then go directly to user settings entry.
        elif [[ ! -f "settings-linux-universalator.txt" ]] && [[ ! -f "settings-universalator.txt" ]]; then settingssetup; settingsstamp; settingscall;
    fi

launchsequence () {
    [[ "$javaoverride" == "N" ]] && javacheck
    [[ "$javaoverride" == "Y" ]] && JAVAFILE="java"
    modloadercheck
    eulacheck
    launchmenu
}

javacheck () {
    mkdir -p "univ-utils/java"

# Eveything is done inside an if statement, with exceptions to the standard Adoptium installation handled first, then Adoptium installations in ELSE.

    # The first exception is getting Java 8 for MacOS with aarch64 architecture 
    if [[ "$JAVAVERSION" == "8" ]] && [[ "$ostype" == "mac" ]] && [[ "$OSARCH" == "aarch64" ]]; then
        javafolder=`find ./univ-utils/java -name "*corretto-8*"`

        # If the javafolder variable is not empty then check if a found 'java' file exists to use, and we're done with java setup.
        if [[ -n "$javafolder" ]]; then
            [[ -f "$javafolder/Contents/Home/jre/bin/java" ]] && { JAVAFILE="$javafolder/Contents/Home/jre/bin/java"; getjava="N"; } || { rm -f -r "$javafolder"; getjava="Y"; }
        # If the javafolder variable is empty then definitely need to get it
        else
            getjava="Y"
        fi
        if [[ "$getjava" == "Y" ]]; then
            while [[ "$GOTJAVASTATUS" != "G" ]]; do
                # downloads the binaries file
                curl -sLfo './univ-utils/java/javabinaries.tar.gz' "https://corretto.aws/downloads/latest/amazon-corretto-8-aarch64-macos-jdk.tar.gz" >/dev/null 2>&1

                [[ -f "./univ-utils/java/javabinaries.tar.gz" ]] && GOTJAVASTATUS=G
                if [[ "$GOTJAVASTATUS" == "N" ]]; then printf "   Oops - it looks like the Java files failed to download.\n   You can press any key to try again, or do ctrl+C to close program.\n"; read -n1 -r -p "Press any key to continue..."; fi
            done

            while [[ "$GOTJAVASTATUS" != "Y" ]]; do
                # gets the predicted checksum value of the downloaded binaries file from $javainfo
                JAVACHECKSUM=`curl https://corretto.aws/downloads/latest_sha256/amazon-corretto-8-aarch64-macos-jdk.tar.gz 2>nul`
                # Gets the checksum of the ZIP file downloaded
                while IFS=' ' read -r sum _ _; do filechecksum=$sum; done < <(shasum -a256 ./univ-utils/java/javabinaries.tar.gz)

                if [[ "$JAVACHECKSUM" == "$filechecksum" ]]; then
                    # Extracts the Java binary files from the ZIP file
                    tar -x --directory="./univ-utils/java" --file="./univ-utils/java/javabinaries.tar.gz"
                    # Deletes the ZIP file
                    rm -f "./univ-utils/java/javabinaries.tar.gz"
                    # Re-does the process of finding the Java version folder to save the location
                    javafolder=`find ./univ-utils/java -name "*corretto-8*"`
                    # Saves the java file location (no file extension)
                    JAVAFILE="$javafolder/Contents/Home/jre/bin/java"
                    [[ -f "$JAVAFILE" ]] && GOTJAVASTATUS="Y"
                else
                    printf "\n   Oops - it looks like the downloaded Java ZIP file's checksum did not match what was expected\n   This means the file did not download correctly or something else went wrong.\n   You can press any key to try again, or press ctrl+C to close program.\n"; read -n1 -r -p "Press any key to continue..."
                fi
            done
            # If the versions.txt file exists then get the version number from it, otherwise store a generic JAVANUM for Corretto.
            [[ -f "$javafolder/Contents/Home/version.txt" ]] && JAVANUM="Amazon Corretto `cat "$javafolder/Contents/Home/version.txt"`" || JAVANUM="Amazon Corretto"
        fi
    # All inside of ELSE is the standard Adoptium Java installation.
    else
        [[ "$JAVAVERSION" == "8" ]] && FINDFOLDER="jdk8u"; [[ "$JAVAVERSION" == "11" ]] && FINDFOLDER="jdk-11"; [[ "$JAVAVERSION" == "16" ]] && FINDFOLDER="jdk-16"; [[ "$JAVAVERSION" == "17" ]] && FINDFOLDER="jdk-17"; [[ "$JAVAVERSION" == "21" ]] && FINDFOLDER="jdk-21";
        # Does a find search of directories for the string that the set java version would have
        javafolder=`find ./univ-utils/java -name "*$FINDFOLDER*"`
        # If the javafolder variable is not empty then consider check to see if it's a valid version for this arch type
        if [[ -n "$javafolder" ]]; then
            # Adjusts the location of the release file based on linux or mac.
            [[ "$ostype" == "linux" ]] && releaseloc="$javafolder/release"; [[ "$ostype" == "mac" ]] && releaseloc="$javafolder/Contents/Home/release"
            # Gets the value named OS_ARCH from the java release file
            [[ -f "$releaseloc" ]] && while IFS='="' read -r _ ver; do javaarch="${ver//\"/}"; done < <(fgrep "OS_ARCH" "$releaseloc")
            # Gets the arch name for the current OSARCH setting.  Unfortunately some values that Adoptium uses for their url links are slightly different than the actual arch name.
            [[ "$OSARCH" == "x64" ]] && setarch="x86_64" || setarch="${OSARCH}"
            # For some reason x84_64 linux versions have the value amd64 in Adoptium java 8 versions, so correct any amd64 value to x86_64
            [[ "$javaarch" == "amd64" ]] && javaarch="x86_64"
            # Checks to see if the setarch matches the OSARCH setting.  If it does then don't get java, if it does not remove the folder and getjava
            [[ "${setarch,,}" == "${javaarch,,}" ]] && getjava="N" || { getjava=Y; rm -f -r "$javafolder"; }
        fi

        # If no javafolder then get java
        [[ ! -n "$javafolder" ]] && getjava="Y"

        if [[ $getjava == "N" ]]; then
            # Sets a var that will be true or false to whether the java folder is older than 2 months
            d2=`date +%s`; d1=`date -r "$javafolder" +%s`; let diff_days=($d2-$d1)/86400
            [[ "$diff_days" -gt 45 ]] && isjavaold="True" || isjavaold="False"

            # If the folder is not old then only set JAVAFILE to this folder
            if [[ "$isjavaold" == "False" ]]; then
                # Sets the location of the java file (no file extension) based on ostype
                [[ "$ostype" == "linux" ]] && JAVAFILE="$javafolder/bin/java"; [[ "$ostype" == "mac" ]] && JAVAFILE="$javafolder/Contents/Home/bin/java"
                getjava=N
            # IF else, then the folder is 'old'
            else
                # Checks to see if the current version is in fact the newest version - first need to get the actual folder name only
                while IFS='/' read -r _ _ _ folder; do jfolder=$folder; done <<<$javafolder
                # Gets the newest version number for the major Java version
                [[ $JAVAVERSION != "16" ]] && IMAGETYPE="jdk" || IMAGETYPE="jre"
                javainfo=`curl -sX 'GET' "https://api.adoptium.net/v3/assets/latest/$JAVAVERSION/hotspot?architecture=$OSARCH&image_type=$IMAGETYPE&os=$ostype&vendor=eclipse" -H 'accept: application/json'`

                newestjava=`echo "$javainfo" | jq --raw-output '.[].release_name'`

                # Does a grep search of the newest version number on the folder name
                echo $jfolder | grep "$newestjava" >nul
                # If success in finding the newestjava string in the folder string then don't get java, if failed then replace this version with the newest version
                [[ "$?" == "0" ]] && { getjava=N; [[ "$ostype" == "linux" ]] && JAVAFILE="$javafolder/bin/java"; [[ "$ostype" == "mac" ]] && JAVAFILE="$javafolder/Contents/Home/bin/java"; }
                [[ "$?" != "0" ]] && { getjava=Y; rm -f -r "$javafolder"; }
            fi
        fi

        if [[ "$getjava" == "Y" ]]; then
            GOTJAVASTATUS=N

            # stores as $javainfo the information json that gets returned from Adoptium for the selected java version
            [[ $JAVAVERSION != "16" ]] && IMAGETYPE="jre" || IMAGETYPE="jdk"
            javainfo=`curl -sX 'GET' "https://api.adoptium.net/v3/assets/latest/$JAVAVERSION/hotspot?architecture=$OSARCH&image_type=$IMAGETYPE&os=$ostype&vendor=eclipse" -H 'accept: application/json'`

            # gets the url to the java binaries from $javainfo
            java_binaries_url=`echo "$javainfo" | jq --raw-output '.[].binary.package.link'`

            while [[ "$GOTJAVASTATUS" != "G" ]]; do
                # downloads the binaries file
                curl -sLfo './univ-utils/java/javabinaries.tar.gz' "$java_binaries_url" >/dev/null 2>&1

                [[ -f "./univ-utils/java/javabinaries.tar.gz" ]] && GOTJAVASTATUS=G
                if [[ "$GOTJAVASTATUS" == "N" ]]; then printf "   Oops - it looks like the Java files failed to download.\n   You can press any key to try again, or do ctrl+C to close program.\n"; read -n1 -r -p "Press any key to continue..."; fi
            done

            while [[ "$GOTJAVASTATUS" != "Y" ]]; do
                # gets the predicted checksum value of the downloaded binaries file from $javainfo
                JAVACHECKSUM=`echo $javainfo | jq --raw-output '.[].binary.package.checksum'`

                # Gets the checksum of the ZIP file downloaded
                while IFS=' ' read -r sum _ _; do filechecksum=$sum; done < <(shasum -a256 ./univ-utils/java/javabinaries.tar.gz)

                if [[ "$JAVACHECKSUM" == "$filechecksum" ]]; then
                    # Extracts the Java binary files from the ZIP file
                    tar -x --directory="./univ-utils/java" --file="./univ-utils/java/javabinaries.tar.gz"
                    # Deletes the ZIP file
                    rm -f "./univ-utils/java/javabinaries.tar.gz"
                    # Re-does the process of finding the Java version folder to save the location
                    javafolder=`find ./univ-utils/java -name "*$FINDFOLDER*"`
                    JAVAFILE="$javafolder/bin/java"
                    # Saves the java file location (no file extension) based on ostype
                    [[ "$ostype" == "linux" ]] && JAVAFILE="$javafolder/bin/java"; [[ "$ostype" == "mac" ]] && JAVAFILE="$javafolder/Contents/Home/bin/java";
                    [[ -f "$JAVAFILE" ]] && GOTJAVASTATUS="Y"
                else
                    printf "\n   Oops - it looks like the downloaded Java ZIP file's checksum did not match what was expected\n   This means the file did not download correctly or something else went wrong.\n   You can press any key to try again, or press ctrl+C to close program.\n"; read -n1 -r -p "Press any key to continue..."
                fi
            done
        fi
        # At this point Java should have either been found or downloaded.
        # Runs this command one more time to guarante it gets jfolder depending on above, then strips out extraneious info for later use
        while IFS='/' read -r _ _ _ folder; do jfolder=$folder; done <<<$javafolder
        JAVANUM=${jfolder/jdk-/}; JAVANUM=${JAVANUM/-jdk/}; JAVANUM=${JAVANUM/jdk/}; JAVANUM=${JAVANUM/-jre/}; JAVANUM=${JAVANUM/-LTS/}; JAVANUM="Adoptium $JAVANUM"
    fi
}

modloadercheck () {
    getmajorminor
    FOUNDMODLOADER="N"
    if [[ "$MODLOADER" == "FORGE" ]]; then
        # Each of these type are unique to the combination of Minecraft & Forge version, so if any of these exist for that combination then assume installed - otherwise set N for getting new files.
        
        { { [[ "$mcmajor" -ge "17" ]] && [[ "$mcmajor" -le "19" ]]; } || { [[ "$mcmajor" == "20" ]] && [[ "$mcminor" -le "3" ]]; } } && FORGETYPE="NEWOLD" # between MC 17 and 19, and MC 1.20-1.20.3
        { { [[ "$mcmajor" == "20" ]] && [[ "$mcminor" -ge "4" ]]; } || { [[ "$mcmajor" -ge "21" ]]; } } && FORGETYPE="NEWNEW" # MC 1.20.4 to any 1.20.x newer , and MC >= 21
        [[ "$mcmajor" -ge "10" ]] && [[ "$mcmajor" -le "16" ]] && FORGETYPE="OLDISH" # MC equal to and between 10 and 16
        [[ "$mcmajor" -lt "10" ]] && FORGETYPE="WAYOLD" # MC less than 10

        # If Forge is in this range then there is no JAR file to look for in the main dir.
        [[ "$FORGETYPE" == "NEWOLD" ]] && [[ -d "./libraries/net/minecraftforge/forge/$MINECRAFT-$MODLOADERVERSION" ]] && FOUNDMODLOADER="Y"
        # If Forge is in this range then there is a JAR file to look for in the main dir.
        [[ "$FORGETYPE" == "NEWNEW" ]] && { [[ -d "./libraries/net/minecraftforge/forge/$MINECRAFT-$MODLOADERVERSION" ]] && [[ -f "forge-$MINECRAFT-$MODLOADERVERSION-shim.jar" ]]; } && FOUNDMODLOADER="Y"
        # If OLDISH then there should also be a JAR file in the main dir, but a different name that does not end in -shim
        [[ "$FORGETYPE" == "OLDISH" ]] && { [[ -f "forge-$MINECRAFT-$MODLOADERVERSION.jar" ]] && [[ -d "./libraries/net/minecraftforge/forge/$MINECRAFT-$MODLOADERVERSION" ]]; } && FOUNDMODLOADER="Y"
        # If WAYOLD then what gets put in the libraries folder varies - just don't bother even checking in there, only look for the main JAR file.
        [[ "$FORGETYPE" == "WAYOLD" ]] && {
        [[ -f "minecraftforge-universal-$MINECRAFT-$MODLOADERVERSION.jar" ]] && FOUNDMODLOADER="Y"
        [[ -f "forge-$MINECRAFT-$MODLOADERVERSION-$MINECRAFT-universal.jar" ]] && FOUNDMODLOADER="Y"
        [[ -f "forge-$MINECRAFT-$MODLOADERVERSION-universal.jar" ]] && FOUNDMODLOADER="Y"
        }
    fi
    if [[ "$MODLOADER" == "NEOFORGE" ]]; then
        # Neoforge has two types of install locations, one for the inagural 1.20.1 version, and everything newer.
        [[ "$MINECRAFT" == "1.20.1" ]] && [[ -d "./libraries/net/neoforged/forge/$MINECRAFT-$MODLOADERVERSION" ]] && FOUNDMODLOADER="Y"
        [[ "$MINECRAFT" != "1.20.1" ]] && [[ -d "./libraries/net/neoforged/neoforge/$MODLOADERVERSION" ]] && FOUNDMODLOADER="Y"
    fi

    [[ "$MODLOADER" == "FABRIC" ]] && [[ -f "fabric-server-launch-$MINECRAFT-$MODLOADERVERSION.jar" ]] && [[ -f "./libraries/net/fabricmc/fabric-loader/$MODLOADERVERSION/fabric-loader-$MODLOADERVERSION.jar" ]] && FOUNDMODLOADER="Y"
    [[ "$MODLOADER" == "QUILT" ]] && [[ -f "quilt-server-launch-$MINECRAFT-$MODLOADERVERSION.jar" ]] && [[ -f "libraries/org/quiltmc/quilt-loader/$MODLOADERVERSION/quilt-loader-$MODLOADERVERSION.jar" ]] && FOUNDMODLOADER="Y"
    [[ "$MODLOADER" == "VANILLA" ]] && [[ -f "minecraft_server.$MINECRAFT.jar" ]] && FOUNDMODLOADER="Y"

    if [[ "$FOUNDMODLOADER" == "N" ]]; then
        dnscheck
        pingthing "$MODLOADER"
        installmodloader
    fi
}

installmodloader () {
    # Removes any existing installation files, so that a new clean installation can be done.
    rm -f *.jar
    rm -f -r "./libraries"
    rm -f -r "./.fabric"

    # Sets to get the vanilla JAR for either VANILLA modloader or older versions of forge, some of which have old installer JARs which do not have
    # valid links to Mojang file servers because Mojang changed servers at one point.
    GETVANILLA="N"
    [[ "$MODLOADER" == "VANILLA" ]] && GETVANILLA="Y"
    [[ "$MODLOADER" == "FORGE" ]] && [[ "$mcmajor" -le "16" ]] && GETVANILLA="Y"
    if [[ "$GETVANILLA" == "Y" ]]; then
        mojangmanifest
        FOUNDGOODMCJAR="N"
        while [[ "$FOUNDGOODMCJAR" != "Y" ]]; do
            # Silently tries to delete any possible existing corrupted JAR file obtained in a previous loop.
            rm -f "minecraft_server.$MINECRAFT.jar" >/dev/null 2>&1

            # gets the MC version json information file if it doesn't exist yet
            if [[ ! -f "./univ-utils/versions/$MINECRAFT.json" ]]; then
                [[ ! -d "./univ-utils/versions" ]] && mkdir -p "./univ-utils/versions"
                version_json_url=`jq --raw-output --arg mcr $MINECRAFT '.versions[] | select ( .id == $mcr ) | .url' "./univ-utils/version_manifest_v2.json"`
                curl -sLfo "./univ-utils/versions/$MINECRAFT.json" "$version_json_url"
            fi

            # gets the server JAR download url location, and the expected SHA1 checksum they provide
            mc_serverjar_url=`jq --raw-output '.downloads.server.url' "./univ-utils/versions/$MINECRAFT.json"`
            mc_serverjar_chksum=`jq --raw-output '.downloads.server.sha1' "./univ-utils/versions/$MINECRAFT.json"`

            # Actually downloads the server JAR file
            curl -sLfo "minecraft_server.$MINECRAFT.jar" "$mc_serverjar_url"

            if [[ -f "minecraft_server.$MINECRAFT.jar" ]]; then
                # Gets the file checksum of the JAR obtained - default with no flags to shasum is SHA1, which is what Mojang provides.
                while IFS=' ' read -r sum _ _; do filechecksum=$sum; done < <(shasum "minecraft_server.$MINECRAFT.jar")

                # If the checksums match then accept the vanilla server JAR and exit the loop.
                [[ "$mc_serverjar_chksum" == "$filechecksum" ]] && FOUNDGOODMCJAR="Y"
                if [[ "$mc_serverjar_chksum" != "$filechecksum" ]]; then printf "\n   Oops - it looks like the downloaded Minecraft server JAR file's checksum did not match what was expected\n   This means the file did not download correctly or something else went wrong.\n   You can press any key to try again, or press ctrl+C to close program.\n"; read -n1 -r -p "Press any key to continue..."; fi
            fi
            if [[ ! -f "minecraft_server.$MINECRAFT.jar" ]]; then printf "\n   Oops - it looks like the Minecraft server JAR file did not download?\n   You can press any key to try again, or press ctrl+C to close program.\n"; read -n1 -r -p "Press any key to continue..."; fi
        done
    fi

    # Breaks up modded modloader installation by by type - DNS has already been checked and websites pinged!
    [[ "$MODLOADER" == "FORGE" ]] && installforge
    [[ "$MODLOADER" == "NEOFORGE" ]] && installneoforge
    [[ "$MODLOADER" == "FABRIC" ]] && installfabric
    [[ "$MODLOADER" == "QUILT" ]] && installquilt
}
installforge () {
    [[ "$mcmajor" -le "6" ]] && FORGEFILENAMEORDER="$MINECRAFT-$MODLOADERVERSION"
    [[ "$mcmajor" -ge "7" ]] && [[ "$mcmajor" -le "9" ]] && FORGEFILENAMEORDER="$MINECRAFT-$MODLOADERVERSION-$MINECRAFT"
    [[ "$mcmajor" -ge "10" ]] && FORGEFILENAMEORDER="$MINECRAFT-$MODLOADERVERSION"

    while [[ "$FOUNDMODLOADER" != "Y" ]]; do
        curl -sLfo forge-installer.jar https://maven.minecraftforge.net/net/minecraftforge/forge/$FORGEFILENAMEORDER/forge-$FORGEFILENAMEORDER-installer.jar  >/dev/null 2>&1

        if [[ -f "forge-installer.jar" ]]; then
            $JAVAFILE -Djava.net.preferIPv4Stack=true -XX:+UseG1GC -jar forge-installer.jar --installServer
            rm -f "forge-installer.jar" >/dev/null 2>&1
            rm -f "forge-installer.jar.log" >/dev/null 2>&1
            rm -f run.* >/dev/null 2>&1
            rm -f "user_jvm_args.txt" >/dev/null 2>&1

            [[ -d "./libraries/net/minecraftforge/forge/$MINECRAFT-$MODLOADERVERSION" ]] && FOUNDMODLOADER="Y"
            [[ -f "forge-$MINECRAFT-$MODLOADERVERSION.jar" ]] && FOUNDMODLOADER="Y"
            [[ -f "minecraftforge-universal-$MINECRAFT-$MODLOADERVERSION.jar" ]] && FOUNDMODLOADER="Y"
            [[ -f "forge-$MINECRAFT-$MODLOADERVERSION-$MINECRAFT-universal.jar" ]] && FOUNDMODLOADER="Y"
            [[ -f "forge-$MINECRAFT-$MODLOADERVERSION-universal.jar" ]] && FOUNDMODLOADER="Y"

            if [[ "$FOUNDMODLOADER" == "N" ]]; then
                rm -f forge*.jar
                rm -r "./libraries"
                printf "\n   Oops - it looks like the FORGE Installer tried to install, but successful installation was not detected?\n   You can press any key to try again, or press ctrl+C to close program.\n\n"; read -n1 -r -p "Press any key to continue..."
            fi
        else
            printf "\n   Oops - it looks like the FORGE Installer JAR file did not download?\n   You can press any key to try again, or press ctrl+C to close program.\n\n"; read -n1 -r -p "Press any key to continue..."
        fi
    done
}

installneoforge () {
    while [[ "$FOUNDMODLOADER" != "Y" ]]; do
        [[ "$MINECRAFT" == "1.20.1" ]] && curl -sLfo neoforge-installer.jar https://maven.neoforged.net/releases/net/neoforged/forge/$MINECRAFT-$MODLOADERVERSION/forge-$MINECRAFT-$MODLOADERVERSION-installer.jar >/dev/null 2>&1
        [[ "$MINECRAFT" != "1.20.1" ]] && curl -sLfo neoforge-installer.jar https://maven.neoforged.net/releases/net/neoforged/neoforge/$MODLOADERVERSION/neoforge-$MODLOADERVERSION-installer.jar >/dev/null 2>&1

        if [[ -f "neoforge-installer.jar" ]]; then
            $JAVAFILE -Djava.net.preferIPv4Stack=true -XX:+UseG1GC -jar neoforge-installer.jar --installServer
            rm -f "neoforge-installer.jar" >/dev/null 2>&1
            rm -f "neoforge-installer.jar.log" >/dev/null 2>&1
            rm -f run.* >/dev/null 2>&1
            rm -f "user_jvm_args.txt" >/dev/null 2>&1

            [[ "$MINECRAFT" == "1.20.1" ]] && [[ -d "./libraries/net/neoforged/forge/$MINECRAFT-$MODLOADERVERSION" ]] && FOUNDMODLOADER="Y"
            [[ "$MINECRAFT" != "1.20.1" ]] && [[ -d "./libraries/net/neoforged/neoforge/$MODLOADERVERSION" ]] && FOUNDMODLOADER="Y"

            if [[ "$FOUNDMODLOADER" == "N" ]]; then
                rm -f neoforge*.jar
                rm -f -r "./libraries"
                printf "\n   Oops - it looks like the NEOFORGE Installer tried to install, but successful installation was not detected?\n   You can press any key to try again, or press ctrl+C to close program.\n\n"; read -n1 -r -p "Press any key to continue..."
            fi
        else
            printf "\n   Oops - it looks like the NEOFORGE Installer JAR file did not download?\n   You can press any key to try again, or press ctrl+C to close program.\n\n"; read -n1 -r -p "Press any key to continue..."
        fi
    done
}

installfabric () {
    # gets the metadata xml file for fabric installer versions, and then uses the xmlstarlet utility to record the newest version listed in the release property
    fabricinstaller_xml=`curl -s https://maven.fabricmc.net/net/fabricmc/fabric-installer/maven-metadata.xml`
    FABRICINSTALLER=`xmlstarlet sel -t -v "//versioning/release" <<<"$fabricinstaller_xml"`

    while [[ "$FOUNDMODLOADER" != "Y" ]]; do
        # Downloads the Fabric installer for the found newest version
        curl -sLfo fabric-installer.jar https://maven.fabricmc.net/net/fabricmc/fabric-installer/$FABRICINSTALLER/fabric-installer-$FABRICINSTALLER.jar >/dev/null 2>&1

        if [[ -f "fabric-installer.jar" ]]; then
            # Uses curl to get the provided SHA256 checksum for the same installer from the fabric website.
            fabric_installer_chksum=`curl -s https://maven.fabricmc.net/net/fabricmc/fabric-installer/$FABRICINSTALLER/fabric-installer-$FABRICINSTALLER.jar.sha256`

            # Gets the checksum of the Fabric installer file downloaded
            while IFS=' ' read -r sum _ _; do filechecksum=$sum; done < <(shasum -a256 fabric-installer.jar)
            if [[ "$filechecksum" == "$fabric_installer_chksum" ]]; then
                $JAVAFILE -XX:+UseG1GC -jar fabric-installer.jar server -loader $MODLOADERVERSION -mcversion $MINECRAFT -downloadMinecraft
            else
                printf "\n   Oops - it looks like the checksum between the Fabric Installer file and what was expected was different?\n   This means download was either incomplete or incorrect.\n   You can press any key to try again, or press ctrl+C to close program.\n\n"; read -n1 -r -p "Press any key to continue...";
            fi
            rm -f fabric-installer*  >/dev/null 2>&1

            if [[ -f "fabric-server-launch.jar" ]]; then
                mv fabric-server-launch.jar fabric-server-launch-$MINECRAFT-$MODLOADERVERSION.jar
                FOUNDMODLOADER="Y"
            else
                printf "\n   Oops - it looks like for some reason the Fabric launch JAR was not found from the Fabric intallation process?\n   You can press any key to try again, or press ctrl+C to close program.\n\n"; read -n1 -r -p "Press any key to continue...";
            fi
        else
            printf "\n   Oops - it looks like the Fabric installer file was not downloaded?\n   You can press any key to try again, or press ctrl+C to close program.\n\n"; read -n1 -r -p "Press any key to continue...";
        fi
    done
}

installquilt () {
    # gets the metadata xml file for quilt installer versions, and then uses the xmlstarlet utility to record the newest version listed in the release property
    quiltinstaller_xml=`curl -s https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/maven-metadata.xml`
    QUILTINSTALLER=`xmlstarlet sel -t -v "//versioning/release" <<<"$quiltinstaller_xml"`

    while [[ "$FOUNDMODLOADER" != "Y" ]]; do
        # Downloads the Quilt installer for the found newest version
        curl -sLfo quilt-installer.jar https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/$QUILTINSTALLER/quilt-installer-$QUILTINSTALLER.jar >/dev/null 2>&1

        if [[ -f "quilt-installer.jar" ]]; then
            # Uses curl to get the provided SHA256 checksum for the same installer from the quilt website.
            quilt_installer_chksum=`curl -s https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/$QUILTINSTALLER/quilt-installer-$QUILTINSTALLER.jar.sha256`

            # Gets the checksum of the Quilt installer file downloaded
            while IFS=' ' read -r sum _ _; do filechecksum=$sum; done < <(shasum -a256 quilt-installer.jar)
            if [[ "$filechecksum" == "$quilt_installer_chksum" ]]; then
                $JAVAFILE -XX:+UseG1GC -jar quilt-installer.jar install server $MINECRAFT $MODLOADERVERSION --download-server --install-dir="./"
            else
                printf "\n   Oops - it looks like the checksum between the Quilt Installer file and what was expected was different?\n   This means download was either incomplete or incorrect.\n   You can press any key to try again, or press ctrl+C to close program.\n\n"; read -n1 -r -p "Press any key to continue...";
            fi
            rm -f quilt-installer*  >/dev/null 2>&1

            if [[ -f "quilt-server-launch.jar" ]]; then
                mv quilt-server-launch.jar quilt-server-launch-$MINECRAFT-$MODLOADERVERSION.jar
                FOUNDMODLOADER="Y"
            else
                printf "\n   Oops - it looks like for some reason the Quilt launch JAR was not found from the Quilt intallation process?\n   You can press any key to try again, or press ctrl+C to close program.\n\n"; read -n1 -r -p "Press any key to continue...";
            fi
        else
            printf "\n   Oops - it looks like the Quilt installer file was not downloaded?\n   You can press any key to try again, or press ctrl+C to close program.\n\n"; read -n1 -r -p "   Press any key to continue...";
        fi
    done
}

eulacheck () {
    [[ ! -f "eula.txt" ]] && seteula="Y"
    [[ -f "eula.txt" ]] && [[ ! `fgrep "eula=true" "eula.txt"` ]] && seteula="Y"

    if [[ "$seteula" == "Y" ]]; then 
        while [[ "${eulaentry,,}" != "agree" ]]; do
            clear
            printf "\n\n\n   Mojang's EULA has not yet been accepted. In order to run a Minecraft server, you must accept Mojang's EULA.\n   Mojang's EULA is available to read at https://account.mojang.com/documents/minecraft_eula\n"
            printf "\n     $yellow If you agree to Mojang's EULA then type 'AGREE' $blue\n\n     $yellow ENTER YOUR RESPONSE $blue\n"
            printf "\n  $green"; read -p " Entry: $blue " eulaentry; printf "$blue"
            [[ "${eulaentry,,}" != "agree" ]] && { printf "\n   $red Invalid entry - try again $blue\n\n"; read -n1 -r -p "   Press any key to continue..."; }
        done

        printf "eula=true">eula.txt
    fi
}

launchmenu () {
    LAUNCHLOOP="U"
    while [[ "$LAUNCHLOOP" != "M" ]] && [[ "$LAUNCHLOOP" != "Q" ]]; do
        clear
        printf "$univheader"
        printf "\n   $yellow READY TO LAUNCH $MODLOADER SERVER! $blue\n\n        CURRENT SERVER SETTINGS:\n        MINECRAFT - $MINECRAFT\n"
        [[ "${MODLOADER^^}" != "VANILLA" ]] && printf "        $MODLOADER - $MODLOADERVERSION\n"
        [[ "${MODLOADER^^}" == "VANILLA" ]] && printf "        $MODLOADER\n"
        [[ "$javaoverride" == "N" ]] && printf "        JAVA - $JAVAVERSION / $JAVANUM\n"
        [[ "$javaoverride" == "Y" ]] && printf "        JAVA - CUSTOM OVERRIDE - $CUSTOMJAVA\n"
        printf " \n ============================================\n   $yellow CURRENT NETWORK SETTINGS:$blue\n\n    PUBLIC IPv4 AND PORT      - $green $PUBLICIP:$PORT $blue\n    LAN IPv4 AND PORT         - $green $LOCALIP:$PORT $blue\n    TO CONNECT ON SAME PC USE - $green localhost $blue < This text\n"
        printf "\n ============================================ \n\n   $yellow READY TO LAUNCH FORGE SERVER! $blue\n\n            $yellow ENTER 'M' FOR MAIN MENU $blue\n            $yellow ENTER L FOR LAUNCH $blue\n\n"
        printf "  $green"; read -p " Enter a command: $blue " launchmenu; printf "$blue"
        
        case "${launchmenu^^}" in
            (L) launch;;
            # If M then the launchloop exits and main menu resumes
            (M) LAUNCHLOOP="M";;
            # If Q then launchloop exits 
            (Q) let "shouldiquit+=1"; LAUNCHLOOP="Q";;
            # If any other string is entered then launch
            (*) printf "\n   $red Invalid entry - try again $blue\n\n"; read -n1 -r -p "   Press any key to continue...";;
        esac
        printf "${blue}"
        clear
    done

}

launch () {
    MAXRAM="-Xmx${MAXRAMGIGS}G"
    getmajorminor
    # Resizes the terminal if the resize command is recognized
    [[ `command -v resize` ]] && printf '\e[8;35;125t' 2>/dev/null

    #{ sleep 20 ; stop; } &
    #nohup sleep 20 && stop >nul &

    [[ "$MODLOADER" == "FORGE" ]] && (

        [[ "$mcmajor" -le "6" ]] && $JAVAFILE -server $MAXRAM $ARGS $OTHERARGS -jar minecraftforge-universal-$MINECRAFT-$MODLOADERVERSION.jar nogui

        [[ "$mcmajor" -ge "7" ]] && [[ "$mcmajor" -le "10" ]] && $JAVAFILE -server $MAXRAM $ARGS $OTHERARGS -jar forge-$MINECRAFT-$MODLOADERVERSION-$MINECRAFT-universal.jar nogui
 
        [[ "$mcmajor" -ge "11" ]] && [[ "$mcmajor" -le "16" ]] && $JAVAFILE -server $MAXRAM $ARGS $OTHERARGS -jar forge-$MINECRAFT-$MODLOADERVERSION.jar nogui

            # The rules for the below could be arranged differently next to the launch commands, but this way is funnier.
            [[ "$mcmajor" -ge "17" ]] && [[ "$mcmajor" -le "19" ]] && LAUNCHFORGE="NEWOLD"
            [[ "$mcmajor" == "20" ]] && [[ "$mcminor" -ge "4" ]] && LAUNCHFORGE="NEWNEW"
            [[ "$mcmajor" -ge "21" ]] && LAUNCHFORGE="NEWNEW"

        [[ "$LAUNCHFORGE" == "NEWOLD" ]] && $JAVAFILE -server $MAXRAM $ARGS $OTHERARGS @libraries/net/minecraftforge/forge/$MINECRAFT-$MODLOADERVERSION/unix_args.txt nogui "$@"
        [[ "$LAUNCHFORGE" == "NEWNEW" ]] && $JAVAFILE -server $MAXRAM $ARGS $OTHERARGS -jar forge-$MINECRAFT-$MODLOADERVERSION-shim.jar nogui

    )
    [[ "$MODLOADER" == "NEOFORGE" ]] && (
        # Neoforge has two launch commands, one for only the inagural 1.20.1, and the newer for everthing newer.
        [[ "$MINECRAFT" == "1.20.1" ]] && $JAVAFILE -server $MAXRAM $ARGS $OTHERARGS @libraries/net/neoforged/forge/$MINECRAFT-$MODLOADERVERSION/unix_args.txt nogui "$@"

        [[ "$MINECRAFT" != "1.20.1" ]] && $JAVAFILE -server $MAXRAM $ARGS $OTHERARGS @libraries/net/neoforged/neoforge/$MODLOADERVERSION/unix_args.txt nogui "$@"

    )

    [[ "$MODLOADER" == "FABRIC" ]] && $JAVAFILE -server $MAXRAM $ARGS $OTHERARGS -jar fabric-server-launch-$MINECRAFT-$MODLOADERVERSION.jar nogui
    
    [[ "$MODLOADER" == "QUILT" ]] && $JAVAFILE -server $MAXRAM $ARGS $OTHERARGS -jar quilt-server-launch-$MINECRAFT-$MODLOADERVERSION.jar nogui

    [[ "$MODLOADER" == "VANILLA" ]] && $JAVAFILE -server $MAXRAM $ARGS $OTHERARGS -jar minecraft_server.$MINECRAFT.jar nogui

    read -n1 -r -p "Press any key to continue..."
    # Resizes the terminal back to the normal size if resize comand is recognized.
    [[ `command -v resize` ]] && printf '\e[8;30;98t' 2>/dev/null
}



# MAIN MENU - ACTUAL LOOP THAT KEEPS THE SCRIPT RUNNING OR ELSE EXITS

[[ -z "$param1" ]] && while [[ $shouldiquit == 1 ]]; do 
    mainmenu
    clear
done

[[ "$param1" != "" ]] && echo "it is $param1"

# EXIT - printf resets the terminal font color to default, clear wipes existing text off the screen (if no parameters were set).
[[ -z "$param1" ]] && { printf "$norm"; clear; }
exit 0
# EXIT - DO NOT CHANGE ABOVE - NEEDED TO CLOSE SCRIPT

