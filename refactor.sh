#!/bin/sh
#script for renaming the ikt namespace


#Czy dobra ilosc parametrow?
if [ $# != 2 ] ; then
echo "Podaj parametry: skrypt ITK_DIR NAMESPACE"
exit 1
fi

#Czy pierwszy parametr to istniejacy katalog?
if [ ! -d "$1" ]
then
echo Katalog $1 nie istnieje. Podaj poprawne parametry:
echo "skrypt ITK_DIR NAMESPACE"
exit 1
fi

new=$2
echo "ITK_DIR: $1 NAMESPACE: $2"

#przejdz do nowego katalogu i zapamiatej dotychczasowy #(a moze pushd?)
#OLDDIR="`pwd`"
#cd "$1"
pushd . >/dev/null

#Modifying Utiltlites/CMakeList.sys file, changing systems namespace
cd Utilities
sed -e "s/SET(KWSYS_NAMESPACE itksys)/SET(KWSYS_NAMESPACE ${new}sys)/g" "CMakeLists.txt" > "CMakeLists.txt.sed"
test -s "CMakeLists.txt.sed" && (cmp -s "CMakeLists.txt.sed" "CMakeLists.txt" || mv -f "CMakeLists.txt.sed" "CMakeLists.txt")
rm -f "CMakeLists.txt.sed"
cd ..

#Modifying Code/IO/CMakeLists.txt, deavticating test driver
cd Code/IO
cp "CMakeLists.txt" "CMakeLists.txt.original"
sed -e '/ADD_EXECUTABLE(itkTestDriver itkTestDriver.cxx)/,/CACHE INTERNAL \"itkTestDriver path to be used by subprojects\")/d' "CMakeLists.txt" > "CMakeLists.txt.sed" 
test -s "CMakeLists.txt.sed" && (cmp -s "CMakeLists.txt.sed" "CMakeLists.txt" || mv -f "CMakeLists.txt.sed" "CMakeLists.txt")	
rm -f "CMakeLists.txt.sed "
cd ..

FILELIST=`find .  \( -path './Testing' -prune  -o  -name "*.h" -o -name "*.txx" -o -name "*.cxx" -o -name "*.hxx" \)  -print`

for i in $FILELIST; do
if [ $i != ./Testing ] ; then 
  sed    \
    -e "s/^itk[[:space:]]*::/$new::/" \
    -e "s/\([^[:alnum:]_]\)itk[[:space:]]*::/\1${new}::/g" \
    -e "s/namespace[[:space:]][[:space:]]*itk/namespace ${new}/g"  \
    -e "s/itksys/${new}sys/g" \
    "$i" > "$i.sed"

  test -s "$i.sed" &&  (cmp -s "$i.sed" "$i" || mv -f "$i.sed" "$i")
  rm -f "$i.sed"
fi
done

#cd "$OLDDIR"
popd >/dev/null

