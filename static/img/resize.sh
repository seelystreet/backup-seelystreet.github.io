#!/bin/sh
convert=/usr/bin/convert
identify=/usr/bin/identify
resize=$1
source=$2
if [ -z "$resize" -o -z "$source" ] ; then
  echo "Usage: $0 resize sourcefile"; exit 1
fi
if [ ! -r $source ] ; then
  echo "Error: can't read source file $source" ; exit 1
fi
# let's grab the filename suffix
filetype=$(echo $source | rev | cut -d. -f1 | rev)
 
tempfile="resize.$filetype" # temp file name

# create the newly sized temp version of the image
$convert $source -resize $resize $tempfile

# figure out geometry, the assemble new filename
geometry=$($identify $tempfile | cut -d\   -f3 )

newfilebase=$(echo $source | sed "s/$filetype//")
newfilename=$newfilebase$geometry.$filetype

# rename temp file and we're done
mv $tempfile $newfilename

echo \*\* resized $source to new size $resize. result = $newfilename

exit 0
