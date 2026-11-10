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
      url "https://github.com/WWhaleFe/flockswitch-linux/releases/download/v0.8.0/flockswitch-linux-x86_64-0.8.0.tar.gz"
      sha256 "e77c9a87311b1003c8c89cafed2fe34563b84396ff31c1d440ef311da049ae87"
    end
    on_arm do
      url "https://github.com/WWhaleFe/flockswitch-linux/releases/download/v0.8.0/flockswitch-linux-aarch64-0.8.0.tar.gz"
      sha256 "fff7f498463693c1f7e08df07e1030e9eac1f7794bd0f8400926d1eb5068c06b"
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

      Before `brew uninstall flockswitch`, run `flockswitch uninstall` (it puts the buttons
      back and removes start-at-login and settings), then remove the rule and menu entry:
        sudo rm /etc/udev/rules.d/70-flockswitch.rules
        rm ~/.local/share/applications/flockswitch.desktop
    EOS
  end

  test do
    assert_match "flockswitch switch <N>", shell_output("#{bin}/flockswitch help")
  end
end
