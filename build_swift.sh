#!/bin/sh

#  UniversalFrameworkShellScript.sh
#  RLLoggerSDKFramework
#
#  Created by Sachith on 5/21/18.
#  Copyright © 2017 EnWidth. All rights reserved.


UNIVERSAL_OUTPUTFOLDER="`pwd`/Framework_Output/RLLoggerSDKSwiftPod/RLLoggerSDKFramework"
SUB_MODULE_DIR="`pwd`/Framework_Output/RLLoggerSDKSwiftPod"
RL_PROJECT_NAME="RLLoggerSDKFramework"
RL_BuildFolder="`pwd`/Build/build_swift"

rm -rf "$RL_BuildFolder"
rm -rf "$UNIVERSAL_OUTPUTFOLDER"

mkdir -p "$UNIVERSAL_OUTPUTFOLDER"

# Building frameworks for phoneOS and simulator.

xcodebuild -workspace "$RL_PROJECT_NAME.xcworkspace" -scheme "$RL_PROJECT_NAME" -sdk iphoneos  -configuration Release  -destination generic/platform=iOS  CONFIGURATION_BUILD_DIR="$RL_BuildFolder/phoneos" clean build
xcodebuild -workspace "$RL_PROJECT_NAME.xcworkspace" -scheme "$RL_PROJECT_NAME" -sdk iphonesimulator  -configuration Release  CONFIGURATION_BUILD_DIR="$RL_BuildFolder/simulator" clean build

# Copying simulator and phoneos frameworks to output folder

cp -R "$RL_BuildFolder/simulator/$RL_PROJECT_NAME.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

cp -R "$RL_BuildFolder/simulator/$RL_PROJECT_NAME.framework/Modules/$RL_PROJECT_NAME.swiftmodule/." "${UNIVERSAL_OUTPUTFOLDER}/$RL_PROJECT_NAME.framework/Modules/$RL_PROJECT_NAME.swiftmodule"
cp -R "$RL_BuildFolder/phoneos/$RL_PROJECT_NAME.framework/Modules/$RL_PROJECT_NAME.swiftmodule/." "${UNIVERSAL_OUTPUTFOLDER}/$RL_PROJECT_NAME.framework/Modules/$RL_PROJECT_NAME.swiftmodule"

# lipo command to create universal framework at specified output folder by combining phoneos framework and simulator framework

lipo -create -output "$UNIVERSAL_OUTPUTFOLDER/$RL_PROJECT_NAME.framework/$RL_PROJECT_NAME" "$RL_BuildFolder/simulator/$RL_PROJECT_NAME.framework/$RL_PROJECT_NAME" "$RL_BuildFolder/phoneos/$RL_PROJECT_NAME.framework/$RL_PROJECT_NAME"
rm -rf "$UNIVERSAL_OUTPUTFOLDER/$RL_PROJECT_NAME.framework/Frameworks"

# script to confirm and commit framework to repository

echo "Do you want to commit framework to repository? (N/y)"
read shouldCommitFlag

if [ "$shouldCommitFlag" = "y" ]
then
    cd "`pwd`/Framework_Output/RLLoggerSDKSwiftPod"
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






