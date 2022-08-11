#!/bin/bash
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
NO_COLOR='\033[0m'
BLOCK=4490420
VERSION=v1.4.1
echo -e "$GREEN_COLOR YOUR NODE WILL BE UPDATED TO VERSION: $VERSION ON BLOCK NUMBER: $BLOCK $NO_COLOR\n"
for((;;)); do
height=$(bcnad status |& jq -r ."SyncInfo"."latest_block_height")
if ((height>=$BLOCK)); then
sudo service bcnad stop
cd $HOME
rm bcna -rf
git clone https://github.com/BitCannaGlobal/bcna.git --branch $VERSION
cd bcna
make install
sudo chmod +x ./build/bcnad && sudo mv ./build/bcnad /usr/local/bin/bcnad
echo "restart the system..."
sudo systemctl restart bcnad
for (( timer=60; timer>0; timer-- ))
        do
                printf "* second restart after sleep for ${RED_COLOR}%02d${NO_COLOR} sec\r" $timer
                sleep 1
        done
height=$(bcnad status |& jq -r ."SyncInfo"."latest_block_height")
if ((height>$BLOCK)); then
echo -e "$GREEN_COLOR YOUR NODE WAS SUCCESFULLY UPDATED TO VERSION: $VERSION $NO_COLOR\n"
fi
bcnad version --long | head
break
else
echo $height
fi
sleep 1
done
