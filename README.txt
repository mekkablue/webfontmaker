IMPORTANT UPDATE

Don’t use webfontmaker. Glyphs 2 can write webfonts out of the box. I will leave this up here for reference, but it is not supported anymore. The installation instructions are outdated. If you cannot get it to work, please download Glyphs 2 or use FontSquirrel.





ABOUT

webfontmaker.sh takes any number of PS-flavored OTF files and creates corresponding TTF (unhinted and autohinted), EOT (unhinted and autohinted), (PS-flavored) WOFF and SVG. Running the script again will overwrite all previous output.





INSTALLATION INSTRUCTIONS

1. Install FontForge and ttfautohint:

- Install Xcode from the App Store.
- Run Xcode and confirm the additional installs it needs.
- Xcode > Preferences > Downloads > install 'Command Line Tools'. 
- Install the latest version of XQuartz from http://xquartz.macosforge.org/landing/
- If the XQuartz installer seems stalled at "Preparing installation", force quit the installer, restart your Mac, and try again.
- Install Homebrew in Terminal:
ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
brew install https://raw.github.com/ummels/homebrew/fontforge/Library/Formula/fontforge.rb
brew install ttfautohint
brew doctor
brew linkapps

2. Install sfntly:

svn co http://sfntly.googlecode.com/svn/trunk/ /Applications/sfntly/
cd /Applications/sfntly/java/
ant

3. Install sfnt2woff:

- Download sfnt2woff ('spline font to WOFF') for OS X from http://people.mozilla.com/~jkew/woff/ (hint: opt-click the 'precompiled version for Mac OS X').
- Move sfnt2woff into the Applications folder.
- In the Terminal, you enter:
chmod +x /Applications/sfnt2woff
mkdir /usr/local/bin/
sudo ln -s /Applications/sfnt2woff /usr/local/bin/







USAGE INSTRUCTIONS

- Create your own Meta.xml or use the one provided in this repository. More Info: http://www.w3.org/TR/WOFF/
- Put Meta.xml, webfontmaker.sh and any number of OTF files in the same folder.
- In Terminal, navigate into that folder, then type:
sh webfontmaker.sh
- or use a x.xxx version number as parameter:
sh webfontmaker.sh 2.302
- If no version number is present, the script assumes 1.001.
