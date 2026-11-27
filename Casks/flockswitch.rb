cask "flockswitch" do
  version "2.4.0"
  sha256 "052a9e710ebdd71fc4ccd4b965dd3c3fdd0befb100e2cffc7181bf4b01ad1752"

  url "https://github.com/WWhaleFe/flockswitch-mac/releases/download/v#{version}/flockswitch-macos-arm64-#{version}.zip"
  name "flockswitch"
  desc "Share mouse and keyboard across computers, with Logitech Easy-Switch"
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
