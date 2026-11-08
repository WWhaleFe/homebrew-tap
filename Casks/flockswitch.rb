cask "flockswitch" do
  version "0.6.0"
  sha256 "72fd3f9a530e832b129c3f87ec51a114a42008dc890b370554e1f5cb71998d0b"

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
