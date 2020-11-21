#!/bin/sh
set -e
set -x

PROJECT=bajsappen
PROJECT_NAME=${PROJECT##*/}

FILE_FLUTTER='pubspec.yaml'
FILE_ANDROID='android/app/build.gradle'

VERSION_LINE=$(grep "version: " $FILE_FLUTTER)
OLD_VERSION="${VERSION_LINE#* }"
OLD_PATCH="${OLD_VERSION#*.*.}"
NEW_PATCH=$(expr $OLD_PATCH + 1)
NEW_VERSION=${OLD_VERSION%.*}.$NEW_PATCH


sed 's|version: .*|version: '${NEW_VERSION}'|' $FILE_FLUTTER > ${FILE_FLUTTER}.tmp
mv ${FILE_FLUTTER}.tmp $FILE_FLUTTER

sed 's|versionName .*|versionName \"'${NEW_VERSION}'\"|' $FILE_ANDROID > ${FILE_ANDROID}.tmp
mv ${FILE_ANDROID}.tmp $FILE_ANDROID


VERSION_CODE_LINE=$(grep "        versionCode " $FILE_ANDROID)
OLD_VERSION_CODE="${VERSION_CODE_LINE#*        versionCode }"
NEW_VERSION_CODE=$(expr $OLD_VERSION_CODE + 1)

sed 's|        versionCode .*|        versionCode '${NEW_VERSION_CODE}'|' $FILE_ANDROID > ${FILE_ANDROID}.tmp
mv ${FILE_ANDROID}.tmp $FILE_ANDROID

COMMIT_MESSAGE="Setting version to $NEW_VERSION"
git commit -am $COMMIT_MESSAGE
