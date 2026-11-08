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
      url "https://github.com/WWhaleFe/flockswitch-linux/releases/download/v0.2.0/flockswitch-linux-x86_64-0.2.0.tar.gz"
      sha256 "e66010e3c1eec98cf218cc0f9a6df1b8eef097e9b2dbbc104e1513ddb6bebb5e"
    end
    on_arm do
      url "https://github.com/WWhaleFe/flockswitch-linux/releases/download/v0.2.0/flockswitch-linux-aarch64-0.2.0.tar.gz"
      sha256 "41514d04e07910b78fd147a865000d3b1992cbe55ac22d024566bf485ebeb4dd"
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
