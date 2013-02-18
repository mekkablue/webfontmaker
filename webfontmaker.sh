# Syntax: sh webfontmaker.sh [x.xxx]
# x.xxx is an optional version number

# Remove files from previous iterations:
rm *.html
rm *.css
rm *.eot

# Check if a version number was passed as argument:
if [[ $1 ]]; then
	version=$1
else
	# default = 1.001
	version="1.001"
fi

# If Meta.xml contains the string "x.xxx",
# attempt to insert the version number there:
metadataSRC="Meta.xml"
metadata="makeweb$metadataSRC"
sed 's/x.xxx/$version/' $metadataSRC > $metadata

# Create the fontforge script for later,
# unfortunately, fontforge -c seems to be broken...?
printf 'Open($1)\nGenerate($1:r + ".svg")\nScaleToEm(2048)\nRoundToInt()\nGenerate($1:r + ".ttf")' > makeweb.pe

# Create the DSIG XML for later,
# echo '<?xml version="1.0" encoding="ISO-8859-1"?>\n<ttFont sfntVersion="\\x00\\x01\\x00\\x00" ttLibVersion="2.2">\n<DSIG>\n   <hexdata>\n     00000001 00000000\n   </hexdata>\n</DSIG>\n</ttFont>\n' > dsig.ttx
#
# Currently disabled because of a bug in fontTools rev 612.

# Process all OTFs in the folder:
for file in *.otf; do
	
	# Strip the ".otf" extension
	# and calculate the other names:
	basename=`echo "$file" | sed -e "s/\.otf//"`
	otfFont="$basename.otf"
	ttfFont="$basename-unhinted.ttf"
	ttfAHFont="$basename.ttf"
	eotFont="$basename-unhinted.eot"
	eotAHFont="$basename.eot"
	woffFont="$basename.woff"
	svgFont="$basename.svg"

	echo
	echo Processing $basename ...
	
	# Make SVG and TTF:
	echo Creating $ttfFont ...
	fontforge -script makeweb.pe $otfFont
	
	# Fix SVG files:
	echo Creating $svgFont ...
	sed '/^Created by .*$/d' $svgFont > tmp.svg; mv tmp.svg $svgFont
	sed 's/^<svg>/<svg xmlns="http:\/\/www.w3.org\/2000\/svg">/' $svgFont > tmp.svg; mv tmp.svg $svgFont
	
	# Autohint TTF:
	echo Autohinting $ttfFont ...
	ttfautohint $ttfFont $ttfAHFont
	
	# Make EOT:
	echo Creating $eotFont ...
	java -jar ~/Applications/svn/sfntly-read-only/java/dist/tools/sfnttool/sfnttool.jar -e -x $ttfFont $eotFont
	
	echo Autohinting $eotFont ...
	java -jar ~/Applications/svn/sfntly-read-only/java/dist/tools/sfnttool/sfnttool.jar -e -x $ttfAHFont $eotAHFont

	# make WOFF and its HTML files:
	echo Creating $woffFont ...
	sfnt2woff -v $version -m $metadata $otfFont
	woff-all $woffFont
	
	# Inject a Dummy DSIG table into the OTF & the TTF so they'll work in MS Word.
	# Source: http://typedrawers.com/discussion/192/making-otttf-layout-features-work-in-ms-word-2010
	#
	# ttx -m $otfFont dsig.ttx
	# ttx -m $ttfFont dsig.ttx
	# ttx -m $ttfAHFont dsig.ttx
	#
	# Currently disabled because of a bug in fontTools rev 612.
done

# Clean up:
rm $metadata
rm makeweb.pe
# rm dsig.ttx

echo