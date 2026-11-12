# iOS Testing Workflow (No Mac)

Target device: iPhone XR (iOS 18 max)

## Overview
Develop on a Windows or Linux laptop, build the iOS app in the cloud, and install it on the iPhone from the laptop.

## Steps

1. **Develop on the laptop**
   - Install Flutter and Android Studio.
   - Run `flutter doctor` and confirm the Android setup passes.
   - Test with an Android emulator or the Chrome/web target.

2. **Version control**
   - Create a GitHub repo for the project.
   - Push the code so Codemagic can access it.

3. **Build iOS in the cloud**
   - Sign up for Codemagic (free tier, limited macOS build minutes).
   - Connect the GitHub repo.
   - Configure an unsigned iOS build that outputs an `.ipa`.
   - Download the `.ipa` from the build artifacts.

4. **Install on iPhone from Windows**
   - Install Sideloadly (or AltStore).
   - Connect the iPhone XR by USB.
   - Sign in with a free Apple ID and install the `.ipa`.

## Limitations
- Free Apple ID sideloads expire after 7 days; reinstall weekly.
- Only a few sideloaded apps can be active at once.
- Verify that Flutter and all plugins support iOS 18.
- TestFlight or App Store distribution requires the Apple Developer Program ($99/year). Codemagic can sign and upload builds once enrolled.

## Setup Checklist
- [ ] Flutter and Android Studio installed; `flutter doctor` passes
- [ ] GitHub repo created and project pushed
- [ ] Codemagic account connected to the repo
- [ ] Unsigned iOS `.ipa` build configured
- [ ] Sideloadly installed
- [ ] First build installed on iPhone XR
