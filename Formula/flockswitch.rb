class Flockswitch < Formula
  desc "Move a Logitech mouse and keyboard to another computer with one button"
  homepage "https://github.com/WWhaleFe/flockswitch-linux"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # The macOS version is the flockswitch cask.
  depends_on :linux

  on_linux do
    on_intel do
      url "https://github.com/WWhaleFe/flockswitch-linux/releases/download/v0.12.0/flockswitch-linux-x86_64-0.12.0.tar.gz"
      sha256 "4b3891b52f60d38a6d62d08d1842ee7499b3c0e5ec538c02fdb5a8c8c4b9d067"
    end
    on_arm do
      url "https://github.com/WWhaleFe/flockswitch-linux/releases/download/v0.12.0/flockswitch-linux-aarch64-0.12.0.tar.gz"
      sha256 "b749d466e09cc5bb354dbae4f11be0b3240f42c01db59235a89b1b1bb4f60c03"
    end
  end

  def install
    bin.install "flockswitch"
    (share/"flockswitch").install "flockswitch.png", "70-flockswitch.rules"
    # opt paths stay the same across upgrades.
    inreplace "flockswitch.desktop" do |s|
      s.gsub! "@BIN@", opt_bin/"flockswitch"
      s.gsub! "@ICON@", opt_share/"flockswitch/flockswitch.png"
    end
    (share/"applications").install "flockswitch.desktop"
  end

  def caveats
    <<~EOS
      flockswitch needs a udev rule to open Logitech receivers and devices. Install it once:
        sudo install -m 644 #{opt_share}/flockswitch/70-flockswitch.rules /etc/udev/rules.d/
        sudo udevadm control --reload-rules
        sudo udevadm trigger --subsystem-match=hidraw
      then replug the receiver (or reconnect Bluetooth).

      To add flockswitch to the app menu:
        mkdir -p ~/.local/share/applications
        ln -sf #{opt_share}/applications/flockswitch.desktop ~/.local/share/applications/

      To upgrade (the macOS cask has the same name, so name the formula):
        brew update && brew upgrade --formula wwhalefe/tap/flockswitch
      On Homebrew 6+, if it says the tap is untrusted, run once:
        brew trust --formula wwhalefe/tap/flockswitch

      Before `brew uninstall --formula wwhalefe/tap/flockswitch`, run `flockswitch uninstall` (it puts the buttons
      back and removes start-at-login and settings), then remove the rule and menu entry:
        sudo rm /etc/udev/rules.d/70-flockswitch.rules
        rm ~/.local/share/applications/flockswitch.desktop
    EOS
  end

  test do
    assert_match "flockswitch switch <N>", shell_output("#{bin}/flockswitch help")
  end
end
