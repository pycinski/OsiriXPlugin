#!/bin/sh
#script for renaming the ikt namespace


if [ $# != 2 ] ; then
echo "Podaj parametry: skrypt ITK_DIR NAMESPACE"
exit 1
fi

new=$2
OLDDIR="`pwd`"
echo "ITK_DIR: $1 NAMESPACE: $2"

cd "$1"

#echo "Modifying Utiltlites/CMakeList.sys file, changing systems namespace"
sed -e "s/SET(KWSYS_NAMESPACE itksys)/SET(KWSYS_NAMESPACE ${new}sys)/g" "./Utilities/CMakeLists.txt" > "./Utilities/CMakeLists.txt.sed"
test -s "./Utilities/CMakeLists.txt.sed" && (cmp -s "./Utilities/CMakeLists.txt.sed" "./Utilities/CMakeLists.txt" || mv -f "./Utilities/CMakeLists.txt.sed" "./Utilities/CMakeLists.txt")

#echo "Modifying Code/IO/CMakeLists.txt, deavticating test driver"
cp "./Code/IO/CMakeLists.txt" "./Code/CMakeLists.txt.original"
sed -e '/ADD_EXECUTABLE(itkTestDriver itkTestDriver.cxx)/,/CACHE INTERNAL \"itkTestDriver path to be used by subprojects\")/d' "./Code/IO/CMakeLists.txt" > "./Code/IO/CMakeLists.txt.sed" 
test -s "./Code/IO/CMakeLists.txt.sed" && (cmp -s "./Code/IO/CMakeLists.txt.sed" "./Code/IO/CMakeLists.txt" || mv -f "./Code/IO/CMakeLists.txt.sed" "./Code/IO/CMakeLists.txt")	

FILELIST=`find .  \( -path './Testing' -prune  -o  -name "*.h" -o -name "*.txx" -o -name "*.cxx" -o -name "*.hxx" \)  -print`


for i in $FILELIST; do
#    echo -n "Changing $i ..."
if [ $i != ./Testing ] ; then 
  sed    \
    -e "s/^itk[[:space:]]*::/$new::/" \
    -e "s/\([^[:alnum:]_]\)itk[[:space:]]*::/\1${new}::/g" \
    -e "s/namespace[[:space:]][[:space:]]*itk/namespace ${new}/g"  \
    -e "s/itksys/${new}sys/g" \
    "$i" > "$i.sed"

  test -s "$i.sed" &&  (cmp -s "$i.sed" "$i" || mv -f "$i.sed" "$i")
  rm -f "$i.sed"
#    echo "done"
fi
done

cd "$OLDDIR"

