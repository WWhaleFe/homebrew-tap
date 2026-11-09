cask "flockswitch" do
  version "0.6.1"
  sha256 "704effd59bcf8656964c8da730a2b3c8384b5370c213b1ea4ece14e0042514ff"

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
  # "Open Anyway" is chosen again. Then it is started, so the new version is the one running.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/flockswitch.app"], must_succeed: false
    run "/usr/bin/open", args: ["-g", "{{appdir}}/flockswitch.app"], must_succeed: false
  end

  # Started at login it runs under its own launchd label, which `signal` below cannot
  # find. On SIGTERM it puts the mouse buttons back the way they were and quits.
  uninstall_preflight_steps do
    terminate_process "flockswitch"
  end

  uninstall on_upgrade: :signal,
            signal:     ["TERM", "io.github.wwhalefe.flockswitch"]

  zap trash: [
    "~/Library/Application Support/flockswitch",
    "~/Library/LaunchAgents/flockswitch.plist",
  ]

  caveats <<~EOS
    A new version shows up after `brew update`:
      brew update && brew upgrade --cask flockswitch
  EOS
end
