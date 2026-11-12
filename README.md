# WWhaleFe Homebrew tap

[flockswitch](https://github.com/WWhaleFe/flockswitch-mac): press one mouse button and move your Logitech mouse **and** keyboard to another computer together.

## macOS (Apple silicon)

```sh
brew install --cask wwhalefe/tap/flockswitch
```

flockswitch is not notarized by Apple, so the first time you open it macOS blocks it. Open System Settings → Privacy & Security and choose **Open Anyway**.

## Linux (x86_64, arm64)

```sh
brew install --formula wwhalefe/tap/flockswitch && flockswitch setup
```

`flockswitch setup` lists what this desktop still needs (the udev rule, the app menu entry and anything else), asks once and needs your password once. Without Homebrew: `curl -fsSL https://github.com/WWhaleFe/flockswitch-linux/releases/latest/download/get.sh | sh`.

## Updates

```sh
# macOS
brew update && brew upgrade --cask flockswitch
# Linux
brew update && brew upgrade --formula wwhalefe/tap/flockswitch
```

The macOS cask and the Linux formula share the name `flockswitch`, so always say which one: `--cask` on macOS, `--formula` on Linux. Without it Homebrew loads both and stops at the one for the other system.

Homebrew 6 and newer only load taps you trust. Installing with the full name (`wwhalefe/tap/flockswitch`) trusts it; if an upgrade says `Refusing to load … from untrusted tap wwhalefe/tap`, run once `brew trust --cask wwhalefe/tap/flockswitch` (macOS) or `brew trust --formula wwhalefe/tap/flockswitch` (Linux). This tap follows new flockswitch releases on its own, checking every 30 minutes.

## UsageMeter (macOS)

[UsageMeter](https://github.com/WWhaleFe/usagemeter) shows how much of your Claude, Codex and Gemini limits is left, in the menu bar and along the screen edge.

```sh
brew install --cask wwhalefe/tap/usagemeter
brew update && brew upgrade --cask usagemeter   # update
```

If Homebrew refuses with an `untrusted tap` error, run `brew trust --cask wwhalefe/tap/usagemeter` first. The running app restarts itself after an update.

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
brew install --formula wwhalefe/tap/flockswitch && flockswitch setup
```

`flockswitch setup`이 이 데스크톱에 더 필요한 것(udev 규칙, 앱 메뉴 항목 등)을 보여 주고 한 번 묻고, 비밀번호도 한 번만 묻습니다. Homebrew 없이: `curl -fsSL https://github.com/WWhaleFe/flockswitch-linux/releases/latest/download/get.sh | sh`

**업데이트**: macOS는 `brew update && brew upgrade --cask flockswitch`, Linux는 `brew update && brew upgrade --formula wwhalefe/tap/flockswitch`. macOS용 cask와 Linux용 formula가 같은 이름이라 macOS는 `--cask`, Linux는 `--formula`를 꼭 붙이세요. 빼면 Homebrew가 둘 다 읽다가 다른 시스템용에서 멈춥니다.

Homebrew 6 이상은 신뢰한 탭만 읽습니다. 전체 이름(`wwhalefe/tap/flockswitch`)으로 설치하면 자동으로 신뢰되며, 업데이트할 때 `Refusing to load … from untrusted tap wwhalefe/tap` 오류가 나면 한 번만 `brew trust --cask wwhalefe/tap/flockswitch`(macOS) 또는 `brew trust --formula wwhalefe/tap/flockswitch`(Linux)를 실행하세요. 이 탭은 30분마다 새 릴리스를 확인해 자동으로 따라갑니다.

**UsageMeter (macOS)**: 메뉴바와 화면 가장자리에 Claude·Codex·Gemini 잔여 사용량을 보여줍니다.

```sh
brew install --cask wwhalefe/tap/usagemeter
brew update && brew upgrade --cask usagemeter   # 업데이트
```

`untrusted tap` 오류가 나면 먼저 `brew trust --cask wwhalefe/tap/usagemeter`를 실행하세요. 업데이트하면 실행 중인 앱이 스스로 다시 시작합니다.
