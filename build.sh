set -e

[ ! -f linuxdeploy-x86_64.AppImage ] && wget -q https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage -O linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-x86_64.AppImage

rm -rf AppDir

URL=$(curl https://slack.com/downloads/instructions/linux\?ddl\=1\&build\=deb | grep -oP 'href="\K[^"]*slack-desktop[^"]*\.deb')
VERSION=$(echo "$URL" | grep -oP 'slack-desktop-\K[0-9.]+')
echo "$VERSION" > VERSION

wget -c "$URL" -O slack.deb

dpkg-deb -x slack.deb AppDir
sed -i 's|Exec=/usr/bin/slack|Exec=slack|g' AppDir/usr/share/applications/slack.desktop
sed -i 's|Icon=/usr/share/pixmaps/slack.png|Icon=slack|g' AppDir/usr/share/applications/slack.desktop
cp AppDir/usr/share/applications/slack.desktop .
cp AppDir/usr/share/pixmaps/slack.png .

cat > AppDir/AppRun << 'EOF'
#!/bin/bash
APPDIR="$(dirname "$(readlink -f "${0}")")"
export LD_LIBRARY_PATH="$APPDIR/usr/lib/slack:$APPDIR/usr/lib:${LD_LIBRARY_PATH}"
exec "$APPDIR/usr/lib/slack/slack" "$@"
EOF
chmod +x AppDir/AppRun

mkdir -p AppDir/usr/share/metainfo
cp com.slack.Slack.appdata.xml AppDir/usr/share/metainfo/

export LDAI_UPDATE_INFORMATION="gh-releases-zsync|vgovras|slack-appimage|latest|Slack-*.AppImage.zsync"
NO_STRIP=1 LINUXDEPLOY_OUTPUT_VERSION=$VERSION ./linuxdeploy-x86_64.AppImage \
  --appdir AppDir \
  --executable AppDir/usr/lib/slack/slack \
  --desktop-file slack.desktop \
  --icon-file slack.png \
  --output appimage

appimage=$(find . -name "*.AppImage" ! -name "linuxdeploy-*.AppImage" | head -1)
if command -v zsyncmake >/dev/null 2>&1; then
  zsyncmake "$appimage"
fi
