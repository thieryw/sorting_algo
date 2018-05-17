#/bin/bash/

mkdir -p bin_ada
cp *.adb *.ads bin_ada/ 
cd bin_ada
gnatmake -gnatU -g sorting_exercise.adb

