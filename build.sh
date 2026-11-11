#!/bin/zsh
# GroupMaker.app をビルドする
set -euo pipefail
cd "$(dirname "$0")"

APP="GroupMaker.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

swiftc -O -parse-as-library GroupMaker.swift -o "$APP/Contents/MacOS/GroupMaker"

# アイコン: icon/icon_1024.png が無ければ描画し、.icns に変換
[[ -f icon/icon_1024.png ]] || swift icon/make_icon.swift icon/icon_1024.png
ICONSET="$(mktemp -d)/AppIcon.iconset"
mkdir -p "$ICONSET"
for s in 16 32 128 256 512; do
  sips -z $s $s icon/icon_1024.png --out "$ICONSET/icon_${s}x${s}.png" >/dev/null
  sips -z $((s*2)) $((s*2)) icon/icon_1024.png --out "$ICONSET/icon_${s}x${s}@2x.png" >/dev/null
done
iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/AppIcon.icns"
rm -rf "$(dirname "$ICONSET")"

cat > "$APP/Contents/Info.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>GroupMaker</string>
  <key>CFBundleDisplayName</key><string>ランダムグループ分け</string>
  <key>CFBundleIdentifier</key><string>local.groupmaker</string>
  <key>CFBundleExecutable</key><string>GroupMaker</string>
  <key>CFBundleIconFile</key><string>AppIcon</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>LSMinimumSystemVersion</key><string>14.0</string>
  <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
EOF

codesign --force --sign - "$APP" >/dev/null 2>&1 || true
echo "Built: $(pwd)/$APP"
