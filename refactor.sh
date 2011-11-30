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


echo "Modifying Utiltlites/CMakeList.sys file, changing systems namespace"
sed -e "s/SET(KWSYS_NAMESPACE itksys)/SET(KWSYS_NAMESPACE ${new}sys)/g" "$1/Utilities/CMakeLists.txt" > "$1/Utilities/CMakeLists.txt.sed"
test -s "$1/Utilities/CMakeLists.txt.sed" && (cmp -s "$1/Utilities/CMakeLists.txt.sed" "$1/Utilities/CMakeLists.txt" || mv -f "$1/Utilities/CMakeLists.txt.sed" "$1/Utilities/CMakeLists.txt")
echo "done\n"

echo "Modifying Code/IO/CMakeLists.txt, deavtivating test driver"
cp "$1/Code/IO/CMakeLists.txt" "$1/Code/CMakeLists.txt.original"
sed -e '/ADD_EXECUTABLE(itkTestDriver itkTestDriver.cxx)/,/CACHE INTERNAL \"itkTestDriver path to be used by subprojects\")/d' \
	"$1/Code/IO/CMakeLists.txt" > "$1/Code/IO/CMakeLists.txt.sed" 
test -s "$1/Code/IO/CMakeLists.txt.sed" && (cmp -s "$1/Code/IO/CMakeLists.txt.sed" "$1/Code/IO/CMakeLists.txt" || mv -f "$1/Code/IO/CMakeLists.txt.sed" "$1/Code/IO/CMakeLists.txt")	
echo "done"


FILELIST=`find $1 \( -name "*.h" -o -name "*.txx" -o -name "*.cxx" -o -name "*.hxx"  \) -print`

#echo "$FILELIST" | sort --unique >output
#echo "$FILELIST" | sort >output2
echo "$FILELIST"

for i in $FILELIST; do
    echo "Changing $i ..."
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
    echo "done\n"
done



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
