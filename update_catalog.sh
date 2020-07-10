#!/bin/bash
conf_list=(.env config/app.php)

root_dir="./facepass_v3"
bckp_dir="./bckp_facepass_v3"


echo "Make bckp of ${root_dir}"
tar -czf facepass_v3_bckp_"$(date +%Y-%m-%d__%H.%M.%S)".tar $root_dir
mv facepass_v3*.tar $bckp_dir
echo "Done bckp of ${root_dir}"
echo

echo "Backup configs"
for i in ${conf_list[@]}; do
[ ! -d "$(dirname "${i}")" ] && mkdir -p $bckp_dir/"$(dirname "${i}")"
cp -f $root_dir/$i $bckp_dir/$i
done
echo "Configs Backup done..."
echo

echo "Get new distrib"
curl -sL -k --header "PRIVATE-TOKEN: B16A2nSnV-WqMHUSirwB" "https://git.digital-spectr.ru/api/v4/projects/FacePass%2Fserver/repository/archive.tar.gz" -o archive.tar.gz
tar xzf archive.tar.gz
rm archive.tar.gz
cp -rf server-develop-*/* $root_dir
rm -r -f server-develop-*
echo "New distrib download and install"
echo 

echo "Make symlink to config dir"
cd $root_dir
[ ! -d "./configs" ] && ln -sf ./config/ ./configs
cd ..
echo "Done..."
echo

echo "Restore config"
for i in ${conf_list[@]}; do
cp -f $bckp_dir/$i $root_dir/$i
done

echo "Restore done..."
echo

echo "All done...
