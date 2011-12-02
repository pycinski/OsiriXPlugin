#!/bin/sh
#script for renaming the ikt namespace

#echo $1
#echo $2

#if [ "$1" == "" ]; then echo "Usage: refactor_namespace.sh ITK_DIR NEW_NAMESPACE" && exit 1
#fi

if [ $# != 2 ] ; then
echo "Podaj parametry: skrypt ITK_DIR NAMESPACE"
exit 1
fi

new=$2
OLDDIR="`pwd`"
echo $1 $2 $OLDDIR

cd "$1"

echo "Modifying Utiltlites/CMakeList.sys file, changing systems namespace"
sed -e "s/SET(KWSYS_NAMESPACE itksys)/SET(KWSYS_NAMESPACE ${new}sys)/g" "./Utilities/CMakeLists.txt" > "./Utilities/CMakeLists.txt.sed"
test -s "./Utilities/CMakeLists.txt.sed" && (cmp -s "./Utilities/CMakeLists.txt.sed" "./Utilities/CMakeLists.txt" || mv -f "./Utilities/CMakeLists.txt.sed" "./Utilities/CMakeLists.txt")

echo "Modifying Code/IO/CMakeLists.txt, deavticating test driver"
cp "./Code/IO/CMakeLists.txt" "./Code/CMakeLists.txt.original"
sed -e '/ADD_EXECUTABLE(itkTestDriver itkTestDriver.cxx)/,/CACHE INTERNAL \"itkTestDriver path to be used by subprojects\")/d' "./Code/IO/CMakeLists.txt" > "./Code/IO/CMakeLists.txt.sed" 
test -s "./Code/IO/CMakeLists.txt.sed" && (cmp -s "./Code/IO/CMakeLists.txt.sed" "./Code/IO/CMakeLists.txt" || mv -f "./Code/IO/CMakeLists.txt.sed" "./Code/IO/CMakeLists.txt")	

FILELIST=`find .  \( -path './Testing' -prune  -o  -name "*.h" -o -name "*.txx" -o -name "*.cxx" -o -name "*.hxx" \)  -print`
# 

#echo "$FILELIST" 

for i in $FILELIST; do
#    echo "Changing $i ..."
if [ $i != ./Testing ] ; then 
sed    \
-e "s/^itk[[:space:]]*::/$new::/" \
-e "s/\([^[:alnum:]_]\)itk[[:space:]]*::/\1${new}::/g" \
-e "s/namespace[[:space:]][[:space:]]*itk/namespace ${new}/g"  \
-e "s/itksys/${new}sys/g" \
           "$i" > "$i.sed"
#    sed -e "s/\([^:]\)itksys/\1${NEWNAME}sys/g" \
#        -e "s/namespace[ \t*]itk/namespace ${NEWNAME}/g" \
#        -e "s/::itk\([^:]\)/::${NEWNAME}\1/g" \
#        -e "s/\([^:]\)itk::/\1${NEWNAME}::/g" \
#        -e "s/::itk::/::${NEWNAME}::/g" \
    #cat "$i.sed" 
    #grep ib_ib_itk "$i.sed"
	test -s "$i.sed" &&  (cmp -s "$i.sed" "$i" || mv -f "$i.sed" "$i")
	rm -f "$i.sed"
#    echo "done"
fi
done

cd "$OLDDIR"

#new=ib_itk
#new=itk_ib
#new=XXX
#sed    \
#-e "s/^itk[[:space:]]*::/$new::/" \
#-e "s/\([^[:alnum:]_]\)itk[[:space:]]*::/\1${new}::/" \
#-e "s/namespace[[:space:]][[:space:]]*itk/namespace ${new}/g"  \
#-e "s/itksys/${new}sys/g"




#-e "s/\([^[:alnum:]_\:]\)\([[:space:]]+\)itk[[:space:]]*::/\1 ${new}::/" \
#-e "s/\([[:alnum:]_]\)\([[:space:]]+\)itk[[:space:]]*::/\1 ${new}::/" \
#-e "s/([[:alnum:]_])itk::/${new}/g" \
#-e "s/::[[:space:]]*itksys[[:space:]]*::/::${new}::/g" \
#-e "s/\([^:]\)itksys/\1${new}sys/g" \
#-e "s/::itk\([^:]\)/::${new}\1/g" \
#-e "s/\([^:]\)itk::/\1${new}::/g" \
#-e "s/::itk::/::${new}::/g" 
#-e "s/::[[:space:]]*itk[[:space:]]*::/::${new}::/" \
#-e "s/:[[:space:]][[:space:]]*itk[[:space:]]*::/${new}::/" \
