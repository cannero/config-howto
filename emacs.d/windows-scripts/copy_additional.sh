#!/bin/sh

# targetfolder is the top level emacs install folder
targetfolder="$1"
sourcefolder=/d/path/to/tools/msys64/mingw64

if [ ! $targetfolder ] || [ ! -d $targetfolder ]
then
   echo "target <$targetfolder> does not exist"
   exit -1
fi

cp "copy_additional.sh" "runit.cmd" "run_client.cmd" "StartEmacsServer.bat" "$targetfolder/bin/"

cp -R "$sourcefolder/bin/." "$targetfolder/bin/"

mkdir -p "$targetfolder/x86_64-w64-mingw32/lib/ldscripts"
# this will also copy ldscripts as the folder exists
cp -R "$sourcefolder/x86_64-w64-mingw32/lib/." "$targetfolder/x86_64-w64-mingw32/lib/"

mkdir -p "$targetfolder/lib/gcc/x86_64-w64-mingw32/11.2.0/include"
mkdir -p "$targetfolder/lib/gcc/x86_64-w64-mingw32/11.2.0/include-fixed"
mkdir -p "$targetfolder/lib/gcc/x86_64-w64-mingw32/11.2.0/install-tools"
cp "$sourcefolder/lib/dllcrt2.o" "$targetfolder/lib"
cp "$sourcefolder/lib/*.a" "$targetfolder/lib"
cp -R "$sourcefolder/lib/gcc/x86_64-w64-mingw32/11.2.0/." "$targetfolder/lib/gcc/x86_64-w64-mingw32/11.2.0/"
rm -r -f "$targetfolder/lib/gcc/x86_64-w64-mingw32/11.2.0/adainclude"
rm -r -f "$targetfolder/lib/gcc/x86_64-w64-mingw32/11.2.0/adalib"
rm -r -f "$targetfolder/lib/gcc/x86_64-w64-mingw32/11.2.0/finclude"
