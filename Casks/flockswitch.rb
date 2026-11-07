cask "flockswitch" do
  version "0.4.4"
  sha256 "e8ddf76694e73cbc392ac43b16f74670ac537dc0802968b00ac9c167f46ca053"

  url "https://github.com/WWhaleFe/flockswitch-mac/releases/download/v#{version}/flockswitch-macos-arm64-#{version}.zip"
  name "flockswitch"
  desc "Move a Logitech mouse and keyboard to another computer with one button"
  homepage "https://github.com/WWhaleFe/flockswitch-mac"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "flockswitch/flockswitch.app"
  binary "#{appdir}/flockswitch.app/Contents/MacOS/flockswitch"

  # On SIGTERM flockswitch puts the mouse buttons back the way they were and quits, so
  # stop it before the app goes, on upgrades too.
  uninstall on_upgrade: :signal,
            signal:     ["TERM", "io.github.wwhalefe.flockswitch"]

  zap trash: [
    "~/Library/Application Support/flockswitch",
    "~/Library/LaunchAgents/flockswitch.plist",
  ]

  caveats <<~EOS
    flockswitch is not notarized by Apple. The first time you open it, macOS blocks it:
    open System Settings → Privacy & Security and choose "Open Anyway".

    After an upgrade, open flockswitch again from Applications.
  EOS
end
