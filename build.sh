#!/bin/bash

# machine's architecture
export ARCH=x86_64
echo "Machine's architecture: $ARCH"

# get the missing tools if necessary
if [ ! -f appimagetool-$ARCH.AppImage ]
  then
      echo "Get the missing tools..."
      curl -L -o appimagetool-$ARCH.AppImage \
      https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$ARCH.AppImage
      chmod a+x appimagetool-$ARCH.AppImage
fi

# get sources binary if necessary
[ ! -f vkteams.tar.xz ] && echo "Get sources binary..." && \
curl -L -o vkteams.tar.xz https://dl.internal.myteam.mail.ru/downloads/linux/x64/latest/vkteams.tar.xz

# prepare source AppDir
if [ -f vkteams.tar.xz ]
  then
      echo "Prepare source AppDir..."
      rm -rvf src && mkdir src
      tar -xvf vkteams.tar.xz -C src
      rm -rf src/unittests
      cp -vf com.vk.teams.png src/
      cp -vf com.vk.teams.desktop src/
      cp -vf AppRun src/
      chmod a+x src/AppRun
      (cd src && ln -sf com.vk.teams.png .DirIcon)
      cp -rvf usr src/
fi

# the building
if [[ -f appimagetool-$ARCH.AppImage && -d src ]]
  then
      echo "Building AppImage..."
      rm -rvf build && mkdir build
      (cd build && ../appimagetool-$ARCH.AppImage ../src)
fi
