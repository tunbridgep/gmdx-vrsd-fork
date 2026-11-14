#!/bin/sh
if [ ! -f "$1" ]
then
    echo "Please specify a valid file as argument"
    exit 1
fi

#fix spaces
fixed=$(echo $1 | sed 's/ /\\ /g')

#double fix spces, this is hacky, but it lets us use SCP
fixed2=$(echo $1 | sed 's/ /\\\\\\ /g')

#fix for URL version
url=$(echo $1 | sed 's/ /\%20/g')

#echo $fixed
#echo $fixed2

mv "$1" installer.exe
scp installer.exe root@sarge945.xyz:/var/www/sarge945.xyz/files/deusex/
mv installer.exe "$1"

ssh root@sarge945.xyz mv "/var/www/sarge945.xyz/files/deusex/installer.exe" "/var/www/sarge945.xyz/files/deusex/$fixed"

echo "Deployed. Download link: https://sarge945.xyz/files/deusex/$url"

#ssh -t root@sarge945.xyz "cd /var/www/sarge945.xyz/files/deusex ; bash --login"
