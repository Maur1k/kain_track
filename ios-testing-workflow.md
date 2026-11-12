# iOS Testing Workflow (No Mac)

Target device: iPhone XR (iOS 18 max)

## Overview
Develop on a Windows or Linux laptop, build the iOS app in the cloud, and install it on the iPhone from the laptop. The repository currently uses a public GitHub repository by explicit project-owner choice; a private repository is recommended because the project contains personal health data structure.

## Steps

1. **Develop on the laptop**
   - Install Flutter and Android Studio.
   - Run `flutter doctor` and confirm the Android setup passes.
   - Test with an Android emulator or the Chrome/web target.

2. **Version control**
   - The project is pushed to `https://github.com/Maur1k/kain_track.git` on the `main` branch.

3. **Build iOS in the cloud**
   - Sign up for Codemagic (free tier, limited macOS build minutes).
   - In Codemagic, choose **Add application**, select **GitHub**, authorize GitHub access, and select `Maur1k/kain_track`.
   - Select the **Flutter** project type and choose the `main` branch.
   - In the workflow selector, choose the repository workflow named **ios-unsigned** from `codemagic.yaml`.
   - Start the build. The workflow runs `flutter pub get`, Drift code generation, `flutter test`, and `flutter build ios --release --no-codesign`.
   - Open the completed build's **Artifacts** tab and download `kain_track-unsigned.ipa`.
   - This workflow intentionally has no certificates, provisioning profiles, Apple credentials, TestFlight publishing, or App Store publishing.

4. **Install on iPhone from Windows**
   - Download and install Sideloadly from `https://sideloadly.io/`.
   - Connect the iPhone XR to the laptop by USB, unlock it, and tap **Trust** if prompted.
   - Open Sideloadly, confirm the connected iPhone XR is selected, and drag `kain_track-unsigned.ipa` into the IPA field.
   - Enter the Apple ID used for free sideloading, then click **Start** and complete any Apple ID verification prompts. Sideloadly applies the free personal signing required for installation; the Codemagic artifact itself is unsigned.
   - On the iPhone, open **Settings > General > VPN & Device Management**, select the Apple ID profile, and tap **Trust** if iOS asks.
   - Launch Kain Track and verify meal, workout, and backup flows. A free Apple ID sideload expires after 7 days and must then be reinstalled.

## Limitations
- Free Apple ID sideloads expire after 7 days; reinstall weekly.
- Only a few sideloaded apps can be active at once.
- Verify that Flutter and all plugins support iOS 18.
- TestFlight or App Store distribution requires the Apple Developer Program ($99/year). Codemagic can sign and upload builds once enrolled.

## Setup Checklist
- [ ] Flutter and Android Studio installed; `flutter doctor` passes
- [ ] GitHub repo created and project pushed
- [ ] Codemagic account connected to `Maur1k/kain_track`
- [ ] Codemagic `ios-unsigned` workflow selected
- [ ] Unsigned iOS `.ipa` build configured
- [ ] Sideloadly installed
- [ ] First build installed on iPhone XR
