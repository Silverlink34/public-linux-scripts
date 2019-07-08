#!/bin/bash

getExtensionDetails() {
	extension=$1
	extensionName=`asterisk -rx "sip show peer $extension" | grep Callerid | grep -oP '"\K[^"\047]+(?=["\047])'`
	phoneTypeAndFirmware=`asterisk -rx "sip show peer $extension" | grep Useragent | grep -oP '(?<=:).*'`
	echo "------------------"
	echo "Extension Name: $extensionName"
	echo "Extension Number: $extension"
	echo "Extension Phone Type & Firmware: $phoneTypeAndFirmware"
	echo "------------------"
	echo ""
}

if [ "$#" -lt "1" ];then
	IFS_bak=$IFS
	IFS=$'\n'
	extensions=( $(asterisk -rx 'sip show peers' | grep "^[0-9]" | grep -v 'sip peers' | grep -o '^[^ \/]*') )
	IFS=$IFS_bak
	for extension in "${extensions[@]}"
	do
		getExtensionDetails $extension
	done
else
	extension=$@
	getExtensionDetails $extension
fi
