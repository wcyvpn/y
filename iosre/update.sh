#!/bin/sh

uNames=`uname -s`
echo $uNames
osName=${uNames:0:4} # Linux 需要用 bash update.sh 否则会报错: ./update.sh: 5: Bad substitution
if [ "$osName" == "Darw" ] # Darwin
then
	# echo "Mac OS X"

    # sed -i '' -e 's/.\/debfiles\//.\/iosre\/debfiles\//g' ./Packages; # macOS
    

elif [ "$osName" == "Linu" ] # Linux
then
	# echo "GNU/Linux"

    apt-ftparchive packages ./debfiles/ > ./Packages;
    #sed -i -e '/^SHA/d' ./Packages;
    # sed -i -e 's/.\/debfiles\//.\/iosre\/debfiles\//g' ./Packages # Linux
    bzip2 -c9k ./Packages > ./Packages.bz2;
    printf "Origin: codwam's Repo\nLabel: codwam\nSuite: stable\nVersion: 1.0\nCodename: codwam\nArchitecture: iphoneos-arm\nComponents: main\nDescription: codwam's Tweaks\nMD5Sum:\n "$(cat ./Packages | md5sum | cut -d ' ' -f 1)" "$(stat ./Packages --printf="%s")" Packages\n "$(cat ./Packages.bz2 | md5sum | cut -d ' ' -f 1)" "$(stat ./Packages.bz2 --printf="%s")" Packages.bz2\n" >Release;
    ls ./debfiles/ -t | grep '.deb' | perl -e 'use JSON; @in=grep(s/\n$//, <>); $count=0; foreach $fileNow (@in) { $fileNow = "./debfiles/$fileNow"; $size = -s $fileNow; $debInfo = `dpkg -f $fileNow`; $section = `echo "$debInfo" | grep "Section: " | cut -c 10- | tr -d "\n\r"`; $name= `echo "$debInfo" | grep "Name: " | cut -c 7- | tr -d "\n\r"`; $version= `echo "$debInfo" | grep "Version: " | cut -c 10- | tr -d "\n\r"`; $package= `echo "$debInfo" | grep "Package: " | cut -c 10- | tr -d "\n\r"`; $time= `date -r $fileNow +%s | tr -d "\n\r"`; @in[$count] = {section=>$section, package=>$package, version=>$version, size=>$size+0, time=>$time+0, name=>$name}; $count++; } print encode_json(\@in)."\n";' > all.packages;
elif [ "$osName" == "MING" ] # MINGW, windows, git-bash
then 
	# echo "Windows, git-bash" 
    echo "Not suppport";
else
	# echo "unknown os"
    echo "Not suppport";
fi

exit 0;
