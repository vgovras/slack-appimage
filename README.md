# Slack AppImage

Unofficial Slack AppImage for Linux.

## Installation

1. Download the latest `Slack-*.AppImage` from [Releases](https://github.com/vgovras/slack-appimage/releases)
2. Make it executable:
   ```bash
   chmod +x Slack-*.AppImage
   ```
3. Run it:
   ```bash
   ./Slack-*.AppImage
   ```

## Building Locally

1. Install dependencies: `wget`, `curl`, `dpkg-deb`
2. Download `linuxdeploy-x86_64.AppImage` and place it in the repository root
3. Run:
   ```bash
   ./build.sh
   ```

## Auto-Update

The AppImage includes update information pointing to GitHub Releases. Use AppImageUpdate or similar tools to check for updates.

## Validating AppStream Metadata

To validate the AppStream metadata file:

```bash
sudo apt-get install appstream
appstreamcli validate com.slack.Slack.appdata.xml
```
