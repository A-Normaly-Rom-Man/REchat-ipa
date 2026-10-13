#!/usr/bin/env bash
# `npx cap add ios` sonrası çalıştırılır: izin metinleri, arka plan sesi, min iOS sürümü
set -e
P=ios/App/App/Info.plist
PB=/usr/libexec/PlistBuddy
add(){ $PB -c "Delete :$1" "$P" 2>/dev/null || true; $PB -c "Add :$1 string $2" "$P"; }
add NSMicrophoneUsageDescription "reChat sesli arama, sesli oda ve sesli mesaj için mikrofonu kullanır."
add NSCameraUsageDescription "reChat fotoğraf ve video çekip paylaşmak için kamerayı kullanır."
add NSPhotoLibraryUsageDescription "reChat fotoğraf ve video paylaşmak için galerine erişir."
add NSPhotoLibraryAddUsageDescription "reChat medyayı galerine kaydedebilir."
add NSLocationWhenInUseUsageDescription "reChat konumunu arkadaşlarınla paylaşmak için kullanır."
$PB -c "Delete :UIBackgroundModes" "$P" 2>/dev/null || true
$PB -c "Add :UIBackgroundModes array" -c "Add :UIBackgroundModes:0 string audio" "$P"
# CSS color-mix() iOS 16.2+ ister
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = 1[0-5]\.[0-9];/IPHONEOS_DEPLOYMENT_TARGET = 16.4;/g' ios/App/App.xcodeproj/project.pbxproj 2>/dev/null || \
sed -i 's/IPHONEOS_DEPLOYMENT_TARGET = 1[0-5]\.[0-9];/IPHONEOS_DEPLOYMENT_TARGET = 16.4;/g' ios/App/App.xcodeproj/project.pbxproj
[ -f ios/App/Podfile ] && sed -i.bak "s/platform :ios, '1[0-5]\.[0-9]'/platform :ios, '16.4'/" ios/App/Podfile || true
echo "iOS yamaları uygulandı."
