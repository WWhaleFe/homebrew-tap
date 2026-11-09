cask "usagemeter" do
  version "1.4.1"
  sha256 "6f82674aa70fbffd694004b18177eb3e302452fa694db4cdde4db7938398e5c6"

  url "https://github.com/WWhaleFe/usagemeter/releases/download/v#{version}/UsageMeter-v#{version}.zip"
  name "UsageMeter"
  desc "Menu bar meter for Claude, Codex and Gemini usage limits"
  homepage "https://github.com/WWhaleFe/usagemeter"

  livecheck do
    url :url
    strategy :github_latest
  end

  # No `auto_updates`: the app only announces new versions, so `brew upgrade` has to replace
  # it, and with that stanza Homebrew would skip this cask without --greedy.
  depends_on macos: :sonoma

  app "UsageMeter.app"

  # UsageMeter is not notarized: without this macOS stops every new version until
  # "Open Anyway" is chosen again.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/UsageMeter.app"], must_succeed: false
  end

  # Not on upgrades: install steps cannot start an app from Homebrew's sandbox, so the
  # running copy stays up, notices it was replaced and restarts itself as the new version.
  uninstall signal: ["TERM", "com.usagemeter.app"]

  zap trash: [
    "~/Library/Application Support/UsageMeter",
    "~/Library/Caches/com.usagemeter.app",
    "~/Library/Caches/UsageMeter",
    "~/Library/HTTPStorages/com.usagemeter.app*",
    "~/Library/HTTPStorages/UsageMeter*",
    "~/Library/Preferences/com.usagemeter.app.plist",
    "~/Library/Preferences/UsageMeter.plist",
    "~/Library/WebKit/com.usagemeter.app",
    "~/Library/WebKit/UsageMeter",
  ]

  caveats <<~EOS
    Open UsageMeter from Applications to start it.

    A new version shows up after `brew update`. The running app restarts itself:
      brew update && brew upgrade --cask usagemeter
  EOS
end
