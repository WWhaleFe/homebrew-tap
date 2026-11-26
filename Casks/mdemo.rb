cask "mdemo" do
  version "0.14.0"
  sha256 "a457866ff2904005213bdd6ba2c95270f929bf29b4c4e5b8284af1dddac43b30"

  url "https://github.com/WWhaleFe/MDemo/releases/download/v#{version}/MDemo-v#{version}.zip"
  name "MDemo"
  desc "Markdown sticky notes with Google Drive sync and Notion export"
  homepage "https://github.com/WWhaleFe/MDemo"

  livecheck do
    url :url
    strategy :github_latest
  end

  # No `auto_updates`: the app only announces new versions, so `brew upgrade` has to replace
  # it, and with that stanza Homebrew would skip this cask without --greedy.
  depends_on macos: :sonoma

  app "MDemo.app"

  # MDemo is not notarized: without this macOS stops every new version until
  # "Open Anyway" is chosen again.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/MDemo.app"], must_succeed: false
  end

  # Quitting through the app saves open memos first; a signal would skip that.
  uninstall quit: "com.wwhalefe.MDemo"

  # Memos live in Application Support/MDemo/Data. Google Drive and old iCloud Drive copies are left alone.
  zap trash: [
    "~/Library/Application Support/MDemo",
    "~/Library/Caches/com.wwhalefe.MDemo",
    "~/Library/HTTPStorages/com.wwhalefe.MDemo",
    "~/Library/Preferences/com.wwhalefe.MDemo.plist",
  ]

  caveats <<~EOS
    Open MDemo from Applications to start it. It lives in the menu bar, not the Dock.

    A new version shows up after `brew update`. Quit and reopen MDemo afterwards:
      brew update && brew upgrade --cask mdemo
  EOS
end
