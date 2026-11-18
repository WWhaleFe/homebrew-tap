cask "podlift" do
  version "0.1.3"
  sha256 "05f7183db7004e127a47443b915702065a10cc55fe603d723923720b0824dbf6"

  url "https://github.com/WWhaleFe/podlift/releases/download/v#{version}/podlift-macos-arm64-#{version}.zip"
  name "Podlift"
  desc "Import, sync, deduplicate and organize music on an iPod Classic"
  homepage "https://github.com/WWhaleFe/podlift"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :monterey

  app "Podlift.app"

  # Podlift is not notarized: without this macOS stops every new version until
  # "Open Anyway" is chosen again.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Podlift.app"], must_succeed: false
  end

  uninstall quit: "com.wwhalefe.podlift"

  # Settings and undo records live in Application Support/Podlift, album art found online in Caches.
  zap trash: [
    "~/Library/Application Support/Podlift",
    "~/Library/Caches/Podlift",
  ]

  caveats <<~EOS
    Connect the iPod in disk mode, then open Podlift from Applications.

    A new version shows up after `brew update`:
      brew update && brew upgrade --cask podlift
  EOS
end
