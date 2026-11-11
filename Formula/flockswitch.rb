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
      url "https://github.com/WWhaleFe/flockswitch-linux/releases/download/v0.10.2/flockswitch-linux-x86_64-0.10.2.tar.gz"
      sha256 "bcfa66016f51c49ca045f7ddfe3613256fbe57ac7202866cbdefd238831bf668"
    end
    on_arm do
      url "https://github.com/WWhaleFe/flockswitch-linux/releases/download/v0.10.2/flockswitch-linux-aarch64-0.10.2.tar.gz"
      sha256 "ae3a5705b9e19906ec65e22befc94a128eeb24b1ea9d6940b70870d254428aa9"
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
