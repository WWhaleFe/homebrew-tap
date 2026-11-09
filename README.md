# WWhaleFe Homebrew tap

[flockswitch](https://github.com/WWhaleFe/flockswitch-mac): press one mouse button and move your Logitech mouse **and** keyboard to another computer together.

## macOS (Apple silicon)

```sh
brew install --cask wwhalefe/tap/flockswitch
```

flockswitch is not notarized by Apple, so the first time you open it macOS blocks it. Open System Settings → Privacy & Security and choose **Open Anyway**.

## Linux (x86_64, arm64)

```sh
brew install wwhalefe/tap/flockswitch
```

Then follow the steps `brew info flockswitch` prints: install the udev rule once (with sudo), and optionally add flockswitch to the app menu.

## Updates

```sh
# macOS
brew update && brew upgrade --cask flockswitch
# Linux
brew update && brew upgrade flockswitch
```

On macOS `--cask` is required: without it Homebrew looks for the Linux formula of the same name and fails. This tap follows new flockswitch releases on its own, checking every 30 minutes.

---

## 한국어

[flockswitch](https://github.com/WWhaleFe/flockswitch-mac/blob/main/README.ko.md): 마우스 버튼 하나로 Logitech 마우스와 키보드를 다른 컴퓨터로 함께 옮깁니다.

**macOS (Apple silicon)**

```sh
brew install --cask wwhalefe/tap/flockswitch
```

Apple 공증을 받지 않은 앱이라서, 처음 열 때 macOS가 실행을 막습니다. 시스템 설정 → 개인정보 보호 및 보안에서 **그래도 열기**를 누르세요.

**Linux (x86_64, arm64)**

```sh
brew install wwhalefe/tap/flockswitch
```

설치한 다음 `brew info flockswitch`에 나오는 안내를 따르세요. udev 규칙을 sudo로 한 번 설치하고, 원하면 앱 메뉴에도 추가합니다.

**업데이트**: macOS는 `brew update && brew upgrade --cask flockswitch`, Linux는 `brew update && brew upgrade flockswitch`. macOS에서 `--cask`를 빼면 같은 이름의 Linux용 formula를 찾다가 실패합니다. 이 탭은 30분마다 새 릴리스를 확인해 자동으로 따라갑니다.
