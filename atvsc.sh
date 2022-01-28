#!/bin/bash
# ADB Script Sammlung
# version 1.0
# created by GhostTalker
#

### read values from config.ini
. $SCRIPTPATH/config.ini

### set path
CONFIGPATH=$SCRIPTPATH
LOGPATH=$SCRIPTPATH/log
TMPPATH=$SCRIPTPATH/tmp
LIBPATH=$SCRIPTPATH/lib

### loading script library ###
. $LIBPATH/atvsc.lib

### Set UTF8 for menue drawing
export NCURSES_NO_UTF8_ACS=1

# submenu1
deviceselect() {

  TITLE="Device Select Menue"
  MENU="Choose one of the following options:"
  
  OPTIONS=(1 "All ATV"
           2 "Select ATV"
  		   3 "Back to Main Menue")
  
  CHOICE=$(dialog --clear \
                  --backtitle "$BACKTITLE" \
                  --title "$TITLE" \
                  --menu "$MENU" \
                  $HEIGHT $WIDTH $CHOICE_HEIGHT \
  				  "${OPTIONS[@]}" \
                  2>&1 >/dev/tty)
  
  clear
  
    case $CHOICE in
            1)  echo "All ATV"
  		        deviceipliste=`readDeviceList_ip $DEVICECONFIG`
  			    $menueoption $deviceipliste
				read -p "Press enter to continue"
				mainmenue;;
            2)  echo "Select ATV"
  			    deviceselectsingle;;
            3)  echo "Back to Main Menue"
  		        menueoption=""
  			    mainmenue;;
    esac
  
}

# submenu2
deviceselectsingle() {
  declare -a array
  
   i=1 #Index counter for adding to array
   j=1 #Option menu value generator

   deviceipliste=`readDeviceList_ip $DEVICECONFIG`
   
   for deviceip in $deviceipliste
   do     
      array[ $i ]=$j
      (( j++ ))
      array[ ($i + 1) ]=$deviceip
      (( i=($i+2) ))
   done
  
   #Define parameters for menu
   TITLE="Device Select Menue"
   MENU="Choose a ATV:"
  
   #Build the menu with variables & dynamic content
   CHOICE=$(dialog --clear \
                   --backtitle "$BACKTITLE" \
                   --title "$TITLE" \
                   --menu "$MENU" \
                   $HEIGHT $WIDTH $CHOICE_HEIGHT \
                   "${array[@]}" \
                   2>&1 >/dev/tty)


   deviceipliste=${array[($CHOICE*2)]}
   clear
   $menueoption $deviceipliste
   read -p "Press enter to continue"
   mainmenue
}


#main menue
mainmenue() {

  HEIGHT=20
  WIDTH=60
  CHOICE_HEIGHT=16
  BACKTITLE="MadClusterNet - Script Collection"
  TITLE="Main Menue"
  MENU="Choose one of the following options:"
  
  OPTIONS=(1 "Set Proxy on ATV"
           2 "Uninstall Pogo on ATV"
           3 "Reboot ATV"
  		   4 "Exit")
  
  CHOICE=$(dialog --clear \
                  --backtitle "$BACKTITLE" \
                  --title "$TITLE" \
                  --menu "$MENU" \
                  $HEIGHT $WIDTH $CHOICE_HEIGHT \
  				  "${OPTIONS[@]}" \
                  2>&1 >/dev/tty)
  
  clear
  
    case $CHOICE in
            1)  echo "Set Proxy on ATV"
  		        menueoption=menueSetProxy
  			    deviceselect;;
            2)  echo "Uninstall Pogo"
  		        menueoption=menueUninstallPogo
  			    deviceselect;;
            3)  echo "Reboot ATV"
  		        menueoption=menueReboot
  			    deviceselect;;
            4)  return;;
    esac
	
}

mainmenue
exit
