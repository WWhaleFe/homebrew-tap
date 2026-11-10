cask "flockswitch" do
  version "0.10.0"
  sha256 "ca1a57f57f9cda4e1ebc10e159687f7e6a5f103c05941f796cf977e7d3ff17d9"

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

  # flockswitch is not notarized: without this macOS stops every new version until
  # "Open Anyway" is chosen again.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/flockswitch.app"], must_succeed: false
  end

  # Only when uninstalling. On an upgrade the running copy notices the new version,
  # starts it and hands over. On SIGTERM it puts the mouse buttons back and quits; a copy
  # started at login runs under its own launchd label, which `signal` cannot find.
  uninstall launchctl: "flockswitch",
            signal:    ["TERM", "io.github.wwhalefe.flockswitch"]

  zap trash: [
    "~/Library/Application Support/flockswitch",
    "~/Library/LaunchAgents/flockswitch.plist",
  ]

  caveats <<~EOS
    A new version shows up after `brew update`:
      brew update && brew upgrade --cask flockswitch

    If flockswitch is not in the menu bar after an upgrade, open it from Applications.
  EOS
end
