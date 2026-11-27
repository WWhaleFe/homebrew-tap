class Flockswitch < Formula
  desc "Share mouse and keyboard across computers, with Logitech Easy-Switch"
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
      url "https://github.com/WWhaleFe/flockswitch-linux/releases/download/v2.5.0/flockswitch-linux-x86_64-2.5.0.tar.gz"
      sha256 "cc154d3a34aab2f614da8ad127a8490f249ded94f197da5147b227ebadce2d09"
    end
    on_arm do
      url "https://github.com/WWhaleFe/flockswitch-linux/releases/download/v2.5.0/flockswitch-linux-aarch64-2.5.0.tar.gz"
      sha256 "37b33674c8bc8bbf51fab35dcb04b435870b4dab66f731ac9dfe4e809b654c45"
    end
  end

  def install
    bin.install "flockswitch"
    (share/"flockswitch").install "flockswitch.png", "70-flockswitch.rules"
    # GNOME helper extension; `flockswitch setup` copies it into the user's extensions.
    (share/"flockswitch").install "gnome-extension"
    # opt paths stay the same across upgrades.
    inreplace "flockswitch.desktop" do |s|
      s.gsub! "@BIN@", opt_bin/"flockswitch"
      s.gsub! "@ICON@", opt_share/"flockswitch/flockswitch.png"
    end
    (share/"applications").install "flockswitch.desktop"
  end

  def caveats
    <<~EOS
      Finish the setup once: the udev rule that lets flockswitch open Logitech receivers and
      devices, the app menu entry, and whatever else this desktop still needs. It lists
      everything, asks once, and needs your password once:
        flockswitch setup
      Then start flockswitch from the app menu (replug the receiver if it was plugged in).
      On GNOME Wayland, setup also installs the flockswitch GNOME helper extension, so the
      system stops asking for input capture and remote control; log out and in once after it.
      `flockswitch setup --dry-run` prints the commands if you prefer to run them yourself.

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
