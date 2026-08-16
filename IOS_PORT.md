# iOS Port notes for BleachVsNaruto

## Status

This repository is currently Android-first and not yet configured as a real iOS target.
The project README explicitly lists Android as supported and iOS as not supported:

- README.md: Android checked, iOS unchecked
- build instructions rely on Windows + Flex/AIR + Adobe Animate tooling

## Why GitHub Actions is needed

To build AIR/iOS apps, the runner must be macOS because Apple signing, Xcode, and the iOS AIR tooling are platform-specific. A Linux or Windows runner cannot complete an Apple .ipa build.

## What is included here

This repository now includes:

- .github/workflows/ios-build.yml — a GitHub Actions scaffold for a macOS runner
- tools/script/build_ios.sh — a shell script to compile the project with Flex/AIR on macOS

## Important limitation

This is a CI scaffold, not a complete production iOS port yet.
The project still needs the following to become an actual iOS app:

1. A dedicated iOS shell (for example SHELL_IOS)
2. An iOS-safe app descriptor with InfoAdditions / bundle id / orientation settings
3. Android-only code removal or guard checks
4. Apple code signing and provisioning profile setup
5. Testing on simulator and real device

## Recommended next step

Create a new shell folder, for example `SHELL_IOS/`, based on `SHELL_Mob` and adapt the app XML to the iPhone section.
Then point `APP_ENTRY` in the GitHub Action to that shell and verify the build.

## Example environment variables

```bash
export FLEX_HOME=/path/to/flex4.16.1-air51.0.1.1
export APP_ENTRY=/path/to/project/SHELL_IOS/src/Main.as
export FLEX_CFG=/path/to/project/SHELL_IOS/flex-config.xml
```

## Next milestone

Once the iOS shell is created and the app descriptor is valid, the workflow can be upgraded from a build scaffold to a real signed .ipa build pipeline.
