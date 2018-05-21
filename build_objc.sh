#!/bin/sh

#  build_objc.sh
#  RLLoggerSDKFramework
#
#  Created by Sachith on 5/21/18.
#  Copyright © 2017 EnWidth. All rights reserved.


UNIVERSAL_OUTPUTFOLDER="`pwd`/Framework_Output/RLLoggerSDKObjC_Pod/RLLoggerSDKFramework_ObjC"
RL_PROJECT_NAME="RLLoggerSDKFramework"
RL_SCHEME="RLLoggerSDKFramework_ObjC"
RL_BuildFolder="`pwd`/Build/build_objc"

rm -rf "$RL_BuildFolder"
rm -rf "$UNIVERSAL_OUTPUTFOLDER"

mkdir -p "$UNIVERSAL_OUTPUTFOLDER"

# Building frameworks for phoneOS and simulator.

xcodebuild -workspace "$RL_PROJECT_NAME.xcworkspace" -scheme "$RL_SCHEME" -sdk iphoneos  -configuration Release  -destination generic/platform=iOS  CONFIGURATION_BUILD_DIR="$RL_BuildFolder/phoneos" clean build
xcodebuild -workspace "$RL_PROJECT_NAME.xcworkspace" -scheme "$RL_SCHEME" -sdk iphonesimulator  -configuration Release  CONFIGURATION_BUILD_DIR="$RL_BuildFolder/simulator" clean build

# Copying simulator and phoneos frameworks to output folder

cp -R "$RL_BuildFolder/simulator/$RL_SCHEME.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

cp -R "$RL_BuildFolder/simulator/$RL_SCHEME.framework/Modules/$RL_SCHEME.swiftmodule/." "${UNIVERSAL_OUTPUTFOLDER}/$RL_SCHEME.framework/Modules/$RL_SCHEME.swiftmodule"
cp -R "$RL_BuildFolder/phoneos/$RL_SCHEME.framework/Modules/$RL_SCHEME.swiftmodule/." "${UNIVERSAL_OUTPUTFOLDER}/$RL_SCHEME.framework/Modules/$RL_SCHEME.swiftmodule"

# lipo command to create universal framework at specified output folder by combining phoneos framework and simulator framework

lipo -create -output "$UNIVERSAL_OUTPUTFOLDER/$RL_SCHEME.framework/$RL_SCHEME" "$RL_BuildFolder/simulator/$RL_SCHEME.framework/$RL_SCHEME" "$RL_BuildFolder/phoneos/$RL_SCHEME.framework/$RL_SCHEME"

# script to confirm and commit framework to repository

echo "Do you want to commit framework to repository? (N/y)"
read shouldCommitFlag

if [ "$shouldCommitFlag" = "y" ]
then
    cd "`pwd`/Framework_Output/RLLoggerSDKObjC_Pod"
    git add .

    echo 'Enter the commit message:'
    read commitMessage

    git commit -m "$commitMessage"

    git push

fi

# script to confirm and tag framework on repository

echo "Do you want to add tag for the framework repository? (N/y)"
read shouldTagFlag

if [ "$shouldTagFlag" = "y" ]
then
    echo latest tag is $(git tag)
    echo 'Enter tag'
    read tagVersion

    git tag $tagVersion

    git push origin $tagVersion

fi
