#!/bin/bash
cd /data/repository/
array=($(find . -maxdepth 1 -type f -printf '%f\n' ))
for rpmname in "${array[@]}"
do

if [[ $rpmname != *".rpm"* ]]; then
  echo "$rpmname not an rpm , do you want to keep it ? \\n "
  continue
fi

rpmfullname=$rpmname
pattern1=".rpm"
pattern2=".noarch.rpm"

rpmfullname=${rpmfullname/$pattern1/}
rpmfullname=${rpmfullname/$pattern2/}

installedcount=`rpmquery -qa | grep $rpmfullname | wc -l`

 if [ $installedcount -ne 1 ]

  then
      packagedname=`rpm -qi -filesbypkg -p $rpmname | grep "Name" | awk '{print $3}'` 2>/dev/null
      packagedversion=`rpm -qi -filesbypkg -p $rpmname | grep "Version" | awk '{print $3}'`
      packagedrelease=`rpm -qi -filesbypkg -p $rpmname | grep "Release" | awk '{print $3}'`
      someversioninstalled=`rpm -qi $packagedname | wc -l`
      if [ $someversioninstalled -eq 0 ]
      then
        printf "$rpmname is NOT  installed \n"	
   	printf " $rpmname is not at all required, remove it from tar \n"
      else
       printf "\n $rpmname is NOT  installed \n"
       installedversion=`rpm -qi $packagedname | grep "Version" | awk '{print $3}'` 
       installedrelease=`rpm -qi $packagedname | grep "Release" | awk '{print $3}'`
       printf " installedversion $installedversion-$installedrelease and packagedversion $packagedversion-$packagedrelease\n\n"
      fi

 fi

done
