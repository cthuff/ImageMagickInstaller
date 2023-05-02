#!/bin/bash
# NOTE: This must be run with sudo privileges
# NOTE: xcode-select --install MUST be run on the user before switching to admin account 

# Needed to figure out who is the standard user and where to write python packages
ALLUSERS=$(who)
CURRENTUSER=$(echo "$ALLUSERS" | head -n1 | awk '{print $1;}')
echo "$CURRENTUSER"

# Move into usr/local to unzip the Image Magick package and place it where all users on the computer can have it
cd /usr/local/
tar xvzf /Volumes/ImageMagik\ Setup/ImageMagick-x86_64-apple-darwin20.1.0.tar.gz

# Creates the variables to be used below
export MAGICK_HOME="/usr/local/ImageMagick-7.0.10"
export PATH="$MAGICK_HOME/bin:$PATH"
export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"

#Sets the commands in bashrc so they can be run globally 
bash -c "echo 'export MAGICK_HOME=\"/usr/local/ImageMagick-7.0.10\"' >> /etc/bashrc"
bash -c "echo 'export PATH=\"$MAGICK_HOME/bin:$PATH\"' >> /etc/bashrc"
bash -c "echo 'export DYLD_LIBRARY_PATH=\"$MAGICK_HOME/lib/\"' >> /etc/bashrc"

# magick: set the correct path to libMagickCore.dylib
install_name_tool -change \
    /ImageMagick-7.0.10/lib/libMagickCore-7.Q16HDRI.8.dylib \
    @executable_path/../lib/libMagickCore-7.Q16HDRI.8.dylib \
    /usr/local/ImageMagick-7.0.10/bin/magick

# magick: set the correct path to libMagickWand.dylib
install_name_tool -change \
    /ImageMagick-7.0.10/lib/libMagickWand-7.Q16HDRI.8.dylib \
    @executable_path/../lib/libMagickWand-7.Q16HDRI.8.dylib \
    /usr/local/ImageMagick-7.0.10/bin/magick

# libMagickWand.dylib: set the correct ID
install_name_tool -id \
    @executable_path/../lib/libMagickWand-7.Q16HDRI.8.dylib \
    /usr/local/ImageMagick-7.0.10/lib/libMagickWand-7.Q16HDRI.8.dylib

# libMagickWand.dylib: set the correct path
install_name_tool -change \
    /ImageMagick-7.0.10/lib/libMagickCore-7.Q16HDRI.8.dylib \
    @executable_path/../lib/libMagickCore-7.Q16HDRI.8.dylib \
    /usr/local/ImageMagick-7.0.10/lib/libMagickWand-7.Q16HDRI.8.dylib

# libMagickCore.dylib: set the correct ID
install_name_tool -id \
    @executable_path/../lib/libMagickCore-7.Q16HDRI.8.dylib \
    /usr/local/ImageMagick-7.0.10/lib/libMagickCore-7.Q16HDRI.8.dylib

# Writes the pip packages to the user instead of the admin 
pip3 install --upgrade pip

#The following command needs to be run on the user after logging out of the admin user
#pip3 install --user -r /Volumes/ImageMagik\ Setup/requirements.txt
